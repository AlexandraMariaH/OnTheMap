//
//  OTMResponse.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 25.04.21.
//

import Foundation

struct OTMResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension OTMResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
