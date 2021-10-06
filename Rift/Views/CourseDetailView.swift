//
//  CourseDetailView.swift
//  Rift
//
//  Created by Varun Chitturi on 10/3/21.
//

import SwiftUI

struct CourseDetailView: View {
    
    //@ObservedObject var courseDetailViewModel: CourseDetailViewModel
    
    init(course: Course) {
        //self.courseDetailViewModel = CourseDetailViewModel(course: course)
    }
    
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct CourseDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        CourseDetailView(course: PreviewObjects.course)
    }
}
