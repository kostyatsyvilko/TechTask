import Foundation

struct Post: Hashable {
    var title: String
    var body: String
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
    init(from post: PostResponse) {
        self.title = post.title
        self.body = post.body
    }
    
    init(from post: PostManagedObject) {
        self.title = post.title
        self.body = post.body
    }
}
