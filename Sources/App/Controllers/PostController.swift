import Vapor
import Fluent

let postRedirect = "/posts"

struct postList: Content {
    let postList: [Post]
}


struct updatePost: Content {
    let id: UUID?
    let title: String
    let body: String
}


struct PostController: RouteCollection {

    func boot(routes: RoutesBuilder) throws{

    let posts = routes.grouped("posts")

    posts.group(":postId"){ post in 
            post.get(use: getPost)
            post.delete(use: delete)
        }
        
    posts.get(use: getAllPosts)
    posts.put(use: update)
    posts.post(use: create)

    }


    func getAllPosts(req: Request) throws -> EventLoopFuture<View> {
        let posts = Post.query(on: req.db).all()
        return posts.flatMap { list in 
            let data = postList(postList: list)
            return req.view.render("posts" , data)
        }
    }

    func getPost(req: Request) throws -> EventLoopFuture<View> {

        guard let postId = req.parameters.get("postId") as UUID? else{
            throw Abort(.badRequest)
        }

        return Post.find(postId , on: req.db).flatMap { post in
            let data = ["post" : post]
            return req.view.render("post", data)
        }
    }

    func create(req: Request) throws -> EventLoopFuture<Response> {
        let post = try req.content.decode(Post.self)
        return post.create(on: req.db).map { _ in 
            return req.redirect(to: postRedirect)
        }
    }


    func update(req: Request) throws -> EventLoopFuture<Response> {
        let post = try req.content.decode(updatePost.self)
        return Post.find(post.id, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.title = post.title
            $0.body = post.body
            return $0.update(on: req.db).map { _ in 
                return req.redirect(to: postRedirect)
                }
        }
    }

    func delete(req: Request) throws -> EventLoopFuture<Response>{
        return Post.find(req.parameters.get("postId") , on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap{
            $0.delete(on: req.db).map {_ in 
                return req.redirect(to: postRedirect)
            }
        }
    }


}

