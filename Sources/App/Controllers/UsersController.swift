//
//  UsersController.swift
//
//
//  Created by Tran Viet Anh on 26/02/2024.
//

import Vapor
import Fluent

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // Tạo một nhóm routes và áp dụng middleware để xác thực token
        let tokenProtected = routes.grouped(UserToken.authenticator())
        tokenProtected.get("me") { req -> User in
            try req.auth.require(User.self)
        }
        tokenProtected.group("user") { users in
            users.group(User.guardMiddleware()) { guardedUsers in
                guardedUsers.get(use: index) 
                guardedUsers.post(use: create)
                
                guardedUsers.group(":id") { user in
                    user.group(User.guardMiddleware()) { guardedUser in
                        guardedUser.get(use: show)
                        guardedUser.put(use: update)
                        guardedUser.delete(use: delete)
                    }
                }
            }
        }
    }

    func index(req: Request) async throws -> [User] {

        return try await User.query(on: req.db).all()
    }
    func create(req: Request) async throws -> User {
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
            name: create.name,
            email: create.email,
            passwordHash: Bcrypt.hash(create.password)
        )
        try await user.save(on: req.db)
        return user
    }

    func show(req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }

    func update(req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedUser = try req.content.decode(User.self)
        
        user.name = updatedUser.name
        user.passwordHash = updatedUser.passwordHash
        try await user.save(on: req.db)
        return user
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .ok
    }
}
extension User {
    struct Create: Content {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
    }
}
extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}
extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
extension User {
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}
extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        true
    }
}
