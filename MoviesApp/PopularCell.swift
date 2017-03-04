//
//  MovieCell.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 08.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class PopularCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var movieDesc: UITextView!
    
    var popular: PopularMovies!
    var topRated: TopRated!
    var upcoming: Upcoming!
    var nowPlaying: NowPlaying!
    var search: Search!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(popular: PopularMovies, img: UIImage? = nil) {
        self.popular = popular
        movieTitle.text = popular.title
        movieDesc.text = popular.description
        voteAverage.text = "\(popular.voteAverage)"
        if popular.imagePath != "" {
            if img != nil {
                self.mainImage.image = img
            } else {
                let convertImageURL = NSURL(string: "\(imageURL)\(popular.imagePath)")
                let data = NSData(contentsOf:convertImageURL! as URL)
                if let imgData = data {
                    let img = UIImage(data: imgData as Data)
                    DispatchQueue.main.async(execute: {
                        self.mainImage.image = UIImage(data: data as! Data)
                        MainVC.popularCache.setObject(img!, forKey: popular.imagePath as NSString)
                    })
                }
            }
        } else {
            mainImage.image = UIImage(named: "emptyImage")
        }
    }
    
    func configureRated(topRated: TopRated) {
        self.topRated = topRated
        movieTitle.text = topRated.title
        movieDesc.text = topRated.description
        voteAverage.text = "\(topRated.voteAverage)"
        if topRated.imagePath != "" {
            let convertImageURL = NSURL(string: "\(imageURL)\(topRated.imagePath)")
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
    
    func configureUpcoming(upcoming: Upcoming) {
        self.upcoming = upcoming
        movieTitle.text = upcoming.title
        movieDesc.text = upcoming.description
        voteAverage.text = "\(upcoming.voteAverage)"
        if upcoming.imagePath != "" {
            let convertImageURL = NSURL(string: "\(imageURL)\(upcoming.imagePath)")
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
    
    func confiureNowPlaying(nowPlaying: NowPlaying) {
        self.nowPlaying = nowPlaying
        movieTitle.text = nowPlaying.title
        movieDesc.text = nowPlaying.description
        voteAverage.text = "\(nowPlaying.voteAverage)"
        if nowPlaying.imagePath != "" {
            let convertImageURL = NSURL(string: "\(imageURL)\(nowPlaying.imagePath)")
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
    
    func configureSearch(search: Search) {
        self.search = search
        movieTitle.text = search.title
        movieDesc.text = search.description
        voteAverage.text = "\(search.voteAverage)"
        if search.imagePath != "" {
            let convertImageURL = NSURL(string: "\(imageURL)\(search.imagePath)")
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
    
}







