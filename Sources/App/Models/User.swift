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
}
//extension User: ModelAuthenticatable {
//    static let usernameKey = \User.$email
//    static let passwordHashKey = \User.$passwordHash
//                    
//    func verify(password: String) throws -> Bool {
//        try Bcrypt.verify(password, created: self.passwordHash)
//    }
//}


