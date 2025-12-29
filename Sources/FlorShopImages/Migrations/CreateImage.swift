import Fluent

struct CreateImage: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(Image.schema)
            .id()
            .field("image_cic", .string, .required)
            .field("imageUrl", .string, .required)
            .field("imageHash", .string, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "image_cic")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Image.schema).delete()
    }
}
