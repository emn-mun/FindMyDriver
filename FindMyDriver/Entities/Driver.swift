import Foundation

struct Driver: Equatable, Codable {
  let id: Int
  let firstname: String
  let lastname: String
  let image: String
  let coordinates: Coordinates
}

struct Coordinates: Equatable, Codable {
  let latitude: Double
  let longitude: Double
}
