//
//  LogoutRequest.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 25.04.21.
//

import Foundation

struct LogoutRequest: Codable {
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
    }
}
