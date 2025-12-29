import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) async throws {
    app.http.server.configuration.hostname = app.getHostname()
    app.http.server.configuration.port = app.getPort()
    app.routes.defaultMaxBodySize = "10mb"
    try app.configLogger()
    app.databases.use(try app.getFactory(), as: app.getDatabaseID())
    app.migrations.add(CreateImage())
    try await app.autoMigrate()
    try routes(app)
}
