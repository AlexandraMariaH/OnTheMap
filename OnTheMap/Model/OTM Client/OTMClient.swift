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
        static var key = ""
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
                return Endpoints.base + "/v1/session"
               // return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
                
            case .createSessionId:
                return Endpoints.base + "/v1/session"
                    //+ Endpoints.apiKeyParam
            
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
                
            case .webAuth:
                return "https://auth.udacity.com/sign-up"
                            
            case .logout:
                return Endpoints.base + "/v1/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
   /* @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
       
        print("in task for get request")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            print("in url session")

            do {
                print("before decoder")

                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                print("after decoder")

                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do { 
                    let errorResponse = try JSONDecoder().decode(OTMResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("decoder failed")

                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }*/
    
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, body: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        print("login3.0")
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.httpBody = try! JSONEncoder().encode(body)
         request.httpBody = body.data(using: .utf8)
        print("login3.1")
        print(request)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          if error != nil {
            DispatchQueue.main.async {
                
                completion(nil, error)
            }
              return
          }
            print("login3.2")

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
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
            let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"

        taskForPOSTRequest(url: Endpoints.createSessionId.url, body: body, responseType: SessionResponse.self) { (response, error) in

            if let response = response {
                Auth.key = response.account.key
                Auth.sessionId = response.session.id
                print(Auth.sessionId, Auth.key)

                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
  /*  class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
        print("in get request token")
        taskForGETRequest(url: Endpoints.getRequestToken.url, responseType: RequestTokenResponse.self) { response, error in
            if let response = response {
                print("in response")
                Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                print("fail get request token")
                completion(false, error)
            }
        }
    }*/
    
    /*class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        print("in login1")
        let usernameAndPassword = UdacityUsernamePassword(username: username, password: password)
        print("in login2")

        let body = LoginRequest(udacity: usernameAndPassword)
        print("in login3")

        taskForPOSTRequest(url: Endpoints.login.url, username: username, password: password, responseType: RequestTokenResponse.self, body: body) { response, error in
            if let response = response {
                print("in login4")

                Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                print("in loginerror")

                completion(false, error)
            }
        }
    }*/
    
    class func logout(completion: @escaping () -> Void) {
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
          Auth.sessionId = ""
          print(String(data: newData!, encoding: .utf8)!)
          completion()
        }
        task.resume()
    }
    
    /*class func getStudentLocation(completion: @escaping (Bool,Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocation.url, response: GetLocationResponse.self, start: 0) { (response, error) in
                   if let response = response {
                    OnTheMapModel.studentInformation = response.results
                    completion(true,nil)
                   }
                   else {
                    completion(false,error)
                   }
               }

    }*/

}
