import Foundation
import Fluent
import FluentSQLiteDriver


struct CreatePost: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("posts") 
        .id()
        .field("title" , .string)
        .field("body" , .string)
        .field("user_id", .uuid , .references("users" , "id"))
        .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void>{
        database.schema("posts").delete() 
    }

}