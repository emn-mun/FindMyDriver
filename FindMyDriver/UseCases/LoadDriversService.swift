import Foundation
import RxSwift

protocol LoadDriverServiceProtocol {
  func loadAvailableDrivers(for coordinates: Coordinates) -> Single<[Driver]>
}

class LoadDriversService: LoadDriverServiceProtocol {
  func loadAvailableDrivers(for coordinates: Coordinates) -> Single<[Driver]> {
    let params = ["latitude": coordinates.latitude, "longitude": coordinates.longitude]
    do {
      let request = try Request<[Driver]>
        .put(at: "/mobile/coordinates", input: Request.Input<[String: String]>.json(params), output: Request.Output.json)
      
      let api = API(scheme: "http", host: "hiring.heetch.com")
      return api.result(for: request)
    } catch {
      return Single.error(FindDriverError.apiRequestFailed)
    }
    
  }
}

enum FindDriverError: Error {
  case apiRequestFailed
  
  var localizedDescription: String {
    switch self {
    case .apiRequestFailed:
      return .localized("failed.request")
    }
  }
}

