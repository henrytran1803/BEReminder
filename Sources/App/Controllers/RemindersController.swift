//
//  RemindersController.swift
//
//
//  Created by Tran Viet Anh on 26/02/2024.
//


import Vapor

struct RemindersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let reminders = routes.grouped("reminder")
        reminders.get(use: index)
        reminders.post(use: create)

        reminders.group(":id") { reminder in
            reminder.get(use: show)
            reminder.put(use: update)
            reminder.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Reminder] {
        try await Reminder.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Reminder {
        let reminder = try req.content.decode(Reminder.self)
        try await reminder.save(on: req.db)
        return reminder
    }

    func show(req: Request) async throws -> Reminder {
        guard let reminder = try await Reminder.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return reminder
    }

    func update(req: Request) async throws -> Reminder {
        guard let reminder = try await Reminder.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updatedReminder = try req.content.decode(Reminder.self)
        reminder.title = updatedReminder.title
        reminder.body = updatedReminder.body
        reminder.createat = Date.now
        try await reminder.save(on: req.db)
        return reminder
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let reminder = try await Reminder.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await reminder.delete(on: req.db)
        return .ok
    }
}
