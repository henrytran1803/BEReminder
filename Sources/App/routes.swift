import Fluent
import Vapor
import OpenAPIRuntime
import OpenAPIVapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    
    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    let passwordProtected = app.grouped(User.authenticator())
    passwordProtected.post("login") { req async throws -> LoginResponse in
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        try await token.save(on: req.db)
        return LoginResponse(status: true, token: token)
    }
    

    // Register your API controllers
    try app.register(collection: UsersController())
    try app.register(collection: RemindersController())

    // Register the raw file middleware, which serves files from the Public directory, including
    // the openapi.yaml and openapi.html files.
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Redirect /openapi to /openapi.html
    app.get("openapi") { req in
        return req.redirect(to: "/openapi.html", type: .permanent)
    }

}

struct LoginResponse: Content {
    let status: Bool
    let token: UserToken
}
