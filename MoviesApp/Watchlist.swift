//
//  Watchlist.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 24.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation

class Watchlist {
    
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
    
    init(watchDict: Dictionary<String, AnyObject>) {
        if let id = watchDict["id"] as? Int {
            self._movieId = id
        }
    }
    
    init(watchlistDict: Dictionary<String, AnyObject>) {
        if let id = watchlistDict["id"] as? Int {
            self._movieId = id
        }
        if let posterPath = watchlistDict["poster_path"] as? String {
            self._imagePath = posterPath
        }
        if let vote = watchlistDict["vote_average"] as? Double {
            self._vote = vote
        }
        if let title = watchlistDict["title"] as? String {
            self._title = title
        }
    }
    
}
