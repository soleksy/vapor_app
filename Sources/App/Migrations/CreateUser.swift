import Foundation
import Fluent
import FluentSQLiteDriver


struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users") 
        .id()
        .field("name" , .string)
        .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void>{
        database.schema("users").delete() 
    }

}



