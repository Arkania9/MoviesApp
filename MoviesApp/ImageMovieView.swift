//
//  ImageMovieView.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 08.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

class ImageMovieView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 6.0
    }
}
