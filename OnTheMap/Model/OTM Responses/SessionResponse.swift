//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 25.04.21.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct SessionResponse: Codable {
    let account: Account
    let session: Session
}
    
