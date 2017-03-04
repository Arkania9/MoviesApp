//
//  KnownFor.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 21.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation

class KnownFor {
    
    private var _title: String!
    private var _imagePath: String!
    private var _date: String!
    private var _movieId: Int!
    
    var title: String {
        if _title == nil {
            _title = "Lack of information"
        }
        return _title
    }
    var imagePath: String {
        if _imagePath == nil {
            _imagePath = ""
        }
        return _imagePath
    }
    var date: String {
        if _date == nil {
            _date = "Lack of information"
        }
        return _date
    }
    var movieId: Int {
        if _movieId == nil {
            _movieId = 0
        }
        return _movieId
    }
    
    init(moviesDict: Dictionary<String, AnyObject>) {
        if let date = moviesDict["release_date"] as? String {
            self._date = date
        }
        if let posterPath = moviesDict["poster_path"] as? String {
            self._imagePath = posterPath
        }
        if let title = moviesDict["title"] as? String {
            self._title = title
        }
        if let id = moviesDict["id"] as? Int {
            self._movieId = id
        }
    }
    
}
