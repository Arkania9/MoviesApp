//
//  DetailsVC.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 13.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import AMPopTip
import Cosmos

class DetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var typesLbl: UILabel!
    @IBOutlet weak var voteLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var productionLbl: UILabel!
    @IBOutlet weak var boxOfficeLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var mainImage: ImageMovieView!
    @IBOutlet weak var taglineLbl: UITextView!
    @IBOutlet weak var overviewLbl: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteImg: UIImageView!
    @IBOutlet weak var watchlistLbl: UIImageView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movieId: Int!
    var detailsMovie: DetailsMovie!
    var video: Video!
    var castArray = [Cast]()
    var favouriteArray = [Favourite]()
    var watchlistArray = [Watchlist]()
    var ratedArray = [Rated]()
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    let sessionID = UserDefaults.standard.object(forKey: "SessionId")
    let userID = UserDefaults.standard.object(forKey: "UserId")
    
    let popTip = AMPopTip()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        
        cosmosView.rating = 0
        cosmosView.settings.fillMode = .half
        cosmosView.settings.minTouchRating = 1
        
        self.popTip.shouldDismissOnTap = true
        self.popTip.edgeMargin = 5
        self.popTip.offset = 2
        self.popTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

            if Shared.shared.isLogged == true {
                getRatedMovies {
                    for rate in self.ratedArray {
                        if rate.movieId == self.movieId {
                            self.cosmosView.rating = rate.rating / 2
                            break
                        }
                    }
                }
                getWatchlistMovies {
                    for watch in self.watchlistArray {
                        if watch.movieId == self.movieId {
                            self.watchlistLbl.image = UIImage(named: "bookmarkRed")
                            Shared.shared.isWatchlist = true
                            break
                        } else {
                            Shared.shared.isWatchlist = false
                        }
                    }
                }
                getFavouriteMovies {
                    for favour in self.favouriteArray {
                        if favour.movieId == self.movieId {
                            self.favouriteImg.image = UIImage(named: "filled-heart")
                            Shared.shared.isFavourite = true
                            break
                        } else {
                            Shared.shared.isFavourite = false
                        }
                    }
                }
                cosmosView.didFinishTouchingCosmos = { rating in
                    self.rateMovie(rating: rating, movieId: self.movieId)
                    self.popTip.popoverColor = UIColor.orange
                    self.popTip.showText("Rating \(rating * 2) added", direction: AMPopTipDirection.up, maxWidth: 200, in: self.scrollView, fromFrame: self.cosmosView.frame, duration: 1)
                }
            } else {
                self.cosmosView.settings.updateOnTouch = false
                cosmosView.didFinishTouchingCosmos = { rating in
                self.popTip.popoverColor = UIColor.orange
                self.popTip.showText("You need to sign in", direction: AMPopTipDirection.up, maxWidth: 200, in: self.scrollView, fromFrame: self.cosmosView.frame, duration: 2)
            }
        }
        
        detailsMovie = DetailsMovie()
        video = Video()
    
        video.downloadVideo(movieId: movieId) {
            self.getVideo(ytKey: self.video.youtubeKey)
            self.detailsMovie.downloadDetails(movieId: self.movieId, completed: { 
                self.configureUI()
                self.getCast(movieId: self.movieId)
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return castArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let castObj = castArray[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell") as? DetailsCell {
            if let img = DetailsVC.imageCache.object(forKey: castObj.profilePath as NSString) {
                cell.configureCell(cast: castObj, img: img)
                return cell
            }
            cell.configureCell(cast: castObj)
            return cell
        }
        return UITableViewCell()
    }
    
    func getRatedMovies(completed: @escaping DownloadCompleted) {
        let ratedMoviesLink = "\(ratedMoviesP1)\(userID!)\(ratedMoviesP2)\(sessionID!)\(ratedMoviesP3)"
        let ratedMoviesURL = URL(string: ratedMoviesLink)
        Alamofire.request(ratedMoviesURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    for result in results {
                        let ratedObj = Rated(ratingDict: result)
                        self.ratedArray.append(ratedObj)
                    }
                }
            }
            completed()
        }
    }
    
    func rateMovie(rating: Double, movieId: Int) {
        let headers = ["content-type": "application/json;charset=utf-8"]
        let parameters = ["value": rating * 2]
        let rateMovieLink = "\(addRateMovieP1)\(movieId)\(addRateMovieP2)\(sessionID!)"
        let rateMovieURL = URL(string: rateMovieLink)
        Alamofire.request(rateMovieURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in}
    }
    
    func getFavouriteMovies(completed: @escaping DownloadCompleted) {
        let favouriteLink = "\(favouriteMovieP1)\(userID!)\(favouriteMovieP2)\(sessionID!)\(favouriteMovieP3)"
        let favouriteURL = URL(string: favouriteLink)
        Alamofire.request(favouriteURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    for result in results {
                        let favouriteObj = Favourite(favouriteDict: result)
                        self.favouriteArray.append(favouriteObj)
                    }
                }
            }
            completed()
        }
    }
    
    func getWatchlistMovies(completed: @escaping DownloadCompleted) {
        let watchlistLink = "\(watchlistMovieP1)\(userID!)\(watchlistMovieP2)\(sessionID!)\(watchlistMovieP3)"
        let watchlistURL = URL(string: watchlistLink)
        Alamofire.request(watchlistURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    for result in results {
                        let watchlistObj = Watchlist(watchDict: result)
                        self.watchlistArray.append(watchlistObj)
                    }
                }
            }
            completed()
        }
    }
    
    func getCast(movieId: Int) {
        let castString = "\(castStringP1)\(movieId)\(castStringP2)"
        let castURL = URL(string: castString)
        Alamofire.request(castURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let casts = jsonData["cast"] as? [Dictionary<String, AnyObject>] {
                    if casts.count < 10 {
                        for cast in casts {
                            let castObj = Cast(castDictionary: cast)
                            self.castArray.append(castObj)
                        }
                    } else {
                        for index in 0...9 {
                            let eachCast = casts[index]
                            let castObj = Cast(castDictionary: eachCast)
                            self.castArray.append(castObj)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getVideo(ytKey: String) {
        if ytKey == "" {
            errorAlert()
        } else {
            let videoString = "\(YTString)\(ytKey)"
            let videoURL = URL(string: videoString)
            DispatchQueue.main.async {
                self.myWebView.loadRequest(URLRequest(url: videoURL!))
            }

        }
    }
    func removedFromFavorites() {
        let parameters = [
            "media_type": "movie",
            "media_id": movieId,
            "favorite": false
            ] as [String : Any]
        let headers = ["content-type": "application/json"]
        let favouriteString = "\(addToFavouriteP1)\(userID!)\(addToFavouriteP2)\(sessionID!)"
        let favouriteURL = URL(string: favouriteString)
        Alamofire.request(favouriteURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        }
        self.favouriteImg.image = UIImage(named: "empty-heart")
    }
    
    func addToFavorites() {
        let parameters = [
            "media_type": "movie",
            "media_id": movieId,
            "favorite": true
            ] as [String : Any]
        let headers = ["content-type": "application/json"]
        let favouriteString = "\(addToFavouriteP1)\(userID!)\(addToFavouriteP2)\(sessionID!)"
        let favouriteURL = URL(string: favouriteString)
        Alamofire.request(favouriteURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        }
        self.favouriteImg.image = UIImage(named: "filled-heart")
    }
    
    //WATCHLIST
    func removedFromWatchlist() {
        let parameters = [
            "media_type": "movie",
            "media_id": movieId,
            "watchlist": false
            ] as [String : Any]
        let headers = ["content-type": "application/json"]
        let watchlistString = "\(addToWatchlistP1)\(userID!)\(addToWatchlistP2)\(sessionID!)"
        let watchlistURL = URL(string: watchlistString)
        Alamofire.request(watchlistURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        }
        self.watchlistLbl.image = UIImage(named: "bookmark")
    }
    
    func addToWatchlist() {
        let parameters = [
            "media_type": "movie",
            "media_id": movieId,
            "watchlist": true
            ] as [String : Any]
        let headers = ["content-type": "application/json"]
        let watchlistString = "\(addToWatchlistP1)\(userID!)\(addToWatchlistP2)\(sessionID!)"
        let watchlistURL = URL(string: watchlistString)
        Alamofire.request(watchlistURL!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
        }
        self.watchlistLbl.image = UIImage(named: "bookmarkRed")
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Error", message: "Can't find trailer", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureUI() {
        titleLbl.text = detailsMovie.title
        voteLbl.text = "\(detailsMovie.voteAverage)"
        dateLbl.text = detailsMovie.releaseDate
        durationLbl.text = "\(detailsMovie.duration) minutes"
        taglineLbl.text = detailsMovie.tagline
        overviewLbl.text = detailsMovie.overview
        if detailsMovie.typeTwo == "" {
            typesLbl.text = detailsMovie.typeOne
        } else {
            typesLbl.text = "\(detailsMovie.typeOne), \(detailsMovie.typeTwo)"
        }
        if detailsMovie.productionTwo == "" {
            productionLbl.text = detailsMovie.productionOne
        } else {
            productionLbl.text = "\(detailsMovie.productionOne), \(detailsMovie.productionTwo)"
        }
        
        //CONVERT BOX OFFICE TO DECIMAL PLACES
        let myInteger = detailsMovie.boxOffice
        let myString = myInteger.stringFormattedWithSeparator
        boxOfficeLbl.text = "$\(myString)"
        
        if detailsMovie.posterPath != "" {
            let convertImageURL = NSURL(string: "\(imageURL)\(detailsMovie.posterPath)")
            let data = NSData(contentsOf:convertImageURL! as URL)
            if data != nil {
                DispatchQueue.main.async(execute: { 
                    self.mainImage.image = UIImage(data: data as! Data)
                })
            }
        } else {
            mainImage.image = UIImage(named: "emptyImage")
        }
    }
    
    
    @IBAction func backToMainVC(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuPressed(_ sender: AnyObject) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! SWRevealViewController!
        self.present(next!, animated: true, completion: nil)

    }
    

    @IBAction func addToFavourite(_ sender: AnyObject) {
        if Shared.shared.isLogged == true {
            if Shared.shared.isFavourite == true {
                self.removedFromFavorites()
                Shared.shared.isFavourite = false
                self.popTip.popoverColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1.0)
                self.popTip.showText("Removed from favorites", direction: AMPopTipDirection.up, maxWidth: 200, in: self.scrollView, fromFrame: self.favouriteImg.frame, duration: 1)
            } else {
                self.addToFavorites()
                Shared.shared.isFavourite = true
                self.popTip.popoverColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
                self.popTip.showText("Added to favorites", direction: AMPopTipDirection.up, maxWidth: 200, in: self.scrollView, fromFrame: self.favouriteImg.frame, duration: 1)
            }
        } else {
            self.popTip.popoverColor = UIColor(red: 183/255, green: 28/255, blue: 28/255, alpha: 1.0)
            self.popTip.showText("You need to sign In", direction: AMPopTipDirection.up, maxWidth: 200, in: self.scrollView, fromFrame: self.favouriteImg.frame, duration: 2)
        }
    }
    
    
    @IBAction func addToWatchlist(_ sender: AnyObject) {
        if Shared.shared.isLogged == true {
            if Shared.shared.isWatchlist == true {
                self.removedFromWatchlist()
                Shared.shared.isWatchlist = false
                self.popTip.popoverColor = UIColor(red: 97/255, green: 97/255, blue: 97/255, alpha: 1.0)
                self.popTip.showText("Removed from watchlist", direction: AMPopTipDirection.up, maxWidth: 200, in: self.scrollView, fromFrame: self.watchlistLbl.frame, duration: 1)
            } else {
                self.addToWatchlist()
                Shared.shared.isWatchlist = true
                self.popTip.popoverColor = UIColor(red: 251/255, green: 69/255, blue: 56/255, alpha: 1.0)
                self.popTip.showText("Added to watchlist", direction: AMPopTipDirection.up, maxWidth: 200, in: self.scrollView, fromFrame: self.watchlistLbl.frame, duration: 1)
            }
        } else {
            self.popTip.popoverColor = UIColor(red: 183/255, green: 28/255, blue: 28/255, alpha: 1.0)
            self.popTip.showText("You need to sign In", direction: AMPopTipDirection.up, maxWidth: 200, in: self.scrollView, fromFrame: self.watchlistLbl.frame, duration: 2)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showActorDetails" {
            if let destination = segue.destination as? ActorsVC {
                destination.actorId = castArray[tableView.indexPathForSelectedRow!.row].actorId
            }
        }
    }
    
}
