//
//  MainMovieView.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 08.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class MainMovieView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2.0
        layer.cornerRadius = 6.0
        layer.shadowOffset = CGSize(width: 0.5, height: 1.2)
    }

}
