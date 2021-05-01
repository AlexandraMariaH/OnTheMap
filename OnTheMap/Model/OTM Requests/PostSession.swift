//
//  PostSession.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 25.04.21.
//

import Foundation

struct PostSession: Codable {
    
    let udacityAuthDic: [String: [String]]
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case udacityAuthDic = "udacity"
        case username
        case password
    }
    
}
