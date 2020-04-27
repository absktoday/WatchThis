//
//  MovieDetailsViewController.swift
//  WatchThis
//
//  Created by Abhishek Saral on 3/15/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    
    var movieDetails = [String:Any]()
    
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
        
        
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = URL (string: baseUrl + posterPath)!
            posterView.af_setImage(withURL: posterUrl, placeholderImage: UIImage(named: "default-poster"))
        } else {
            posterView.image = UIImage(named: "default-poster")
        }
        
        dateLabel.text = movie["release_date"] as? String
        movieID = movie["id"] as! Int
        
        //print(movieID)
        //budgetLabel.text
        
        getMovieDetails()
        
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
                self.budgetLabel.text = self.convertDoubleToCurrency(amount: self.tempBudget)
                
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
