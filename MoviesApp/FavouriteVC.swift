//
//  FavouriteVC.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 23.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import Alamofire

class FavouriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuBar: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageLbl: UILabel!
    @IBOutlet weak var nextOutlet: UIButton!
    @IBOutlet weak var previousOutlet: UIButton!
    @IBOutlet weak var pageTitleOutlet: UILabel!

    var favouriteArray = [Favourite]()
    let sessionID = UserDefaults.standard.object(forKey: "SessionId")
    let userID = UserDefaults.standard.object(forKey: "UserId")
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var pages: Int!
    var currentPage = 1
    var movieId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            if Shared.shared.isLogged == true {
                pageTitleOutlet.alpha = 1
                pageLbl.alpha = 1
                getFavouriteMovies(page: currentPage, completed: {
                    if self.pages > 1 {
                        self.nextOutlet.alpha = 1
                    }
                })
            } else {
                resultsAlert()
            }
        tableView.delegate = self
        tableView.dataSource = self
        
        menuBar.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favouriteObj = favouriteArray[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell") as? FavouriteCell {
            if let img = FavouriteVC.imageCache.object(forKey: favouriteObj.imagePath as NSString) {
                cell.configureFavourite(favourite: favouriteObj, img: img)
                return cell
            }
            cell.configureFavourite(favourite: favouriteObj)
            return cell
        }
        return UITableViewCell()
    }
    
    func getFavouriteMovies(page: Int, completed: @escaping DownloadCompleted) {
        let favouriteLink = "\(favouriteMovieP1)\(userID!)\(favouriteMovieP2)\(sessionID!)\(favouriteMovieP3)\(favouriteMovieP4)\(page)"
        let favouriteURL = URL(string: favouriteLink)
        Alamofire.request(favouriteURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let totalPages = jsonData["total_pages"] as? Int {
                    self.pages = totalPages
                }
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    self.favouriteArray = []
                    if results.count == 0 {
                        self.favouriteMovieAlert()
                    } else {
                        for result in results {
                            let favouriteObj = Favourite(favoDict: result)
                            self.favouriteArray.append(favouriteObj)
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
        let alert = UIAlertController(title: "No results", message: "Add movie to favourite", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func nextPage(_ sender: AnyObject) {
        currentPage += 1
        getFavouriteMovies(page: currentPage) {}
        self.tableView.reloadData()
        pageLbl.text = "\(currentPage)"
        previousOutlet.alpha = 1

    }
    @IBAction func previousPage(_ sender: AnyObject) {
        if currentPage == 2 {
            currentPage = 1
            getFavouriteMovies(page: currentPage, completed: {})
            self.tableView.reloadData()
            pageLbl.text = "\(currentPage)"
            previousOutlet.alpha = 0
        } else {
            currentPage -= 1
            getFavouriteMovies(page: currentPage, completed: {})
            self.tableView.reloadData()
            pageLbl.text = "\(currentPage)"
            previousOutlet.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToDetailsFromFavourite" {
                if let destinaion = segue.destination as? DetailsVC {
                    destinaion.movieId = favouriteArray[tableView.indexPathForSelectedRow!.row].movieId
            }
        }
    }
    
}
















