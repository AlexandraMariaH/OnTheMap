//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 25.04.21.
//

import Foundation

struct LoginRequest: Encodable {
    let udacity: UdacityUsernamePassword
}
    
struct UdacityUsernamePassword: Encodable {
    let username: String
    let password: String
}
