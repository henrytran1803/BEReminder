import Fluent
import Vapor
func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }
    
    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    let passwordProtected = app.grouped(User.authenticator())
    passwordProtected.post("login") { req async throws -> UserToken in
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        try await token.save(on: req.db)
        return token
    }
    
//    let passwordProtected = app.grouped(User.authenticator())
//    passwordProtected.post("login") { req -> User in
//        try req.auth.require(User.self)
//    }

    try app.register(collection: UsersController())
    try app.register(collection: RemindersController())
//    let passwordProtected = app.grouped(User.authenticator())
//    passwordProtected.post("login") { req async throws -> UserToken in
//        let user = try req.auth.require(User.self)
//        let token = try user.generateToken()
//        try await token.save(on: req.db)
//        return token
//    }
//    let tokenProtected = app.grouped(UserToken.authenticator())
//    tokenProtected.get("me") { req -> User in
//        try req.auth.require(User.self)
//    }

}
//extension UserToken: ModelTokenAuthenticatable {
//    static let valueKey = \UserToken.$value
//    static let userKey = \UserToken.$user
//
//    var isValid: Bool {
//        true
//    }


//struct UserAuthenticator: BasicAuthenticator {
//    typealias User = App.User
//
//    func authenticate(
//        basic: BasicAuthorization,
//        for request: Request
//    ) -> EventLoopFuture<Void> {
//        if basic.username == "test" && basic.password == "secret" {
//            request.auth.login(User(name: <#T##String#>, email: <#T##String#>, passwordHash: <#T##String#>))
//        }
//        return request.eventLoop.makeSucceededFuture(())
//   }
//}

