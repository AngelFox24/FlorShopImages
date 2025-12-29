import Vapor
import Fluent
import FlorShopDTOs

enum TypeOfCreation {
    case createByURL(url: String, hash: String)
    case createByData(data: Data, hash: String)
}

struct ImageService {
    let basePath: String
    let baseDomain: String
    

    // MARK: - Métodos privados
    
    func getPathById(id: UUID) -> String {
        let filename = id.uuidString + ".jpg"
        let filePath = self.basePath + "/" + filename
        return filePath
    }
    func fileExists(id: UUID) -> Bool {
        let fileManager = FileManager.default
        let filePath = self.basePath + "/" + id.uuidString + ".jpg"
        let result = fileManager.fileExists(atPath: filePath)
        print("Se esta verificado que exista la imagen: \(result) file: \(filePath)")
        return result
    }
    func getPathById(imageCic: String) -> String {
        let filename = imageCic + ".jpg"
        let filePath = self.basePath + "/" + filename
        return filePath
    }
    func fileExists(imageCic: String) -> Bool {
        let fileManager = FileManager.default
        let filePath = self.basePath + "/" + imageCic + ".jpg"
        let result = fileManager.fileExists(atPath: filePath)
        print("Se esta verificado que exista la imagen: \(result) file: \(filePath)")
        return result
    }
    func createFile(imageCic: String, imageData: Data) throws {
        // Crear el directorio si no existe
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(atPath: self.basePath + "/", withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error al crear el directorio de imágenes: \(error)")
            throw Abort(.badRequest, reason: "Error al crear el directorio de imágenes: \(error)")
        }
        // Escribir los datos de la imagen en el archivo
        fileManager.createFile(atPath: getPathById(imageCic: imageCic), contents: imageData, attributes: nil)
    }
    func getImageUrlByHash(hash: String, db: any Database) async throws -> Image? {
        return try await Image.query(on: db)
            .filter(\.$imageHash == hash)
            .first()
    }
    func getImageUrlByUrl(url: String, db: any Database) async throws -> Image? {
        return try await Image.query(on: db)
            .filter(\.$imageUrl == url)
            .first()
    }
}
