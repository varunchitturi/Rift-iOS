//
//  NetworkSentinel.swift
//  Rift
//
//  Created by Varun Chitturi on 9/26/21.
//

import Foundation

protocol NetworkSentinel {
    static var sharedURLSession: URLSession { get }
}
