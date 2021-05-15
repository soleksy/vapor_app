import Fluent
import Vapor
import FluentSQLiteDriver


final class Post: Model , Content {

    static let schema = "posts"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "body")
    var body: String

    @Parent(key: "user_id")
    var user: User

    @Children(for: \.$post)
    var comments: [Comment]

    init(){}


    init(id: UUID? = nil, title: String , body: String, userId: UUID){
        self.id = id
        self.title = title
        self.body = body
        self.$user.id = userId
    }
}