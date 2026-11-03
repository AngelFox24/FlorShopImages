import Fluent
import Vapor

func routes(_ app: Application) throws {
    let imagesPath = Environment.get(EnvironmentVariables.imagePath.rawValue)!
    let serverUrl = Environment.get(EnvironmentVariables.serverUrl.rawValue)!
    print("Ima: \(imagesPath)")
    let imageService = ImageService(basePath: imagesPath, baseDomain: serverUrl)
    try app.register(collection: ImageController(imageService: imageService))
}
