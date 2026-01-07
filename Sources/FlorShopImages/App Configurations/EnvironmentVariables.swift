import Vapor

enum EnvironmentVariables: String {
    case logLevel = "LOG_LEVEL"
    case httpServerHost = "HTTP_SERVER_HOST"
    case httpServerPort = "HTTP_SERVER_PORT"
    case dataBaseHost = "DATABASE_HOST"
    case dataBaseName = "DATABASE_NAME"
    case dataBasePort = "DATABASE_PORT"
    case dataBaseUserName = "DATABASE_USERNAME"
    case dataBasePassword = "DATABASE_PASSWORD"
    case imagePath = "IMAGES_PATH"
    case serverUrl = "SERVER_URL"
}

extension EnvironmentVariables: CaseIterable {
    static func validate(envName: String) throws {
        let allCases = Self.allCases
        for envVar in allCases {
            guard let _ = Environment.get(envVar.rawValue) else {
                throw Abort(.internalServerError, reason: "\(envVar.rawValue) don't found in .env.\(envName)")
            }
        }
    }
}
