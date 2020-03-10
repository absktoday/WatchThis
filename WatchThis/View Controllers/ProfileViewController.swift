//
//  ProfileViewController.swift
//  WatchThis
//
//  Created by Abhishek Saral on 3/9/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import UIKit
import SafariServices

class ProfileViewController: UIViewController, SFSafariViewControllerDelegate {
    
    lazy var loginToken = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        APICaller.client.getToken()
        
    }
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        
        loginToken = APICaller.client.token
//        print("https://www.themoviedb.org/authenticate/\(loginToken)")
        
        if let url = URL(string: "https://www.themoviedb.org/authenticate/\(loginToken)") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            vc.delegate = self
            present(vc, animated: true)
        }
        
    }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        //APICaller.client.login()
        APICaller.client.loginV2()
        dismiss(animated: true)
    }
    
    
    @IBAction func LogoutPressed(_ sender: UIButton) {
        APICaller.client.logout()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }*/

}
