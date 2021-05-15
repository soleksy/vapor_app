import Foundation
import Fluent
import FluentSQLiteDriver


struct CreateComment: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("comments") 
        .id()
        .field("body" , .string)
        .field("user_id", .uuid , .references("users" , "id"))
        .field("post_id", .uuid , .references("posts" , "id"))
        .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void>{
        database.schema("comments").delete() 
    }

}