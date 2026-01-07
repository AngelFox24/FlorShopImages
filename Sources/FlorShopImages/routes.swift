import Fluent
import Vapor

func routes(_ app: Application) throws {
    guard let imagesPath = Environment.get(EnvironmentVariables.imagePath.rawValue) else {
        fatalError("Missing \(EnvironmentVariables.imagePath.rawValue) in configuration in .env\(app.environment)")
    }
    guard let serverUrl = Environment.get(EnvironmentVariables.serverUrl.rawValue) else {
        fatalError("Missing \(EnvironmentVariables.serverUrl.rawValue) in configuration in .env\(app.environment)")
    }
    let imageService = ImageService(basePath: imagesPath, baseDomain: serverUrl)
    try app.register(collection: ImageController(imageService: imageService))
}
