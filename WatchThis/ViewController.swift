//
//  ViewController.swift
//  WatchThis
//
//  Created by Abhishek Saral on 2/26/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tempMovieLabel: UILabel!
    
    
    
    var movies = [[String:Any]]()
    var tempMovieString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //tempMovieLabel.text = "Hello World!"
        
        // Retrieving movie information from The Movie Database API
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=b6dcea27a60a83ccbe00da3c72753438&language=en-US&page=1&region=US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let movieData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            
            self.movies = movieData["results"] as! [[String:Any]]
            
            //print(self.movies)

           }
        }
        task.resume()
    }
    
    // Temp button to see if we are getting movies from the database.
    @IBAction func showMoviesButton(_ sender: Any) {
        
        for movie in movies {
            tempMovieString.append(movie["title"] as! String)
            tempMovieString.append("\n")
        }
        tempMovieLabel.text = tempMovieString
        print(tempMovieString)
        
    }
}

