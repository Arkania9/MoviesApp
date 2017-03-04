//
//  Search.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 18.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation

class Search {
    
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
        if _title == nil {
            _title = ""
        }
        return _title
    }
    var voteAverage: Double {
        if _voteAverage == nil {
            _voteAverage = 0.0
        }
        return _voteAverage
    }
    init() {}
    
    init(searchDict: Dictionary<String, AnyObject>) {
        if let desc = searchDict["overview"] as? String {
            self._description = desc
        }
        if let id = searchDict["id"] as? Int {
            self._movieId = id
        }
        if let title = searchDict["title"] as? String {
            self._title = title
        }
        if let vote = searchDict["vote_average"] as? Double {
            self._voteAverage = vote
        }
        if let imagePath = searchDict["poster_path"] as? String{
            self._imagePath = imagePath
        }
        
    }
    
}
