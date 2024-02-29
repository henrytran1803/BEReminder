//
//  CreateUser.swift
//
//
//  Created by Tran Viet Anh on 26/02/2024.
//
import Fluent
import Vapor
extension User{
    struct CreateUser: AsyncMigration {

            func prepare(on database: Database) async throws {
                try await database.schema("users")
                    .id()
                    .field("name", .string, .required)
                    .field("email", .string, .required)
                    .field("password_hash", .string, .required)
                    .unique(on: "email")
                    .create()
            }

            func revert(on database: Database) async throws {
                try await database.schema("users").delete()
            }
    }
}

