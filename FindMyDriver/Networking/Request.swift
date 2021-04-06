import Foundation

public struct Request<T> {
    public let method: Method
    public let path: String
    public let headers: [String: String]
    public let parameters: [String: String]
    public let body: Data?
    public let output: Output<T>

    private init(method: Method, path: String, headers: [String: String] = [:], parameters: [String: String] = [:], body: Data? = nil, output: Output<T>) {
        self.method = method
        self.path = path
        self.headers = headers
        self.parameters = parameters
        self.body = body
        self.output = output
    }

    public static func get<U: Encodable>(at path: String, input: Input<U>, output: Output<T>) -> Request<T> {
        return Request<T>(
            method: .get,
            path: path,
            headers: ["Accept": input.accept, "Content-Type": output.contentType].compactMapValues({ $0 }),
            output: output
        )
    }

    public static func put<U: Encodable>(at path: String, input: Input<U>, output: Output<T>) throws -> Request<T>  {
        return Request<T>(
            method: .put,
            path: path,
            headers: ["Accept": input.accept, "Content-Type": output.contentType].compactMapValues({ $0 }),
            body: input.data,
            output: output
        )
    }

    public static func post<U: Encodable>(at path: String, input: Input<U>, output: Output<T>) throws -> Request<T>  {
        return Request<T>(
            method: .post,
            path: path,
            headers: ["Accept": input.accept, "Content-Type": output.contentType].compactMapValues({ $0 }),
            body: input.data,
            output: output
        )
    }

    public func decode(_ data: Data) throws -> T {
        return try output.decode(data)
    }

}
