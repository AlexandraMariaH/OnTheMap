//
//  CreateStudentResponse.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 09.05.21.
//

import Foundation

struct CreateStudentResponse: Codable {
    let createdAt: String
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
}
