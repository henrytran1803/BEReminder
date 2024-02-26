//
//  User.swift
//
//
//  Created by Tran Viet Anh on 26/02/2024.
//
import Fluent
import Vapor
final class User: Model, Content {
    static let schema = "user"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "password")
    var pass: String
    
    @Timestamp(key: "createat", on: .create)
    var createat: Date?
    
    
    init() {
        
    }
    init(id: UUID? = nil, name: String, pass: String, createat: Date? = nil) {
        self.id = id
        self.name = name
        self.pass = pass
        self.createat = createat
    }

}
