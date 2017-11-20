import Vapor

final class Routes: RouteCollection {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {
        /// GET /
        builder.get { req in
            return try self.view.make("welcome")
        }
        
        /// GET /hello/...
        builder.resource("hello", HelloController(view))
        
        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }
        
        builder.get("choose",":family") { req in

            guard let family = req.parameters["family"]?.string else {
                throw Abort.badRequest
            }

            let chooser = Chooser(family: family)
            let names = chooser.assignGiftees(peeps: chooser.people)
            
            let string = names.reduce("", {partial, person in return partial + person.description})
            
            return string
        }
        
    }
}
