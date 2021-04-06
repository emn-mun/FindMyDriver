import Foundation
import RxSwift
import CoreLocation

protocol FindDriverInteractable {
  var availableDrivers: Observable<[Driver]> { get }
  var userLocation: Observable<CLLocation> { get }
  var selectedDriver: Observable<Driver?> { get }
  var tappedDriverSubject: PublishSubject<DriverViewModel> { get }
}

class FindDriverInteractor: FindDriverInteractable {
  let availableDrivers: Observable<[Driver]>
  let selectedDriver: Observable<Driver?>
  var userLocation: Observable<CLLocation>
  let tappedDriverSubject = PublishSubject<DriverViewModel>()
  
  private let disposeBag = DisposeBag()
  private let locationManagerInteractor: LocationManagerInteractable
  
  init(service: LoadDriverServiceProtocol,
       locationManagerInteractor: LocationManagerInteractable = LocationManagerInteractor(),
       refreshDriverPositionInterval: TimeInterval = 5) {
    
    self.userLocation = locationManagerInteractor.userLocation
    self.locationManagerInteractor = locationManagerInteractor
    
    let timerObservable = Observable<Int>.timer(0, period: refreshDriverPositionInterval, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
    availableDrivers = userLocation
        .flatMap {
            service.loadAvailableDrivers(for: Coordinates(latitude: $0.coordinate.latitude,
                                                          longitude: $0.coordinate.longitude)) }
        .distinctUntilChanged()
        .observeOn(MainScheduler.instance)

    let refreshDrivers = Observable.combineLatest(timerObservable,
                                                  availableDrivers,
                                                  tappedDriverSubject.asObservable()) { _, allDrivers, selectedDriver in
                                                    return locationManagerInteractor.userLocation.flatMap {
                                                        service.loadAvailableDrivers(for: Coordinates(latitude: $0.coordinate.latitude,
                                                                                                      longitude: $0.coordinate.longitude)) }
                                                        .asObservable()
        }.flatMap {  $0 }

    selectedDriver = refreshDrivers
        .withLatestFrom(tappedDriverSubject.asObservable(), resultSelector: { allDrivers, selectedDriver in
            return allDrivers.first(where: { $0.id == selectedDriver.driver.id })
        })
    }
}
