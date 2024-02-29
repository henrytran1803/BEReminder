import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor
extension User: ModelSessionAuthenticatable { }
// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tlsConfiguration: tls
    ), as: .mysql)

    app.migrations.add(User.CreateUser())
    app.migrations.add(Reminder.CreateReminder())
    app.migrations.add(UserToken.CreateUserToken())
    // register routes
    app.middleware.use(app.sessions.middleware)
    app.middleware.use(User.sessionAuthenticator(.mysql))
    try routes(app)
}
 
