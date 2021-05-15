import Fluent
import Vapor
import FluentSQLiteDriver


final class User: Model , Content {

    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Children(for: \.$user)
    var posts: [Post]

    @Children(for: \.$user)
    var comments: [Comment]

    init(){}


    init(id: UUID? = nil, name: String){
        self.id = id
        self.name = name
    }
}