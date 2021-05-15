import Fluent
import Vapor
import FluentSQLiteDriver


final class Comment: Model , Content {

    static let schema = "comments"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "body")
    var body: String

    @Parent(key: "post_id")
    var post: Post

    @Parent(key: "user_id")
    var user: User

    init(){}



    init(id: UUID? = nil, body: String , post_id: UUID, user_id: UUID){
        self.id = id
        self.body = body
        self.$post.id = post_id
        self.$user.id = user_id
    }
}