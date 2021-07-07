//
//  ViewController.swift
//  WatchThis
//
//  Created by Abhishek Saral on 2/26/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var comingSoonMovies = [[String:Any]]()
    var nowPlayingMovies = [[String:Any]]()
    
    var tempMovieString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        getComingSoonMovies()
        getNowPlayingMovies()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return comingSoonMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = comingSoonMovies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = URL (string: baseUrl + posterPath)!
            cell.posterView.af_setImage(withURL: posterUrl, placeholderImage: UIImage(named: "default-poster"))
        } else {
            cell.posterView.image = UIImage(named: "default-poster")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nowPlayingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell

        let movie = nowPlayingMovies[indexPath.row]
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
    
    func getNowPlayingMovies() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=b6dcea27a60a83ccbe00da3c72753438&language=en-US&page=1&region=US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let movieData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.nowPlayingMovies = movieData["results"] as! [[String:Any]]

            self.tableView.reloadData()

           }
        }
        task.resume()
    }
    
    func getComingSoonMovies() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=b6dcea27a60a83ccbe00da3c72753438&language=en-US&page=1&region=US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let movieData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                
                
                
                self.comingSoonMovies = movieData["results"] as! [[String:Any]]
                
                self.collectionView.reloadData()
                //print(self.movies)
                
            }
        }
        task.resume()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let mySender = sender as? UITableViewCell {
            print("Table View Cell Clicked")

            let cell = mySender
            let indexPath = tableView.indexPath(for: cell)!
            let movie = nowPlayingMovies[indexPath.row]

            // Pass the selected movie to the details view controller

            let detailsViewController = segue.destination as! MovieDetailsViewController

            detailsViewController.movie = movie

            tableView.deselectRow(at: indexPath, animated: true)

        } else if let mySender = sender as? UICollectionViewCell {
            print("Collection View Cell Clicked")

            let cell = mySender
            let indexPath = collectionView.indexPath(for: cell)!
            let movie = comingSoonMovies[indexPath.item]

            // Pass the selected movie to the details view controller

            let detailsViewController = segue.destination as! MovieDetailsViewController

            detailsViewController.movie = movie
        }

        
    }
    
}

