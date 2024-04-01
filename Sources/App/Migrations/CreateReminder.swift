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
                .field("status", .bool, .required)
                .field("createat", .datetime, .required)
                .field("user_id", .uuid, .required, .references("users", "id"))
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("reminder").delete()
        }
    }
}

struct ModifyReminder: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Update the Reminder table, add or modify columns as needed
        database.schema("reminder")
            .field("status", .bool) // Example: Adding a new column
            .update()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("reminders").deleteField("status")
            .update()
    }
}
