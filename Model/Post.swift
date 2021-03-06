//
//  Post.swift
//  Diplomski
//
//  Created by Stefan Salatic on 31/7/16.
//
//

import Vapor
import Fluent
import HTTP
import Foundation

enum PostType: String {
    case Text = "text"
    case Photo = "photo"
    case Video = "video"
}

final class Post: Model {
    
    var id: Node?
    var student_id: Int
    var group_id: Int
    var text: String
    var title: String
    var content_url: String
    var date_updated: Int
    var date_created: Int
    
    
    private var type_string: String
    
    var type: PostType {
        get {
            return PostType(rawValue: type_string)!
        } set {
            type_string = type.rawValue
        }
    }
    
    init(student_id: Int, group_id: Int, title: String, text: String, type: PostType, content_url: String = "") {
        self.student_id = student_id
        self.group_id = group_id
        self.title = title
        self.text = text
        self.type_string = type.rawValue
        self.content_url = content_url
        self.date_created = Int(NSDate().timeIntervalSince1970)
        self.date_updated = Int(NSDate().timeIntervalSince1970)
    }
    
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        student_id = try node.extract("student_id")
        group_id = try node.extract("group_id")
        text = try node.extract("text")
        title = try node.extract("title")
        content_url = try node.extract("content_url")
        date_updated = try node.extract("date_updated")
        date_created = try node.extract("date_created")
        type_string = try node.extract("type")
    }
    
    func makeNode() throws -> Node {
        return try Node(node: [
            "id": id,
            "student_id": student_id,
            "group_id": group_id,
            "text": text,
            "title": title,
            "content_url": content_url,
            "type": type_string,
            "date_updated": date_updated,
            "date_created": date_created
            ])
    }
    
    
    func makeJSON() -> JSON {
        return try! JSON([
            "id": id?.int ?? 0,
            "student": Student.find(student_id)!.makeBasicJSON(),
            "text": text,
            "title": title,
            "content_url": content_url,
            "type": type_string,
            "date_updated": date_updated,
            "date_created": date_created
            ])
    }
    
    static func prepare(_ database: Database) throws {
        //
    }
    
    static func revert(_ database: Database) throws {
        //
    }
}

extension Sequence where Iterator.Element == Post {
    func makeJSON() -> JSON {
        return .array(self.map { $0.makeJSON() })
    }
    
    func makeResponse() -> Response {
        return try! makeJSON().makeResponse()
    }
}
