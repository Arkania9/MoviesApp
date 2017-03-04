//
//  RatedCell.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 26.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import Cosmos

class RatedCell: UITableViewCell {
    @IBOutlet weak var mainImg: ImageMovieView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var voteLbl: UILabel!
    
    var rated: Rated!

    override func awakeFromNib() {
        super.awakeFromNib()
        cosmosView.settings.fillMode = .half
        cosmosView.settings.minTouchRating = 0
        cosmosView.settings.updateOnTouch = false
    }
    
    func configureRated(rated: Rated, img: UIImage? = nil) {
        self.rated = rated
        titleLbl.text = rated.title
        voteLbl.text = "\(rated.vote)"
        cosmosView.rating = rated.rating / 2
        if rated.imagePath != "" {
            if img != nil {
                self.mainImg.image = img
            } else {
                let convertImageURL = NSURL(string: "\(imageURL)\(rated.imagePath)")
                let data = NSData(contentsOf:convertImageURL! as URL)
                if let imgData = data {
                    let img = UIImage(data: imgData as Data)
                    DispatchQueue.main.async(execute: {
                        self.mainImg.image = UIImage(data: data as! Data)
                        RatedVC.imageCache.setObject(img!, forKey: rated.imagePath as NSString)
                    })
                }
            }
        } else {
            mainImg.image = UIImage(named: "emptyImage")
        }
    }
    

}
