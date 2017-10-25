import Vapor
import Foundation
import Dispatch

let queue = DispatchQueue.init(label: "com.bruce.upload")

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }
        
        get("file") {
            req in
//            guard let name = req.parameters["name"] else {
//                return "No Name"
//            }
            let zipPath = "data/file"
            let url = URL(fileURLWithPath: zipPath, isDirectory: false)
            
            guard FileManager.default.fileExists(atPath: zipPath) else {
                return "No File"
            }
            
            let data = try Data.init(contentsOf: url)
            return data
        }
        
        post("upload") { req in
            print("receive asking")
            guard let formData = req.formData, let bytes = formData["file"]?.bytes else {
                return "Wrong format"
            }
            
            let data = Data.init(bytes)
            let dataFolder = "data"
            let zipPath = "data/file"
            print("checking")
            if !FileManager.default.fileExists(atPath: dataFolder) {
                try? FileManager.default.createDirectory(atPath: dataFolder, withIntermediateDirectories: true, attributes: nil)
            }
            
            print("saving")
            try? data.write(to: URL(fileURLWithPath: zipPath, isDirectory: false))
            print("saved")
            
            return "saving"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        try resource("posts", PostController.self)
    }
}
