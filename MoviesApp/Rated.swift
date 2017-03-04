//
//  Rated.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 25.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation

class Rated {
    
    private var _movieId: Int!
    private var _rating: Double!
    private var _imagePath: String!
    private var _title: String!
    private var _vote: Double!
    
    var movieId: Int {
        return _movieId
    }
    var rating: Double {
        return _rating
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
    
    init(ratingDict: Dictionary<String, AnyObject>) {
        if let id = ratingDict["id"] as? Int {
            self._movieId = id
        }
        if let rating = ratingDict["rating"] as? Double {
            self._rating = rating
        }
    }
    
    init(ratedDict: Dictionary<String, AnyObject>) {
        if let id = ratedDict["id"] as? Int {
            self._movieId = id
        }
        if let rating = ratedDict["rating"] as? Double {
            self._rating = rating
        }
        if let posterPath = ratedDict["poster_path"] as? String {
            self._imagePath = posterPath
        }
        if let vote = ratedDict["vote_average"] as? Double {
            self._vote = vote
        }
        if let title = ratedDict["title"] as? String {
            self._title = title
        }
    }
    
}
