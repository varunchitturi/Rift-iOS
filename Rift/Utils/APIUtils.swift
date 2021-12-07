//
//  APIUtils.swift
//  Rift
//
//  Created by Varun Chitturi on 12/7/21.
//

import Foundation
import SwiftUI

extension Assignment {
    var totalPointsDisplay: String {
        self.totalPoints?.description ?? String.nilDisplay
    }
    var scorePointsDisplay: String {
        self.scorePoints?.description ?? String.nilDisplay
    }
}

extension GradingCategory {
    var percentageDisplay: String {
        percentage?.rounded(2).description.appending("%") ?? String.nilDisplay
    }
}

extension GradeDetail {
    var totalPercentageDisplay: String {
        totalPercentage?.truncated(2).description.appending("%") ?? String.nilDisplay
    }
}

extension Course {
    var gradeDisplay: String {
        currentGrade?.letterGrade ?? String.nilDisplay
    }
    
    var percentageDisplay: String {
        currentGrade?.percentageString ?? String.nilDisplay
    }
}

extension Grade {
    var percentageString: String {
        guard let percentage = percentage?.description else {
            if let totalPoints = totalPoints, let currentPoints = currentPoints {
                return (((currentPoints / totalPoints) * 100).rounded(2)).description.appending("%")
            } else {
                return String.nilDisplay
            }
            
        }
        return percentage.appending("%")
    }

}
