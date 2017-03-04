//
//  ActorsVC.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 21.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import Alamofire

class ActorsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var birthLbl: UILabel!
    @IBOutlet weak var birthPlaceLbl: UILabel!
    @IBOutlet weak var biographyLbl: UITextView!
    @IBOutlet weak var actorImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    var actorId: Int!
    var actor: Actor!
    
    var knownForArray = [KnownFor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        actor = Actor()
        actor.getActorDetails(actorId: actorId) { 
            self.configureUI()
            self.getKnownFor(imdbId: self.actor.imbdId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return knownForArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let knownForObj = knownForArray[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCollectionCell", for: indexPath) as? ActorsCollectionCell {
            cell.configureCell(knownFor: knownForObj)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func getKnownFor(imdbId: String) {
        let imdbLink = "\(imdbP1)\(imdbId)\(imdbP2)"
        let imdbURL = URL(string: imdbLink)
        Alamofire.request(imdbURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let results = jsonData["person_results"] as? [Dictionary<String, AnyObject>] {
                    if let movies = results[0]["known_for"] as? [Dictionary<String, AnyObject>] {
                        for movie in movies {
                            let knownForObj = KnownFor(moviesDict: movie)
                            self.knownForArray.append(knownForObj)
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func configureUI() {
        nameLbl.text = actor.actorName
        let now = NSDate()
        let calendar : NSCalendar = NSCalendar.current as NSCalendar
        let ageComponents = calendar.components(.year, from: self.actor.durationYears, to: now as Date, options: [])
        let age = ageComponents.year!
        birthLbl.text = "\(actor.birthday) (\(age)) years"
        birthPlaceLbl.text = actor.birthPlace
        biographyLbl.text = actor.biography
        if actor.imagePath != "" {
            let convertImageURL = NSURL(string: "\(imageURL)\(actor.imagePath)")
            let data = NSData(contentsOf:convertImageURL! as URL)
            if data != nil {
                DispatchQueue.main.async(execute: {
                    self.actorImg.image = UIImage(data: data as! Data)
                })
            }
        } else {
            actorImg.image = UIImage(named: "emptyImage")
        }
    }

    @IBAction func backBtnPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromActorToDetails" {
            if let destination = segue.destination as? DetailsVC {
                let cell = sender as! UICollectionViewCell
                let indexPath = collectionView.indexPath(for: cell)
                destination.movieId = knownForArray[(indexPath?.row)!].movieId
            }
        }
    }
    
    
    
    
    
    
    
}
