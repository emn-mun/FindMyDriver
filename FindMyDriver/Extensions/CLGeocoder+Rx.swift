import RxSwift
import CoreLocation

extension Reactive where Base: CLGeocoder {
  func placemark(with location: CLLocation) -> Observable<CLPlacemark> {
    return Observable.create { observer in
      let geocoder = CLGeocoder()
      geocoder.reverseGeocodeLocation(location) { placemarks, _ in
        observer.onNext(placemarks?.first)
      }
      return Disposables.create {
        observer.onCompleted()
      }
      }.flatMap { Observable.from(optional: $0) }
  }
}
