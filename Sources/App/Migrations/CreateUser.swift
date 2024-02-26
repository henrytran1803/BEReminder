//
//  CreateUser.swift
//
//
//  Created by Tran Viet Anh on 26/02/2024.
//
import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("user")
            .id()
            .field("name", .string, .required)
            .field("password", .string, .required)
            .field("createat", .datetime, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("user").delete()
    }
}
