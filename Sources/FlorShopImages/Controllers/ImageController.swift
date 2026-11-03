import Fluent
import Vapor

struct ImageController: RouteCollection {
    let imageService: ImageService
    func boot(routes: any RoutesBuilder) throws {
        let imageUrl = routes.grouped("image")
        imageUrl.get(use: self.serveImage)
        imageUrl.post(use: self.saveImage)
    }
    //GET: /image?cic=78afs8fs8778saf78
    @Sendable
    func serveImage(req: Request) async throws -> Response {
        guard let imageCic = try? req.query.get(String.self, at: "cic") else {
            throw Abort(.badRequest, reason: "No image ID provided")
        }
        guard let imageEntity = try await Image.findImage(imageCic: imageCic, on: req.db) else {
            throw Abort(.notFound, reason: "Image not found")
        }
        guard imageService.fileExists(imageCic: imageEntity.imageCic) else {
            throw Abort(.notFound, reason: "Image not found")
        }
        // Ruta donde se almacenan las imágenes en el servidor
        let imageDirectory: String = imageService.getPathById(imageCic: imageEntity.imageCic)
        // Crear la respuesta con el contenido de la imagen
        return try await req.fileio.asyncStreamFile(at: imageDirectory)
    }
    //POST: /image
    @Sendable
    func saveImage(req: Request) async throws -> ImageOutputDTO {
        let imageUrlDto = try req.content.decode(ImageInputDTO.self)
        // Buscar por hash (deduplicación)
        let hash = imageUrlDto.imageData.sha256String()
        if let existing = try await imageService.getImageUrlByHash(hash: hash, db: req.db) {
            let imageUrl: String = imageService.baseDomain + "/image?cic=" + existing.imageCic
            print(imageUrl)
            return ImageOutputDTO(imageURL: imageUrl)
        }
        //Create a new image cic identifier
        let newImageCic = UUID().uuidString
        
        //Guarda imagen en carpeta
        if !imageService.fileExists(imageCic: newImageCic) {
            //Save imageData in localStorage
            try imageService.createFile(imageCic: newImageCic, imageData: imageUrlDto.imageData)
            guard imageService.fileExists(imageCic: newImageCic) else {
                throw Abort(.badRequest, reason: "Se verifico que la imagen creada no existe")
            }
        }
        
        let imageUrl = imageService.baseDomain + "/image?cic=" + newImageCic
        let imageNew = Image(
            imageCic: newImageCic,
            imageHash: hash,
        )
        try await imageNew.save(on: req.db)
        return ImageOutputDTO(imageURL: imageUrl)
    }
}

