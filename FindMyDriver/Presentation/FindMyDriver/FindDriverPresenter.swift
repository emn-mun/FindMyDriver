import Foundation
import RxSwift
import RxCocoa
import CoreLocation

protocol FindDriverPresentable {
    var availableDrivers: Observable<[DriverViewModel]> { get }
    var selectedDriver: Observable<DriverViewModel?> { get }
    var userLocation: Observable<CLLocation> { get }
}

class FindDriverPresenter: FindDriverPresentable {
    private let interactor: FindDriverInteractable
    private let router: FindDriverRoutable
    private let disposeBag = DisposeBag()

    let selectedDriver: Observable<DriverViewModel?>
    let availableDrivers: Observable<[DriverViewModel]>
    let userLocation: Observable<CLLocation>

    init(interactor: FindDriverInteractable, router: FindDriverRoutable) {
        self.interactor = interactor
        self.router = router
        self.userLocation = interactor.userLocation

        selectedDriver = interactor.selectedDriver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { driver in
            guard let driver = driver else { return nil }
            let viewModel = DriverViewModel(driver: driver)
            viewModel.action = { interactor.tappedDriverSubject.onNext(viewModel) }
            return viewModel
        }
        .observeOn(MainScheduler.instance)


        availableDrivers = interactor.availableDrivers
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { drivers in
                let driverViewModels = drivers.map { driver -> DriverViewModel in
                    let viewModel = DriverViewModel(driver: driver)
                    viewModel.action = { interactor.tappedDriverSubject.onNext(viewModel) }
                    return viewModel
                }
                return driverViewModels
            }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
    }
}
