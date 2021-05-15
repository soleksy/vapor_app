import Vapor
import Fluent

struct CommentList: Content {
    let CommentList: [Comment]
}


struct UpdateComment: Content {
    let id: UUID?
    let body: String
}


struct CommentController: RouteCollection {

    func boot(routes: RoutesBuilder) throws{

    let comments = routes.grouped("comments")

    comments.group(":commentId"){ comment in 
            comment.get(use: get_comment)
            comment.delete(use: delete)
        }
        
    comments.get(use: get_all_comments)
    comments.put(use: update)
    comments.post(use: create)

    }


    func get_all_comments(req: Request) throws -> EventLoopFuture<View> {
        let comments = Comment.query(on: req.db).all()
        return comments.flatMap { list in 
            let data = CommentList(CommentList: list)
            return req.view.render("comments" , data)
        }
    }

    func get_comment(req: Request) throws -> EventLoopFuture<View> {

        guard let commentId = req.parameters.get("commentId") as UUID? else{
            throw Abort(.badRequest)
        }

        return Comment.find(commentId , on: req.db).flatMap { comment in
            let data = ["comment" : comment]
            return req.view.render("comment", data)
        }
    }

    func create(req: Request) throws -> EventLoopFuture<Response> {
        let comment = try req.content.decode(Comment.self)
        return comment.create(on: req.db).map { _ in 
            return req.redirect(to: "/comments")
        }
    }


    func update(req: Request) throws -> EventLoopFuture<Response> {
        let comment = try req.content.decode(UpdateComment.self)
        return Comment.find(comment.id, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.body = comment.body
            return $0.update(on: req.db).map { _ in 
                return req.redirect(to: "/comments")
                }
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<Response>{
        return Comment.find(req.parameters.get("commentId") , on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.delete(on: req.db).map {_ in 
                return req.redirect(to: "/comments")
            }
        }
    }


}

