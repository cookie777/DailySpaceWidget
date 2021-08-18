//
//  NetworkError.swift
//  MVVM-Demo
//
//  Created by Derrick Park on 2020-05-29.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case badStatus
    case decodingFailed
    case unknown
}
