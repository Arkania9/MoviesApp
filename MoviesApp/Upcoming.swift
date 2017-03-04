//
//  Upcoming.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 16.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation

class Upcoming {
    
    private var _imagePath: String!
    private var _description: String!
    private var _movieId: Int!
    private var _title: String!
    private var _voteAverage: Double!
    
    var imagePath: String {
        if _imagePath == nil {
            _imagePath = ""
        }
        return _imagePath
    }
    var description: String {
        if _description == nil {
            _description = "Can't find description"
        }
        return _description
    }
    var movieId: Int {
        return _movieId
    }
    var title: String {
        return _title
    }
    var voteAverage: Double {
        return _voteAverage
    }
    
    init() {}
    
    init(upcomingDict: Dictionary<String, AnyObject>) {
        if let desc = upcomingDict["overview"] as? String {
            self._description = desc
        }
        if let id = upcomingDict["id"] as? Int {
            self._movieId = id
        }
        if let title = upcomingDict["title"] as? String {
            self._title = title
        }
        if let vote = upcomingDict["vote_average"] as? Double {
            self._voteAverage = vote
        }
        if let imagePath = upcomingDict["poster_path"] as? String{
            self._imagePath = imagePath
        }
    }
    
    
    
}
