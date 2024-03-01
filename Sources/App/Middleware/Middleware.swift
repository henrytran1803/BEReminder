//
//  Middleware.swift
//
//
//  Created by Tran Viet Anh on 01/03/2024.
//
import AuthenticationServices
import Vapor

struct UserGuardMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        // Xác thực người dùng
        do {
            try request.auth.require(User.self)
            return next.respond(to: request)
        } catch {
            return request.eventLoop.makeFailedFuture(Abort(.unauthorized))
        }
    }
}
