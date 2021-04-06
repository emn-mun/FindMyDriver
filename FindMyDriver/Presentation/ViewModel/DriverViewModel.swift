import UIKit
import RxSwift
import CoreLocation

struct AddressInfo {
  let address: String?
  let locality: String?
  let country: String?
}

final class DriverViewModel {
  let driver: Driver
  var action: (() -> Void)?
  private (set) var image: UIImage? = nil
  let addressInfo: Observable<AddressInfo>
  private let disposeBag = DisposeBag()
  
  init(driver: Driver, action: (() -> Void)? = nil) {
    self.driver = driver
    self.action = action
    
    let location = CLLocation(latitude: driver.coordinates.latitude, longitude: driver.coordinates.longitude)
    self.addressInfo = CLGeocoder().rx
      .placemark(with: location)
      .map { AddressInfo(address: $0.name,
                         locality: "\($0.postalCode ?? "") \($0.locality ?? "")",
                         country: $0.country)
      }
    
    let request = Request<UIImage>
      .get(at: driver.image, input: Request.Input.none, output: Request.Output.image)
    let api = API(scheme: "http", host: "hiring.heetch.com")
    api.result(for: request)
      .asObservable()
      .subscribe(onNext: { (image) in
          self.image = image
      }).disposed(by: disposeBag)
  }
}

extension DriverViewModel: Equatable {
  static func == (lhs: DriverViewModel, rhs: DriverViewModel) -> Bool {
    return lhs.driver == rhs.driver
  }
}


