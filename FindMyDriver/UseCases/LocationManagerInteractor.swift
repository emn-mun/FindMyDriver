import RxSwift
import CoreLocation

protocol LocationManagerInteractable {
  var userLocation: Observable<CLLocation> { get }
}

class LocationManagerInteractor: LocationManagerInteractable {
  private let locationManager = CLLocationManager()
  private let disposeBag = DisposeBag()
  
  let userLocation: Observable<CLLocation>
  
  init() {
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    let defaultCoordiantes = CLLocation(latitude: 48.858181, longitude: 2.348090)
    let userLocationSubject = ReplaySubject<CLLocation>.create(bufferSize: 1)
    userLocation = userLocationSubject.asObservable().observeOn(MainScheduler.instance)

    locationManager.rx.didUpdateLocations.first().asObservable()
      .subscribe(onNext: { foundLocations in
        if let location = foundLocations?.first {
          userLocationSubject.onNext(location)
        } else {
          userLocationSubject.onNext(defaultCoordiantes)
        }
      }, onError: { _ in
        userLocationSubject.onNext(defaultCoordiantes)
      }).disposed(by: disposeBag)
    
    locationManager.rx.didChangeAuthorizationStatus.subscribe(onNext: { (status) in
      if status == .denied {
        userLocationSubject.onNext(defaultCoordiantes)
      }
    }).disposed(by: disposeBag)
  }
}
