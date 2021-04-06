import XCTest
@testable import FindMyDriver
import RxSwift
import CoreLocation

class Interactor_Tests: XCTestCase {
  let disposeBag = DisposeBag()
  
  override func setUp() {}
  
  func test_givenCoordinates_locationIsFetched() {
    let mockLoadDriverService = MockLoadDriverService()
    
    let interactor = FindDriverInteractor(service: mockLoadDriverService, locationManagerInteractor: MockLocationManagerInteractor())
    let expectation = XCTestExpectation(description: "Should fetch based on location")
    interactor.availableDrivers.subscribe(onNext: { (drivers) in
      expectation.fulfill()
      XCTAssertEqual(drivers.first!.id, 1)
      XCTAssertEqual(drivers.first!.firstname, "John")
      XCTAssertEqual(drivers.first!.lastname, "Doe")
      XCTAssertEqual(drivers.first!.image, "http")
      XCTAssertEqual(drivers.first!.coordinates, Coordinates(latitude: 2.2, longitude: 4.4))
      
      XCTAssertEqual(mockLoadDriverService.calledMethods, ["loadAvailableDrivers(for:)"])
    }).disposed(by: disposeBag)
    
    wait(for: [expectation], timeout: 0.1)
  }
  
  func test_givenTimeToRefresh_driverLocationUpdatedTwice() {
    let mockLoadDriverService = MockLoadDriverService()
    let interactor = FindDriverInteractor(service: mockLoadDriverService, locationManagerInteractor: MockLocationManagerInteractor(), refreshDriverPositionInterval: 0.5)
    let expectation = XCTestExpectation(description: "Should Ask twice for updated position")

    interactor.selectedDriver.subscribe(onNext: { drivers in
        if mockLoadDriverService.calledMethods.count > 1 {
            expectation.fulfill()
            XCTAssertEqual(mockLoadDriverService.calledMethods, ["loadAvailableDrivers(for:)", "loadAvailableDrivers(for:)"])
        }
    }).disposed(by: disposeBag)

    interactor.tappedDriverSubject.onNext(DriverViewModel(driver: mockDriver))
    wait(for: [expectation], timeout: 1)
  }
}

class MockLoadDriverService: MockBase, LoadDriverServiceProtocol {
  func loadAvailableDrivers(for coordinates: Coordinates) -> Single<[Driver]> {
    track(method: #function)
    return Single.just([mockDriver])
  }
}

class MockLocationManagerInteractor: LocationManagerInteractable {
  let userLocation: Observable<CLLocation> = Observable.just(CLLocation(latitude: 48.858181, longitude: 2.348090))
}

fileprivate let mockDriver = Driver(id: 1,
                        firstname: "John",
                        lastname: "Doe",
                        image: "http",
                        coordinates: Coordinates(latitude: 2.2, longitude: 4.4))
