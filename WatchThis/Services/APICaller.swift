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
    var imgHASH = ""
    
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
        
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)&request_token=\(token)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let loginData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.sessionID = loginData["session_id"] as! String
                
                UserDefaults.standard.set(self.sessionID, forKey: "sessionID")
                UserDefaults.standard.set(true, forKey: "userLoginStatus")
                
                //print(loginData)
                //print(self.sessionID)
                
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
                //print(userData["avatar"]!)
                
                let tempDict = userData["avatar"] as! [String: [String : String]]
                
                //print("My HASH: \(tempDict["gravatar"]!["hash"] ?? "LOL")")
                
                self.imgHASH = tempDict["gravatar"]!["hash"] ?? "LOL"
                
                //print(self.imgHASH)
                
                completion()
            }
        }
        task.resume()
    }
    
    func logout() {
        
        let parameters = "{\n    \"session_id\": \"\(sessionID)\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/authentication/session?api_key=\(apiKey)")!,timeoutInterval: Double.infinity)
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

        var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/rating?api_key=\(apiKey)&session_id=\(sessionID)")!,timeoutInterval: 10)
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
    
    func setFavorite(_ movieID : Int) {
        let parameters = "{\n  \"media_type\": \"movie\",\n  \"media_id\": \(movieID),\n  \"favorite\": true\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/account/\(accountID)/favorite?api_key=\(apiKey)&session_id=\(sessionID)")!,timeoutInterval: 10)
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

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
