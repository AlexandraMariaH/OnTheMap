//
//  GetStudentLocationResponse.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 13.05.21.
//

import Foundation

struct GetStudentLocationResponse: Codable {
    let results: [Student]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
