//
//  User.swift
//
//
//  Created by Tran Viet Anh on 26/02/2024.
//
import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String

    init() { }

    init(id: UUID? = nil, name: String, email: String, passwordHash: String) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
    }
    init( email: String) {
        self.email = email
    }
}
//extension User: ModelAuthenticatable {
//    static let usernameKey = \User.$email
//    static let passwordHashKey = \User.$passwordHash
//                    
//    func verify(password: String) throws -> Bool {
//        try Bcrypt.verify(password, created: self.passwordHash)
//    }
//}
//extension User: SessionAuthenticatable {
//    var sessionID: String {
//        self.email
//    }
//}
//
//
//struct UserSessionAuthenticator: AsyncSessionAuthenticator {
//    typealias User = App.User
//    func authenticate(sessionID: String, for request: Request) async throws {
//        let user = User(email: sessionID)
//        request.auth.login(user)
//    }
//}
//
//struct UserBearerAuthenticator: AsyncBearerAuthenticator {
//    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
//        if bearer.token == "test" {
//            let user = User(email: "hello@vapor.codes")
//            request.auth.login(user)
//        }
//    }
//}
