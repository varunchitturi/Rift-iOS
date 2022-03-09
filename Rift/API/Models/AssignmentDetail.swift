//
//  AssignmentDetail.swift
//  Rift
//
//  Created by Varun Chitturi on 10/14/21.
//

import Foundation
import SwiftSoup

/// Gives detail information on an `Assignment`
struct AssignmentDetail: Decodable, Identifiable, Equatable {
    
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
    
    
    /// The `id` of the `Assignment`
    let id: Int
    
    /// The start date for the `Assignment`
    let startDate: Date?
    
    /// The end date for the `Assignment`
    let endDate: Date?
    
    /// The date when the `Assignment` was last modified
    let modifiedDate: Date?
    
    /// Gives whether the `Assignment` is active and should be used in grade calculation
    let isActive: Bool
    
    /// The rubrics for the `Assignment`
    /// - Gives information on how the assignment is graded
    private let rubrics: [Rubric]?
    
    /// The scores for the `Assignment`
    /// - Gives information on student performance on an `Assignment`
    private let scores: [Score]?
    
    /// The description for the `Assignment`
    let description: Description
    
    /// The weightage if present for the `Assignment`
    private var weight: Double? {
        guard let rubrics = rubrics, let rubric = rubrics.first, let weight = rubric.weight else {
            return nil
        }
        return weight
    }
    
    /// The total points that the `assignment` is out of
    private var totalPoints: Double? {
        guard let rubrics = rubrics, let rubric = rubrics.first, let totalPoints = rubric.totalPoints else {
            return nil
        }
        return totalPoints * (weight ?? 1)
    }
    
    
    /// The points earned on the `Assignment`
    var scorePoints: Double? {
        guard let scores = scores,
                !scores.isEmpty,
              let scorePoints = scores.first!.scorePoints else {
            return nil
        }
        return scorePoints * (weight ?? 1)
    }
    
    /// Comments that are present on an `Assignment`
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
    
    /// Contains information on student performance of an `Assignment`
    private struct Score: Decodable, Identifiable, Equatable {
        
        init(id: Int, scorePoints: Double?, comments: String?) {
            self.id = id
            self.scorePoints = scorePoints
            self.comments = comments
        }
        
        /// The `id` of the `Score`
        let id: Int
        
        /// The points earned on the `Assignment`
        let scorePoints: Double?
        
        /// Comments on the score of an `Assignment`
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
    
    /// Description for an `Assignment`
    struct Description: Decodable, Equatable {
        
        /// Gives information on the description summary of an assignment
        struct SummaryContent: Decodable {
            
            /// The description of an assignment in the form of HTML
            let content: String
        }
        
        init(assignmentName: String, summary: String?) {
            self.assignmentName = assignmentName
            self.summary = summary
        }
        
        /// The name of the assignment
        let assignmentName: String
        
        /// The summary of the description of an assignment
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
    
    /// Gives information on how an `Assignment` is graded
    private struct Rubric: Decodable, Equatable {
        
        /// The points that an `Assignment` is out of
        let totalPoints: Double?
        
        /// The weightage of an `Assignment`
        let weight: Double?
        
        /// The `id` of the category that the assignment is part of
        let categoryID: Int
    }

}
