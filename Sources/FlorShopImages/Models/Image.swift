import Fluent
import Foundation
import struct Foundation.UUID

final class Image: Model, @unchecked Sendable {
    static let schema = "images"
    
    @ID(key: .id) var id: UUID?
    
    @Field(key: "image_cic") var imageCic: String
    @Field(key: "imageUrl") var imageUrl: String
    @Field(key: "imageHash") var imageHash: String
    
    //MARK: Timestamps
    @Timestamp(key: "created_at", on: .create) var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?
    
    init() { }
    
    init(
        imageCic: String,
        imageUrl: String,
        imageHash: String
    ) {
        self.imageCic = imageCic
        self.imageUrl = imageUrl
        self.imageHash = imageHash
    }
}

extension Image {
    static func findImage(imageCic: String, on db: any Database) async throws -> Image? {
        try await Image.query(on: db)
            .filter(Image.self, \.$imageCic == imageCic)
            .first()
    }
}
