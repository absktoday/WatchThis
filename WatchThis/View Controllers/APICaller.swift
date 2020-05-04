//
//  APICaller.swift
//  WatchThis
//
//  Created by Abhishek Saral on 3/9/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import Foundation

class APICaller {
    
    static let client = APICaller()
    
    fileprivate var apiKey = "b6dcea27a60a83ccbe00da3c72753438"
    
    var token = ""
    var sessionID = ""
    var myName = ""
    var myUserName = ""
    
    var accountID = 0
    
    func getToken() {
        
        let url = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let tokenData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.token = tokenData["request_token"] as! String
//            print(self.token)

           }
        }
        task.resume()
    }
    
    
    
    
    func login() {
        let parameters = ["request_token": token]
        //https://api.themoviedb.org/3/authentication/session/new?api_key=###&request_token=###
        
        
        //let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)")!
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)&request_token=\(token)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        
//        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print(response)
//            }
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                } catch {
//                    print(error)
//                }
//            }
//        }.resume()
        session.uploadTask(with: request, from: httpBody) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()

    }
    
    func loginV2() {
        
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=b6dcea27a60a83ccbe00da3c72753438&request_token=\(token)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let loginData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.sessionID = loginData["session_id"] as! String
                
                print(loginData)
                print(self.sessionID)
                
            }
        }
        task.resume()

        }
    
    func getUserData(completion:@escaping () -> ()) {
        
        // https://api.themoviedb.org/3/account?api_key=<<api_key>>&session_id=<sessionID>
        
        let url = URL(string: "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=\(sessionID)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let userData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.myName = userData["name"] as! String
                self.myUserName = userData["username"] as! String
                self.accountID = userData["id"] as! Int
                completion()
            }
        }
        task.resume()
    }
    
    func logout() {
        
        let parameters = "{\n    \"session_id\": \"\(sessionID)\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/authentication/session?api_key=b6dcea27a60a83ccbe00da3c72753438")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "DELETE"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func rateMovie(_ rating : Double, _ movieID : Int) {
        let parameters = "{\n  \"value\": \(rating)\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/rating?api_key=b6dcea27a60a83ccbe00da3c72753438&session_id=\(sessionID)")!,timeoutInterval: 10)
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
    
    
}
