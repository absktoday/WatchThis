//
//  RecommendedMoviesViewController.swift
//  WatchThis
//
//  Created by Abhishek Saral on 5/5/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import UIKit

class RecommendedMoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var movie:[String:Any]!
    var recommendedMovies = [[String:Any]]()
    var movieID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieID = movie["id"] as! Int
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getRecommendations()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell

        let movie = recommendedMovies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String

        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis

        let baseUrl = "https://image.tmdb.org/t/p/w185"
        
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = URL (string: baseUrl + posterPath)!
            cell.posterView.af_setImage(withURL: posterUrl, placeholderImage: UIImage(named: "default-poster"))
        } else {
            cell.posterView.image = UIImage(named: "default-poster")
        }
        
        return cell
    }
    
    func getRecommendations() {
        
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/recommendations?api_key=b6dcea27a60a83ccbe00da3c72753438&language=en-US&page=1")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let movieData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.recommendedMovies = movieData["results"] as! [[String:Any]]
            
            self.tableView.reloadData()
            
           }
        }
        task.resume()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = recommendedMovies[indexPath.row]

        // Pass the selected movie to the details view controller

        let detailsViewController = segue.destination as! MovieDetailsViewController

        detailsViewController.movie = movie

        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}
