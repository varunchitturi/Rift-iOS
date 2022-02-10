//
//  Message.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation

/// Holds the metadata for sent messages
/// - Note: This does not give the body of a message
struct Message: Decodable, Identifiable {
    
    /// The `id` for the message
    let id: Int
    
    /// The exact date and time when the `Message` was posted
    let postedTime: Date
    
    /// The general date when the `Message` was supposed to be sent
    let date: Date?
    
    /// A boolean that gives whether the `Message` was opened or not
    var unread: Bool
    
    /// The endpoint of the `URL` that can be used to get the body of the `Message`
    let endpoint: String
    
    /// Gives the type of `Message`
    let type: MessageType
    
    /// The name of the `Message`
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "messageID"
        case postedTime = "postedTimestamp"
        case date
        case unread = "newMessage"
        case endpoint = "url"
        case type = "process"
        case name

    }
    
    /// Gives the type of `Message` that was sent
    enum MessageType: String, Decodable {
        case `default` = "Message"
        case announcement = "Announcement"
    }
}

extension Message {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let postedTimeString = try container.decode(String.self, forKey: .postedTime)
        let dateString = try container.decode(String?.self, forKey: .date)
        let unread = try container.decode(Bool.self, forKey: .unread)
        let endpoint = try container.decode(String.self, forKey: .endpoint)
        let type = (try? container.decode(MessageType.self, forKey: .type)) ?? .default
        let name = try container.decode(String.self, forKey: .name)
        
        guard let postedTime = DateFormatter.iso180601Full.date(from: postedTimeString) else {
            throw DecodingError.dateDecodingError(for: [CodingKeys.postedTime])
        }
        let date = DateFormatter.yearMonthDayDashedUTC.date(from: dateString ?? "")
        
        self.init(id: id, postedTime: postedTime, date: date, unread: unread, endpoint: endpoint, type: type, name: name)
    }
}
