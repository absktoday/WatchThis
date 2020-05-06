//
//  RecommendationViewController.swift
//  WatchThis
//
//  Created by Abhishek Saral on 5/5/20.
//  Copyright © 2020 Tech Knowns. All rights reserved.
//

import UIKit
import AlamofireImage

class RecommendationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginLabel: UILabel!
    
    var favoriteMovies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if UserDefaults.standard.bool(forKey: "userLoginStatus") == true {
            
            APICaller.client.sessionID = UserDefaults.standard.string(forKey: "sessionID")!
            
            collectionView.delegate = self
            collectionView.dataSource = self
            loginLabel.isHidden = true
            
            getFavoriteMovies()
            
        }

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "userLoginStatus") == true {
            
            //APICaller.client.sessionID = UserDefaults.standard.string(forKey: "sessionID")!
            
            collectionView.delegate = self
            collectionView.dataSource = self
            loginLabel.isHidden = true
            
            getFavoriteMovies()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = favoriteMovies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = URL (string: baseUrl + posterPath)!
            cell.posterView.af_setImage(withURL: posterUrl, placeholderImage: UIImage(named: "default-poster"))
        } else {
            cell.posterView.image = UIImage(named: "default-poster")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeaderView{
            sectionHeader.sectionHeaderLabel.text = "Select the movie for Recommendations!"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func getFavoriteMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/account/\(APICaller.client.accountID)/favorite/movies?api_key=b6dcea27a60a83ccbe00da3c72753438&language=en-US&session_id=\(APICaller.client.sessionID)&sort_by=created_at.asc&page=1")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let movieData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.favoriteMovies = movieData["results"] as! [[String:Any]]
            self.collectionView.reloadData()
            
           }
        }
        task.resume()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = favoriteMovies[indexPath.item]

        // Pass the selected movie to the details view controller

        let detailsViewController = segue.destination as! RecommendedMoviesViewController

        detailsViewController.movie = movie
        
    }

}
