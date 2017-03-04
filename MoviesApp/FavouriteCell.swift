//
//  FavouriteCell.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 23.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class FavouriteCell: UITableViewCell {

    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var voteLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var favouriteImg: UIImageView!

    var favourite: Favourite!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureFavourite(favourite: Favourite, img: UIImage? = nil) {
        self.favourite = favourite
        voteLbl.text = "\(favourite.vote)"
        titleLbl.text = favourite.title
        if favourite.imagePath != "" {
            if img != nil {
                self.mainImg.image = img
            } else {
                let convertImageURL = NSURL(string: "\(imageURL)\(favourite.imagePath)")
                let data = NSData(contentsOf:convertImageURL! as URL)
                if let imgData = data {
                    let img = UIImage(data: imgData as Data)
                    DispatchQueue.main.async(execute: {
                        self.mainImg.image = UIImage(data: data as! Data)
                        WatchlistVC.imageCache.setObject(img!, forKey: favourite.imagePath as NSString)
                    })
                }
            }
        } else {
            mainImg.image = UIImage(named: "emptyImage")
        }
    }
}
