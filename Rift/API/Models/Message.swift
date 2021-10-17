//
//  Message.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation

struct Message: Codable, Identifiable {
    
    let id: Int
    let courseID: Int
    let postedTime: Date
    let date: Date?
    let dueDate: Date?
    var unread: Bool
    let url: URL
    let type: MessageType
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "messageID"
        case courseID
        case postedTime = "postedTimestamp"
        case date, dueDate
        case unread = "newMessage"
        case url
        case type = "process"
        case name

    }
    
    enum MessageType: String, Codable {
        case `default` = "Message"
        case announcement = "Announcement"
    }
}

extension Message {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let courseID = try container.decode(Int.self, forKey: .courseID)
        
    }
}
