import Foundation

extension Request {
public struct Input<T: Encodable> {
    public let accept: String?
    public let data: Data?
    private init(accept: String?, data: Data?) {
        self.accept = accept
        self.data = data
    }

    public static func json<T: Encodable>(_ value: T) throws -> Input<T> {
        return Request.Input<T>(accept: "application/json", data: try JSONEncoder().encode(value))
    }
}
}

extension Never : Encodable {
    public func encode(to encoder: Encoder) throws {

    }
}

extension Request.Input where T == Never {
    public static var none: Request.Input<Never> {
        return Request.Input<Never>(accept: nil, data: nil)
    }
}
