//
//  AssignmentDetail.swift
//  Rift
//
//  Created by Varun Chitturi on 10/14/21.
//

import Foundation
import SwiftSoup

struct AssignmentDetail: Decodable, Identifiable {
    
    // TODO: make sure API naming schemes are consistent
    private init(id: Int, startDate: Date?, endDate: Date?, modifiedDate: Date?, isActive: Bool, rubrics: [AssignmentDetail.Rubric], scores: [AssignmentDetail.Score]?, description: AssignmentDetail.Description) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.modifiedDate = modifiedDate
        self.isActive = isActive
        self.rubrics = rubrics
        self.scores = scores
        self.description = description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        
        let startDateString = try container.decode(String?.self, forKey: .startDate)
        let endDateString = try container.decode(String?.self, forKey: .endDate)
        let modifiedDateString = try container.decode(String?.self, forKey: .modifiedDate)
    
        let isActive = try container.decode(Bool.self, forKey: .isActive)
        
        let rubrics = try container.decode([Rubric].self, forKey: .rubrics)
        let scores = try container.decode([Score]?.self, forKey: .scores)
        
        let description = try container.decode(Description.self, forKey: .description)
        
        let dateDecoder = JSONDecoder()
        dateDecoder.dateDecodingStrategy = .formatted(DateFormatter.yearMonthDayDashedUTC)
        
        let startDate = startDateString != nil ? DateFormatter.iso180601Full.date(from: startDateString!) : nil
        let endDate = endDateString != nil ? DateFormatter.iso180601Full.date(from: endDateString!) : nil
        let modifiedDate = modifiedDateString != nil ? DateFormatter.iso180601Full.date(from: modifiedDateString!) : nil
        
        
        
        self.init(id: id, startDate: startDate, endDate: endDate, modifiedDate: modifiedDate, isActive: isActive, rubrics: rubrics, scores: scores, description: description)
    }
    
    
    let id: Int
    
    let startDate: Date?
    let endDate: Date?
    let modifiedDate: Date?
    
    let isActive: Bool
    
    private let rubrics: [Rubric]?
    private let scores: [Score]?
    let description: Description
    
    private var weight: Double? {
        guard let rubrics = rubrics, let rubric = rubrics.first, let weight = rubric.weight else {
            return nil
        }
        return weight
    }
    
    private var totalPoints: Double? {
        guard let rubrics = rubrics, let rubric = rubrics.first, let totalPoints = rubric.totalPoints else {
            return nil
        }
        return totalPoints * (weight ?? 1)
    }
    
    
    var scorePoints: Double? {
        guard let scores = scores,
                !scores.isEmpty,
              let scorePoints = scores.first!.scorePoints else {
            return nil
        }
        return scorePoints * (weight ?? 1)
    }
    
    var comments: String? {
        scores?.first != nil ? scores!.first!.comments : nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "objectSectionID"
        case startDate, endDate, modifiedDate
        case isActive = "active"
        case rubrics = "gradingAlignments"
        case description = "curriculumContent"
        case scores
    }
    
    private struct Score: Decodable, Identifiable {
        
        init(id: Int, scorePoints: Double?, comments: String?) {
            self.id = id
            self.scorePoints = scorePoints
            self.comments = comments
        }
        
        let id: Int
        let scorePoints: Double?
        let comments: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "scoreID"
            case scorePoints
            case comments
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let id = try container.decode(Int.self, forKey: .id)
            
            let scorePointsString = (try? container.decode(String.self, forKey: .scorePoints)) ?? ""
            let scorePoints = Double(scorePointsString)
            
            let comments = try? container.decode(String?.self, forKey: .comments)
            
            self.init(id: id, scorePoints: scorePoints, comments: comments)
            
        }
        
    }
    struct Description: Decodable {
        
        struct SummaryContent: Decodable {
            let content: String
        }
        
        init(assignmentName: String, summary: String?) {
            self.assignmentName = assignmentName
            self.summary = summary
        }
        
        let assignmentName: String
        let summary: String?
        
        enum CodingKeys: String, CodingKey {
            case assignmentName = "name"
            case summary = "description"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let assignmentName = try container.decode(String.self, forKey: .assignmentName)
            
            let summaryContent = try container.decode(SummaryContent?.self, forKey: .summary)
            
            guard let summaryHTML = summaryContent?.content else {
                self.init(assignmentName: assignmentName, summary: nil)
                return
            }
            
            let summaryParsed = try SwiftSoup.parse(summaryHTML)
            let summary = try summaryParsed.text()
            
            self.init(assignmentName: assignmentName, summary: summary)
            
        }
    }
    
    private struct Rubric: Decodable {
        let totalPoints: Double?
        let weight: Double?
        let categoryID: Int
    }

}
