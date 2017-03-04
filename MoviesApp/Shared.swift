//
//  Shared.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 22.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation
import Alamofire


final class Shared {
    static let shared = Shared() //lazy init, and it only runs once
    
    var stringValue : String!
    var isFavourite = false
    var isLogged = false
    var isWatchlist = false
    var page = 1
}
