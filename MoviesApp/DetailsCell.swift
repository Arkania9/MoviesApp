//
//  DetailsCell.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 15.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
    @IBOutlet weak var castImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var characterLbl: UILabel!

    var cast: Cast!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(cast: Cast, img:UIImage?=nil) {
        self.cast = cast
        nameLbl.text = cast.name
        characterLbl.text = cast.character
        
        if cast.profilePath != "" {
            if img != nil {
                self.castImg.image = img
            } else {
                let convertImageURL = NSURL(string: "\(imageURL)\(cast.profilePath)")
                let data = NSData(contentsOf:convertImageURL! as URL)
                if let imgData = data {
                    let img = UIImage(data: imgData as Data)
                    DispatchQueue.main.async(execute: { 
                        self.castImg.image = img
                    })
                    DetailsVC.imageCache.setObject(img!, forKey: cast.profilePath as NSString)
                }
            }
        } else {
            self.castImg.image = UIImage(named: "profile")
        }

    }

}
