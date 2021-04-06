import Foundation
import XCTest
@testable import FindMyDriver

class NetworkTests : XCTestCase {

    private struct TestResponse : Decodable {
        let id: Int
        let name: String
        let coordinate: Coordinate
        struct Coordinate : Codable {
            let latitude: Double
            let longitude: Double
        }
    }

    private let api = API(scheme: "http", host: "hiring.heetch.com")
    private let path = "/test/response"
    private let coordinate = TestResponse.Coordinate(latitude: 48.858181, longitude: 2.348090)
    private let result: String = """
    {
        "id": 1,
        "name": "John Appleseed",
        "coordinate": {
            "latitude": 48.86,
            "longitude": 2.34
        }
    }
    """

    func testGET() throws {
        // Given
        let request = Request<TestResponse>.get(
            at: path,
            input: .none,
            output: .json
        )

        // When
        let urlRequest = try api.urlRequest(for: request)

        // Then
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.url?.absoluteString, "http://hiring.heetch.com/test/response")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["Content-Type": "application/json"])
    }

    func testPUT() throws {
        // Given
        let request = try Request<TestResponse>.put(
            at: path,
            input: .json(coordinate),
            output: .json
        )

        // When
        let urlRequest = try api.urlRequest(for: request)

        // Then
        XCTAssertEqual(urlRequest.httpMethod, "PUT")
        XCTAssertEqual(urlRequest.url?.absoluteString, "http://hiring.heetch.com/test/response")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["Accept": "application/json", "Content-Type": "application/json"])

        guard let httpBody = urlRequest.httpBody else {
            return XCTFail("httBody must not be nil")
        }

        let body = String(decoding: httpBody, as: UTF8.self)
        XCTAssertTrue(body.contains("\"latitude\":48.85"))
        XCTAssertTrue(body.contains("\"longitude\":2.34"))
    }

    func testDecodeJSON() throws {
        // Given
        let request = try Request<TestResponse>.put(
            at: path,
            input: .json(coordinate),
            output: .json
        )

        // When
        let response = try request.decode(Data(result.utf8))

        // Then
        XCTAssertEqual(response.id, 1)
        XCTAssertEqual(response.name, "John Appleseed")
        XCTAssertEqual(response.coordinate.latitude, 48.86, accuracy: 0.01)
        XCTAssertEqual(response.coordinate.longitude, 2.34, accuracy: 0.01)
    }

}
