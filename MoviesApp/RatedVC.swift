//
//  RatedVC.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 26.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import Alamofire

class RatedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var menuBar: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageTitleOutlet: UILabel!
    @IBOutlet weak var pageLbl: UILabel!
    @IBOutlet weak var nextOutlet: UIButton!
    @IBOutlet weak var previousOutlet: UIButton!

    var ratedArray = [Rated]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    let sessionID = UserDefaults.standard.object(forKey: "SessionId")
    let userID = UserDefaults.standard.object(forKey: "UserId")
    var currentPage = 1
    var pages: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if Shared.shared.isLogged == true {
            pageTitleOutlet.alpha = 1
            pageLbl.alpha = 1
            getRated(page: currentPage, completed: { 
                if self.pages > 1 {
                    self.nextOutlet.alpha = 1
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
        return ratedArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ratedObj = ratedArray[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RatedCell") as? RatedCell {
            if let img = RatedVC.imageCache.object(forKey: ratedObj.imagePath as NSString) {
                cell.configureRated(rated: ratedObj, img: img)
                return cell
            }
            cell.configureRated(rated: ratedObj)
            return cell
        }
        return UITableViewCell()
    }
    
    func getRated(page: Int, completed: @escaping DownloadCompleted) {
        let ratedLink = "\(ratedMoviesP1)\(userID!)\(ratedMoviesP2)\(sessionID!)\(ratedMoviesP3)\(ratedMoviesP4)\(page)"
        let ratedURL = URL(string: ratedLink)
        Alamofire.request(ratedURL!).responseJSON { (response) in
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
                            let ratedObj = Rated(ratedDict: result)
                            self.ratedArray.append(ratedObj)
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
        let alert = UIAlertController(title: "No results", message: "Rate movie to see the list", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: AnyObject) {
        currentPage += 1
        getRated(page: currentPage, completed: {})
        self.tableView.reloadData()
        pageLbl.text = "\(currentPage)"
        previousOutlet.alpha = 1
    }
    
    @IBAction func previousPressed(_ sender: AnyObject) {
        if currentPage == 2 {
            currentPage = 1
            getRated(page: currentPage, completed: {})
            self.tableView.reloadData()
            pageLbl.text = "\(currentPage)"
            previousOutlet.alpha = 0
        } else {
            currentPage -= 1
            getRated(page: currentPage, completed: {})
            self.tableView.reloadData()
            pageLbl.text = "\(currentPage)"
            previousOutlet.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailsFromRated" {
            if let destination = segue.destination as? DetailsVC {
                destination.movieId = ratedArray[tableView.indexPathForSelectedRow!.row].movieId
            }
        }
    }
    
}











