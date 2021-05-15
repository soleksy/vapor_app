import Fluent
import Vapor

func routes(_ app: Application) throws {

    try app.register(collection: UserController())
    try app.register(collection: PostController())
    try app.register(collection: CommentController())

    app.get() { req -> EventLoopFuture<View> in 
        return req.view.render("home")
    } 
   
}
