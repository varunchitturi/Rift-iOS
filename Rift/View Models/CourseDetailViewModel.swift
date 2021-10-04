//
//  CourseDetailViewModel.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import Foundation
import SwiftUI

class CourseDetailViewModel: ObservableObject {

    @Published private var courseDetail: CourseDetail
    
    init(course: Course) {
        self.courseDetail = CourseDetail(course: course)
    }
  
}
