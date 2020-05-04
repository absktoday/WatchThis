//
//  MovieDetailsViewController.swift
//  WatchThis
//
//  Created by Abhishek Saral on 3/15/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import UIKit
import SafariServices
import Cosmos

class MovieDetailsViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var cosmosView: CosmosView!
    
    var movieDetails = [String:Any]()
    var movieVideos = [[String:Any]]()
    
    let baseUrl = "https://image.tmdb.org/t/p/original"
    var movieID = 0
    var tempBudget:Double = 0
    let usLocale = Locale(identifier: "en_US")
    
    var movie:[String:Any]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        trailerButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = URL (string: baseUrl + posterPath)!
            posterView.af_setImage(withURL: posterUrl, placeholderImage: UIImage(named: "default-poster"))
        } else {
            posterView.image = UIImage(named: "default-poster")
        }
        
        dateLabel.text = movie["release_date"] as? String
        movieID = movie["id"] as! Int
        
        cosmosView.settings.fillMode = .half
        let avg_rating = movie["vote_average"] as? Double ?? 0
        cosmosView.rating = avg_rating/2
        
        cosmosView.didTouchCosmos = { rating in
            print("Rated: \(rating)")
            
            APICaller.client.rateMovie(rating*2, self.movieID)
            
        }
        
        //print(movieID)
        //budgetLabel.text
        
        getMovieDetails()
        getMovieVideos()
        

        
    }
    
    func getMovieDetails() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=b6dcea27a60a83ccbe00da3c72753438&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let movieData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //self.budgetLabel.text = movieData["budget"] as? Int
                //print(self.budgetLabel.text ?? "0")
                self.tempBudget = movieData["budget"] as? Double ?? 0
                //print(movieData["budget"])
                //print(self.tempBudget)
                
                if (self.tempBudget > 0) {
                    self.budgetLabel.text = self.convertDoubleToCurrency(amount: self.tempBudget)
                } else {
                    self.budgetLabel.text = "Not Available"
                }
                
                
            }
        }
        task.resume()
    }
    
    func getMovieVideos() {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=b6dcea27a60a83ccbe00da3c72753438")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.movieVideos = dataDictionary["results"] as! [[String:Any]]

           }
        }
        task.resume()
        
    }
    
    
    func convertDoubleToCurrency(amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = usLocale
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    @IBAction func trailerPressed(_ sender: UIButton) {
        
        var youtubeURL = URL(string: "https://www.youtube.com/")
        
        if movieVideos.count != 0 {
            youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(movieVideos[0]["key"]!)")
        } else {
            youtubeURL = URL(string: "https://www.youtube.com/")
        }
        
        if let url = youtubeURL {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            vc.delegate = self
            present(vc, animated: true)
        }
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        //dismiss(animated: true)
    }
    
    @IBAction func addFavorite(_ sender: UIButton) {
        
        APICaller.client.setFavorite(movieID)
        
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
