//
//  WatchlistCell.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 25.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class WatchlistCell: UITableViewCell {
    @IBOutlet weak var mainImg: ImageMovieView!
    @IBOutlet weak var voteLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var watchlist: Watchlist!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWatchlist(watchlist: Watchlist, img: UIImage? = nil) {
        self.watchlist = watchlist
        voteLbl.text = "\(watchlist.vote)"
        titleLbl.text = "\(watchlist.title)"
        if watchlist.imagePath != "" {
            if img != nil {
                self.mainImg.image = img
            } else {
                let convertImageURL = NSURL(string: "\(imageURL)\(watchlist.imagePath)")
                let data = NSData(contentsOf:convertImageURL! as URL)
                if let imgData = data {
                    let img = UIImage(data: imgData as Data)
                    DispatchQueue.main.async(execute: {
                        self.mainImg.image = UIImage(data: data as! Data)
                        FavouriteVC.imageCache.setObject(img!, forKey: watchlist.imagePath as NSString)
                    })
                }
            }
        } else {
            mainImg.image = UIImage(named: "emptyImage")
        }
    }
    
}
