import Foundation
import RxSwift
import RxCocoa

public struct API {

    public enum Error: Swift.Error {
        case invalidURL(components: URLComponents)
    }

    public let scheme: String
    public let host: String

    public init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }

    public func url<T>(for request: Request<T>) throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = request.path
        components.queryItems = request.parameters.isEmpty ? nil : request.parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        guard let url = components.url else {
            throw Error.invalidURL(components: components)
        }
        return url
    }

    public func urlRequest<T>(for request: Request<T>) throws -> URLRequest {
        let url = try self.url(for: request)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        for (headerField, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: headerField)
        }

        return urlRequest
    }

    public func result<T>(for request: Request<T>) -> Single<T> {
        do {
            return URLSession.shared.rx
                .data(
                    request: try urlRequest(for: request)
                )
                .map { data in
                    try request.decode(data)
                }
                .asSingle()

        } catch {
            return Single<T>.error(error)
        }
    }

}
