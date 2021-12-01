//
//  RiftTests.swift
//  RiftTests
//
//  Created by Ishan Jain on 11/30/21.
//


// Testing the Assignment input
@testable import Rift
import XCTest

class RiftTests: XCTestCase {
    
    var addAssignment: AddAssignmentModel!
    
    override func setUp() {
        super.setUp()
        addAssignment = AddAssignmentModel(courseName: "Science", gradingCategories: PreviewObjects.gradeDetail.categories)
    }
    
    override func tearDown() {
        addAssignment = nil
        super.tearDown()
    }
    
    func isAssignmentNameValid() throws {
        XCTAssertNoThrow(try addAssignment.validateAssignmentName("Math"))
    }
    
}
