//
//  CourseDetailView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import SwiftUI

struct CourseDetailView: View {
    
    let course: Courses.Course
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        CourseDetailView(course: PreviewObjects.course)
    }
}
