//
//  Favourite.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 23.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation

class Favourite {
    
    private var _movieId: Int!
    private var _imagePath: String!
    private var _title: String!
    private var _vote: Double!

    var movieId: Int {
        return _movieId
    }
    var imagePath: String {
        if _imagePath == nil {
            _imagePath = ""
        }
        return _imagePath
    }
    var title: String {
        return _title
    }
    var vote: Double {
        return _vote
    }

    
    init(favouriteDict: Dictionary<String, AnyObject>) {
        if let id = favouriteDict["id"] as? Int {
            self._movieId = id
        }
    }
    
    init(favoDict: Dictionary<String, AnyObject>) {
        if let id = favoDict["id"] as? Int {
            self._movieId = id
        }
        if let title = favoDict["title"] as? String {
            self._title = title
        }
        if let vote = favoDict["vote_average"] as? Double {
            self._vote = vote
        }
        if let posterPath = favoDict["poster_path"] as? String {
            self._imagePath = posterPath
        }
    }
    
}
