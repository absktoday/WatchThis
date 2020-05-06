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
    
    // MARK: - Properties
    
    var ratedMovies = [[String:Any]]()
    var favMovies = [[String:Any]]()
    
    var accountID = ""
    
    var ratedCount = 0
    
    var favCount = 0
    
    var sessionID = ""
    
    lazy var favLabel : UILabel = {
        
        let label = UILabel()
        label.text = "    My Favorites"
        label.font = UIFont.systemFont(ofSize: 20)
        
        if traitCollection.userInterfaceStyle == .light{
            label.textColor = UIColor.black
        }
        else{
            label.textColor = UIColor.white
        }

        return label
    }()
    
    lazy var ratedLabel : UILabel = {
        
        let label = UILabel()
        label.text = "    Rated"
        label.font = UIFont.systemFont(ofSize: 20)
        
        if traitCollection.userInterfaceStyle == .light{
            label.textColor = UIColor.black
        }
        else{
            label.textColor = UIColor.white
        }
        
        return label
    }()
    
    var images : [UIImage] = []
    
    var posterPaths : [String] = []
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBlue
        
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.anchor(top: view.topAnchor, paddingTop: 60,
                                width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        
        view.addSubview(messageButton)
        messageButton.anchor(top: view.topAnchor, left: view.leftAnchor,
                             paddingTop: 100, paddingLeft: 32, width: 32, height: 32)
        
        view.addSubview(followButton)
        followButton.anchor(top: view.topAnchor, right: view.rightAnchor,
                            paddingTop: 100, paddingRight: 32, width: 32, height: 32)
        
        view.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 12)
        
        view.addSubview(emailLabel)
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.anchor(top: nameLabel.bottomAnchor, paddingTop: 1)
        
        return view
    }()
    
    let ratedCollectionView : UICollectionView = {
        
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout : layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(customCellRate.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    let favoriteCollectionView : UICollectionView = {
        
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout : layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(customCellRate.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "default-poster")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ic_mail_outline_white_2x").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMessageUser), for: .touchUpInside)
        return button
    }()
    
    let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_person_add_white_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleFollowUser), for: .touchUpInside)
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        APICaller.client.getUserData{
            label.text = APICaller.client.myName
        }
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        APICaller.client.getUserData{
            label.text = APICaller.client.myUserName
        }
                label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        APICaller.client.getUserData{
        
            self.accountID = "\(APICaller.client.accountID)"
            self.sessionID = "\(APICaller.client.sessionID)"
            
            self.getFavMovies()
            self.getRatedMovies()
            
        }
        
        let myHeight = (view.frame.height - 150)/3
        
        if traitCollection.userInterfaceStyle == .light{
            favLabel.textColor = UIColor.black
            ratedLabel.textColor = UIColor.black
            view.backgroundColor = UIColor.white
        }
            
        if traitCollection.userInterfaceStyle == .dark{
            favLabel.textColor = UIColor.white
            ratedLabel.textColor = UIColor.white
            view.layer.shadowOpacity = 0.08
            view.layer.shadowColor = UIColor(named: "darkshadow")?.cgColor
        }
    
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, height: myHeight)
        
        view.addSubview(favLabel)
        
        favLabel.anchor(top: containerView.bottomAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, height: 30)
        
        view.addSubview(favoriteCollectionView)
        
        favoriteCollectionView.backgroundColor = transparent()
        favoriteCollectionView.anchor(top: favLabel.bottomAnchor, left: view.leftAnchor,
                                   right: view.rightAnchor, height: myHeight)
        
        
        
        view.addSubview(ratedLabel)
        
        ratedLabel.anchor(top: favoriteCollectionView.bottomAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, height: 30)
        
        view.addSubview(ratedCollectionView)

        ratedCollectionView.backgroundColor = transparent()
        ratedCollectionView.anchor(top: ratedLabel.bottomAnchor, left: view.leftAnchor,
                                   right: view.rightAnchor, height: myHeight)

        
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        
        ratedCollectionView.delegate = self
        ratedCollectionView.dataSource = self
        
        
        
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        //print("Entered prefferd")
        
        return .lightContent
    }
    // MARK: - Selectors
    
    @objc func handleMessageUser() {
        print("Message user here..")
    }
    
    @objc func handleFollowUser() {
        print("Follow user here..")
    }

    func getRatedMovies(){
        
        let url = URL(string: "https://api.themoviedb.org/3/account/\(APICaller.client.accountID)/rated/movies?api_key=b6dcea27a60a83ccbe00da3c72753438&language=en-US&session_id=\(APICaller.client.sessionID)&sort_by=created_at.asc&page=1")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let movieData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
             self.ratedMovies = movieData["results"] as! [[String:Any]]
            self.ratedCount = self.ratedMovies.count
            self.ratedCollectionView.reloadData()
        
           }
        }
        task.resume()
    }
    
    func getFavMovies(){
        
        let url = URL(string: "https://api.themoviedb.org/3/account/\(APICaller.client.accountID)/favorite/movies?api_key=b6dcea27a60a83ccbe00da3c72753438&language=en-US&session_id=\(APICaller.client.sessionID)&sort_by=created_at.asc&page=1")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let movieData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
             self.favMovies = movieData["results"] as! [[String:Any]]
            self.favCount = self.favMovies.count
            self.favoriteCollectionView.reloadData()
        
           }
        }
        task.resume()
    }
    
    func transparent() -> UIColor{
        
        return UIColor(red: 255, green: 255, blue: 255, alpha: 0)
    }
    
    func darkMode() -> UIColor{
        
        return UIColor(red: 0, green: 0, blue: 255, alpha: 0.10)
    }

}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let mainBlue = UIColor.rgb(red: 11, green: 68, blue: 112)
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0,
                paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension AuthenticateViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let myHeight = (view.frame.height - 80)/3
        
        return CGSize(width: (ratedCollectionView.frame.width-2)/4, height: (myHeight - 34)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.ratedCollectionView{
            
            return ratedCount
        }
        return favCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.ratedCollectionView{
            
            let cell = ratedCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! customCellRate
            
            let movie = ratedMovies[indexPath.item]
            
            let baseUrl = "https://image.tmdb.org/t/p/w185"
            
            if let posterPath = movie["poster_path"] as? String {
                let posterUrl = URL (string: baseUrl + posterPath)!
                cell.bg.af_setImage(withURL: posterUrl, placeholderImage: UIImage(named: "default-poster"))
            } else {
                cell.bg.image = UIImage(named: "default-poster")
            }
            
            cell.backgroundColor = transparent()
            
            return cell
        }
        else{
            
            let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! customCellRate
            
            let movie = favMovies[indexPath.item]
            
            let baseUrl = "https://image.tmdb.org/t/p/w185"
            
            if let posterPath = movie["poster_path"] as? String {
                let posterUrl = URL (string: baseUrl + posterPath)!
                cell.bg.af_setImage(withURL: posterUrl, placeholderImage: UIImage(named: "default-poster"))
            } else {
                cell.bg.image = UIImage(named: "default-poster")
            }
            
            cell.backgroundColor = transparent()
            
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let mySender = sender as? UICollectionViewCell {
            print("Table View Cell Clicked")

            let cell = mySender
            let indexPath = favoriteCollectionView.indexPath(for: cell)!
            let movie = favMovies[indexPath.item]

            // Pass the selected movie to the details view controller

            let detailsViewController = segue.destination as! MovieDetailsViewController

            detailsViewController.movie = movie
            
        }
    }
    
}

class customCellRate : UICollectionViewCell{
    
    let bg : UIImageView = {
        
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "default-poster")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
