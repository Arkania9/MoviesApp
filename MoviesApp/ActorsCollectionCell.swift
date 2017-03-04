//
//  ActorsCollectionCell.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 21.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class ActorsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var movieActorLbl: UILabel!
    
    var knownFor: KnownFor!
    
    func configureCell(knownFor: KnownFor) {
        self.knownFor = knownFor
        self.movieNameLbl.text = knownFor.title
        self.movieActorLbl.text = "(\(knownFor.date))"
        if knownFor.imagePath != "" {
            let convertImageURL = NSURL(string: "\(imageURL)\(knownFor.imagePath)")
            let data = NSData(contentsOf:convertImageURL! as URL)
            if data != nil {
                DispatchQueue.main.async(execute: {
                    self.movieImg.image = UIImage(data: data as! Data)
                })
            }
        } else {
            movieImg.image = UIImage(named: "emptyImage")
        }
    }
    
}
