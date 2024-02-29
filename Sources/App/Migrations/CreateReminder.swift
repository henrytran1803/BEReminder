//
//  CreateReminder.swift
//
//
//  Created by Tran Viet Anh on 26/02/2024.
//

import Fluent
extension Reminder{
    struct CreateReminder: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema("reminder")
                .id()
                .field("title", .string, .required)
                .field("body", .string, .required)
                .field("createat", .datetime, .required)
                .field("user_id", .uuid, .required, .references("users", "id"))
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("reminder").delete()
        }
    }
}

