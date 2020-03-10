//
//  AuthenticateViewController.swift
//  WatchThis
//
//  Created by Abhishek Saral on 3/9/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import UIKit
import SafariServices

class AuthenticateViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var isLoadingViewController = false

    override func viewDidLoad() {
        super.viewDidLoad()
        isLoadingViewController = true
        viewLoadSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isLoadingViewController {
            isLoadingViewController = false
        } else {
            viewLoadSetup()
         }
        
    }


    func viewLoadSetup(){
        // Do any additional setup after loading the view.
        
        APICaller.client.getUserData {
            self.nameLabel.text = APICaller.client.myName
            self.userNameLabel.text = APICaller.client.myUserName
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
