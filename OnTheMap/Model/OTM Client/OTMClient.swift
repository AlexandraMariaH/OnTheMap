//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Alexandra Hufnagel on 25.04.21.
//

import Foundation

class OTMClient {
    
    static let apiKey = "e60a51cd20961f6f71bb4def5ebf9321"
    
    struct Auth {
       // static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com"
        static let apiKeyParam = "?api_key=\(OTMClient.apiKey)"
        
        case login
        case createSessionId
        case getRequestToken
        case webAuth
        case logout

        var stringValue: String {
            switch self {
            
            case .login:
                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
                
            case .createSessionId:
                return Endpoints.base + "/v1/session"
                    //+ Endpoints.apiKeyParam
            
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
                
            case .webAuth:
                return "https://auth.udacity.com/sign-up"
                
            //"https://www.udacity.com/authenticate/\(Auth.requestToken)?redirect_to=udacity:authenticate"
            
            case .logout:
                return Endpoints.base + "/v1/session"
                    //+ Endpoints.apiKeyParam
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        print("in task for get request")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            print("in url session")

            let decoder = JSONDecoder()
            do {                print("url1")

                let responseObject = try decoder.decode(ResponseType.self, from: data)
                print("url")

                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do { 
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, username: String, password: String, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = try! JSONEncoder().encode(body)
         request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          if error != nil {
            DispatchQueue.main.async {
                            completion(nil, error)
            }
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
            
          print(String(data: newData!, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
                               do {
                                let responseObject = try decoder.decode(ResponseType.self, from: newData!)
                                   DispatchQueue.main.async {
                                       completion(responseObject, nil)
                                   }
                               } catch {
                                print(error)
                                   do {
                                    let errorResponse = try decoder.decode(OTMResponse.self, from: data!) as Error
                                       DispatchQueue.main.async {
                                           completion(nil, errorResponse)
                                       }
                                   } catch {
                                    print(error)
                                       DispatchQueue.main.async {
                                           completion(nil, error)
                                      }
                                }
                            }
                    }
                    task.resume()
             }
    
    class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
        do {
            let body = try PostSession(from: Auth.requestToken as! Decoder)
        taskForPOSTRequest(url: Endpoints.createSessionId.url, username: "mm", password: "mmm", responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.sessionId
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    } catch {
    DispatchQueue.main.async {
        completion(false, error)
    }
    }
        
    }
    
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
        print("in get request token")
        taskForGETRequest(url: Endpoints.getRequestToken.url, responseType: RequestTokenResponse.self) { response, error in
            if let response = response {
                Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let usernameAndPassword = UdacityUsernamePassword(username: username, password: password)
        let body = LoginRequest(udacity: usernameAndPassword)
        taskForPOSTRequest(url: Endpoints.login.url, username: username, password: password, responseType: RequestTokenResponse.self, body: body) { response, error in
            if let response = response {
                Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
  /*  class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil

        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()*/
        
        /*
        let body = LogoutRequest(sessionId: Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            Auth.requestToken = ""
            Auth.sessionId = ""
            completion()
        }
        task.resume()*/
    
}
