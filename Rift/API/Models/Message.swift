//
//  Message.swift
//  Rift
//
//  Created by Varun Chitturi on 10/17/21.
//

import Foundation

struct Message: Decodable, Identifiable {

    let id: Int
    let courseID: Int
    let postedTime: Date
    let date: Date?
    var unread: Bool
    let endpoint: String
    let type: MessageType
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "messageID"
        case courseID
        case postedTime = "postedTimestamp"
        case date
        case unread = "newMessage"
        case endpoint = "url"
        case type = "process"
        case name

    }

    enum MessageType: String, Decodable {
        case `default` = "Message"
        case announcement = "Announcement"
    }
}

extension Message {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let courseID = try container.decode(Int.self, forKey: .courseID)
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
        
        self.init(id: id, courseID: courseID, postedTime: postedTime, date: date, unread: unread, endpoint: endpoint, type: type, name: name)
    }
}
