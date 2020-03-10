//
//  MovieAPICaller.swift
//  WatchThis
//
//  Created by Abhishek Saral on 3/9/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import UIKit
import AuthenticationServices

class MovieAPICaller  {
    
    var webAuthSession: ASWebAuthenticationSession?
    var viewController = AuthenticationViewController()
    
    func login() {
        
        let authURL = URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=b6dcea27a60a83ccbe00da3c72753438")
        let callbackUrlScheme = "WatchThis://auth"
        
        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in

            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }

            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "request_token"}).first

            // Do what you now that you've got the token, or use the callBack URL
            print(oauthToken ?? "No OAuth Token")
        })
        
        webAuthSession?.presentationContextProvider = viewController
        
        self.webAuthSession?.start()
        
    }

}
