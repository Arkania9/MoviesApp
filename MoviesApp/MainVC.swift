//
//  ViewController.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 08.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popularsLbl: UIButton!
    @IBOutlet weak var topRatedLbl: UIButton!
    @IBOutlet weak var upcomingLbl: UIButton!
    @IBOutlet weak var nowPlayingLbl: UIButton!
    @IBOutlet weak var pageLbl: UILabel!
    @IBOutlet weak var menuBar: UIButton!
    @IBOutlet weak var previousLbl: UIButton!
    
    var popularsArray = [PopularMovies]()
    var topRatedArray = [TopRated]()
    var upcomingArray = [Upcoming]()
    var nowPlayingArray = [NowPlaying]()
    var searchArray = [Search]()
    
    var changeType = 1
    var page = 1
    
    static var popularCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getPopularMovies(page: 1)
        self.revealViewController().rearViewRevealWidth = 300
        self.revealViewController().frontViewShadowRadius = 2
        self.revealViewController().frontViewShadowOpacity = 0.6
        self.revealViewController().rearViewRevealOverdraw = 0
        menuBar.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if changeType == 5 {
            return searchArray.count
        } else {
            return popularsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let popular = popularsArray[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PopularCell") as? PopularCell {
            if changeType == 1 {
                if let img = MainVC.popularCache.object(forKey: popular.imagePath as NSString ) {
                    cell.configureCell(popular: popular, img: img)
                    return cell
                }
            } else if changeType == 2 {
                let topRated = topRatedArray[indexPath.row]
                    cell.configureRated(topRated: topRated)
                    return cell
            } else if changeType == 3 {
                let upcoming = upcomingArray[indexPath.row]
                cell.configureUpcoming(upcoming: upcoming)
                return cell
            } else if changeType == 4 {
                let nowPlaying = nowPlayingArray[indexPath.row]
                cell.confiureNowPlaying(nowPlaying: nowPlaying)
                return cell
            } else {
                let search = searchArray[indexPath.row]
                cell.configureSearch(search: search)
                return cell
            }
            cell.configureCell(popular: popular)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.7) {
            cell.alpha = 1.0
        }
    }

    func getPopularMovies(page: Int) {
        let popularLink = "\(popularString)\(page)"
        let popularURL = URL(string: popularLink)
        Alamofire.request(popularURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    self.popularsArray = []
                    for result in results {
                        let popularMovie = PopularMovies(popularDict: result)
                        self.popularsArray.append(popularMovie)
                    }
                    self.changeType = 1
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getTopRatedMovies(page: Int) {
        let topRatedLink = "\(topRatedString)\(page)"
        let topRatedURL = URL(string: topRatedLink)
        Alamofire.request(topRatedURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    self.topRatedArray = []
                    for result in results {
                        let topRatedMovie = TopRated(topRatedDict: result)
                        self.topRatedArray.append(topRatedMovie)
                    }
                    self.changeType = 2
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getUpcomingMovies(page: Int) {
        let upcomingLink = "\(upcomingString)\(page)"
        let upcomingURL = URL(string: upcomingLink)
        Alamofire.request(upcomingURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    self.upcomingArray = []
                    for result in results {
                        let upcomingMovie = Upcoming(upcomingDict: result)
                        self.upcomingArray.append(upcomingMovie)
                    }
                    self.changeType = 3
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    func getNowPlayingMovies(page: Int) {
        let nowPlayingLink = "\(nowPlayingString)\(page)"
        let nowPlayingURL = URL(string: nowPlayingLink)
        Alamofire.request(nowPlayingURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    self.nowPlayingArray = []
                    for result in results {
                        let nowPlayingMovie = NowPlaying(nowPlayingDict: result)
                        self.nowPlayingArray.append(nowPlayingMovie)
                    }
                    self.changeType = 4
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getSearchMovies(title: String) {
        let searchMoviesLink = "\(searchMovieStringP1)\(title)\(searchMovieStringP2)"
        let searchMovieURL = URL(string: searchMoviesLink)
        Alamofire.request(searchMovieURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    if results.count == 0 {
                        self.errorAlert()
                        self.getPopularMovies(page: 1)
                    } else {
                        self.searchArray = []
                        for result in results {
                            let searchMovie = Search(searchDict: result)
                            self.searchArray.append(searchMovie)
                        }
                        self.changeType = 5
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchAlert() {
        let alert = UIAlertController(title: "Search movie", message: "Enter text", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Search movie"
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if let title = alert.textFields?.first?.text?.replacingOccurrences(of: " ", with: "%20") {
                self.getSearchMovies(title: title)
            } else {
                print("GIVE ME INFORMATIONS")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Error", message: "Make sure you wrote good title", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkType(page: Int) {
        if changeType == 1 {
            getPopularMovies(page: page)
            previousLbl.alpha = 1
            self.tableView.reloadData()
            pageLbl.text = "\(page)"
        } else if changeType == 2 {
            getTopRatedMovies(page: page)
            previousLbl.alpha = 1
            self.tableView.reloadData()
            pageLbl.text = "\(page)"
        } else if changeType == 3 {
            getUpcomingMovies(page: page)
            previousLbl.alpha = 1
            self.tableView.reloadData()
            pageLbl.text = "\(page)"
        } else {
            getNowPlayingMovies(page: page)
            previousLbl.alpha = 1
            self.tableView.reloadData()
            pageLbl.text = "\(page)"
        }
    }
    
    
    @IBAction func popularsPressed(_ sender: AnyObject) {
        getPopularMovies(page: 1)
        page = 1
        pageLbl.text = "\(1)"
        previousLbl.alpha = 0
        self.tableView.reloadData()
    }
    
    @IBAction func topRatedPressed(_ sender: AnyObject) {
        getTopRatedMovies(page: 1)
        page = 1
        pageLbl.text = "\(1)"
        previousLbl.alpha = 0
        self.tableView.reloadData()
    }
    
    @IBAction func upcomingPressed(_ sender: AnyObject) {
        getUpcomingMovies(page: 1)
        page = 1
        pageLbl.text = "\(1)"
        previousLbl.alpha = 0
        self.tableView.reloadData()

    }
    
    @IBAction func nowPlayingPressed(_ sender: AnyObject) {
        getNowPlayingMovies(page: 1)
        page = 1
        pageLbl.text = "\(1)"
        previousLbl.alpha = 0
        self.tableView.reloadData()

    }
    
    @IBAction func nextPage(_ sender: AnyObject) {
        page += 1
        checkType(page: page)
    }
    

    
    @IBAction func priviouslyPage(_ sender: AnyObject) {
        page -= 1
        if page == 1 {
            page = 1
            if changeType == 1 {
                getPopularMovies(page: page)
                previousLbl.alpha = 0
                self.tableView.reloadData()
                pageLbl.text = "\(page)"
            } else if changeType == 2 {
                getTopRatedMovies(page: page)
                previousLbl.alpha = 0
                self.tableView.reloadData()
                pageLbl.text = "\(page)"
            } else if changeType == 3 {
                getUpcomingMovies(page: page)
                previousLbl.alpha = 0
                self.tableView.reloadData()
                pageLbl.text = "\(page)"
            } else {
                getNowPlayingMovies(page: page)
                previousLbl.alpha = 0
                self.tableView.reloadData()
                pageLbl.text = "\(page)"
            }
        } else {
            checkType(page: page)
        }

    }
    
    @IBAction func searchMoviePressed(_ sender: AnyObject) {
        searchAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let destination = segue.destination as? DetailsVC {
                if changeType == 1 {
                    destination.movieId = popularsArray[tableView.indexPathForSelectedRow!.row].movieId
                } else if changeType == 2{
                    destination.movieId = topRatedArray[tableView.indexPathForSelectedRow!.row].movieId
                } else if changeType == 3{
                    destination.movieId = upcomingArray[tableView.indexPathForSelectedRow!.row].movieId
                } else if changeType == 4{
                    destination.movieId = nowPlayingArray[tableView.indexPathForSelectedRow!.row].movieId
                } else {
                    destination.movieId = searchArray[tableView.indexPathForSelectedRow!.row].movieId
                }
            }
        }
    }
    
}













