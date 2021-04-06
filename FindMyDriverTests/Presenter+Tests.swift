import XCTest
import RxSwift
import CoreLocation
@testable import FindMyDriver

class Presenter_Tests: XCTestCase {
    let disposeBag = DisposeBag()

    override func setUp() { }
    func test_givenTappedItemInPresenter_interactorIsNotified() {
        let interactor = MockFindDriverInteractor()
        let presenter = FindDriverPresenter(interactor: interactor, router: FindDriverRouter(rootViewController: UINavigationController()))

        let expectation = XCTestExpectation(description: "Should Ask twice for updated position")
        presenter.selectedDriver.subscribe(onNext: { selectedDriver in
            selectedDriver!.action?()
        }).disposed(by: disposeBag)

        interactor.tappedDriverSubject.subscribe(onNext: { (tappedDriver) in
            expectation.fulfill()
        }).disposed(by: disposeBag)
    }

}

class MockFindDriverInteractor: FindDriverInteractable {
    var availableDrivers: Observable<[Driver]> = Observable.just([mockDriver])
    var userLocation: Observable<CLLocation> = Observable.just(CLLocation(latitude: 2.2, longitude: 4.4))
    var selectedDriver: Observable<Driver?> = Observable.just(mockDriver)
    var tappedDriverSubject = PublishSubject<DriverViewModel>()
}
fileprivate let mockDriver = Driver(id: 1,
                                    firstname: "John",
                                    lastname: "Doe",
                                    image: "http",
                                    coordinates: Coordinates(latitude: 2.2, longitude: 4.4))
