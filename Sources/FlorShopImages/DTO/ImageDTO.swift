import Vapor

struct ImageInputDTO: Sendable, Codable {
    let imageData: Data
}

struct ImageOutputDTO: Sendable, Content {
    let imageURL: String
}
