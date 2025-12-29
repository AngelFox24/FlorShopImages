import Fluent
import Vapor

func routes(_ app: Application) throws {
    guard let imagesPath = Environment.get("IMAGES_PATH") else {
        fatalError("Missing IMAGES_PATH in configuration in .env\(app.environment)")
    }
    guard let serverPath = Environment.get("SERVER_PATH") else {
        fatalError("Missing SERVER_PATH in configuration in .env\(app.environment)")
    }
    let imageService = ImageService(basePath: imagesPath, baseDomain: serverPath)
    try app.register(collection: ImageController(imageService: imageService))
}
