//
//  WatchlistVC.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 25.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import Alamofire

class WatchlistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBar: UIButton!
    @IBOutlet weak var pageLbl: UILabel!
    @IBOutlet weak var nextLbl: UIButton!
    @IBOutlet weak var previousLbl: UIButton!
    @IBOutlet weak var pageTitleLbl: UILabel!
    
    var watchlistArray = [Watchlist]()
    var currentPage = 1
    var pages: Int!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    let sessionID = UserDefaults.standard.object(forKey: "SessionId")
    let userID = UserDefaults.standard.object(forKey: "UserId")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if Shared.shared.isLogged == true {
            pageTitleLbl.alpha = 1
            pageLbl.alpha = 1
            getWatchlist(page: currentPage, completed: {
                if self.pages > 1 {
                    self.nextLbl.alpha = 1
                }
            })
        } else {
            resultsAlert()
        }
        menuBar.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let watchlistObj = watchlistArray[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WatchlistCell") as? WatchlistCell {
            if let img = WatchlistVC.imageCache.object(forKey: watchlistObj.imagePath as NSString) {
                cell.configureWatchlist(watchlist: watchlistObj, img: img)
                return cell
            }
            cell.configureWatchlist(watchlist: watchlistObj)
            return cell
        }
        return UITableViewCell()
    }
    
    func getWatchlist(page: Int, completed: @escaping DownloadCompleted) {
        let watchlistLink = "\(watchlistMovieP1)\(userID!)\(watchlistMovieP2)\(sessionID!)\(watchlistMovieP3)\(favouriteMovieP3)\(page)"
        let watchlistURL = URL(string: watchlistLink)
        Alamofire.request(watchlistURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let totalPages = jsonData["total_pages"] as? Int {
                    self.pages = totalPages
                }
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    if results.count == 0 {
                        print("NO RESULTS")
                    } else {
                        for result in results {
                            let watchlistObj = Watchlist(watchlistDict: result)
                            self.watchlistArray.append(watchlistObj)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            completed()
        }
    }
    
    func resultsAlert() {
        let alert = UIAlertController(title: "No results", message: "You need to sign In", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func favouriteMovieAlert() {
        let alert = UIAlertController(title: "No results", message: "Add movie to your watchlist", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func previousAction(_ sender: AnyObject) {
        if currentPage == 2 {
            currentPage = 1
            getWatchlist(page: currentPage) {}
            self.tableView.reloadData()
            pageLbl.text = "\(currentPage)"
            previousLbl.alpha = 0
        } else {
            currentPage -= 1
            getWatchlist(page: currentPage) {}
            self.tableView.reloadData()
            pageLbl.text = "\(currentPage)"
            previousLbl.alpha = 1
        }
    }
    @IBAction func nextAction(_ sender: AnyObject) {
        currentPage += 1
        getWatchlist(page: currentPage) {}
        self.tableView.reloadData()
        pageLbl.text = "\(currentPage)"
        previousLbl.alpha = 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailsFromWatchlist" {
            if let destination = segue.destination as? DetailsVC {
                destination.movieId = watchlistArray[tableView.indexPathForSelectedRow!.row].movieId
            }
        }
    }
    
}











