//
//  Reminder.swift
//
//
//  Created by Tran Viet Anh on 26/02/2024.
//
import Fluent
import Vapor
final class Reminder: Model, Content {
    static let schema = "reminder"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "body")
    var body: String?
    @Field(key: "status")
    var status: Bool?
    @Timestamp(key: "createat", on: .create)
    var createat: Date?
    
    @Parent(key: "user_id")
    var user: User
    
    init() {
        
    }
    init(id: UUID? = nil, title: String, body: String? = nil,status: Bool? = false, createat: Date? = nil, user: User) {
        self.id = id
        self.title = title
        self.body = body
        self.status = status
        self.createat = createat
        self.user = user
    }


}
