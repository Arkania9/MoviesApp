//
//  MovieDetails.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 13.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import Alamofire

class DetailsMovie {
    
    private var _title: String!
    private var _typeOne: String!
    private var _typeTwo: String!
    private var _voteAverage: Double!
    private var _releaseDate: String!
    private var _productionOne: String!
    private var _productionTwo: String!
    private var _boxOffice: Int!
    private var _duration: Int!
    private var _posterPath: String!
    private var _tagline: String!
    private var _overview: String!
    
    var title: String {
        return _title
    }
    var typeOne: String {
        return _typeOne
    }
    var typeTwo: String {
        return _typeTwo
    }
    var voteAverage: Double {
        return _voteAverage
    }
    var releaseDate: String {
        return _releaseDate
    }
    var productionOne: String {
        return _productionOne
    }
    var productionTwo: String {
        return _productionTwo
    }
    var boxOffice: Int {
        return _boxOffice
    }
    var duration: Int {
        if _duration == nil {
            _duration = 0
        }
        return _duration
    }
    var posterPath: String {
        if _posterPath == nil {
            _posterPath = ""
        }
        return _posterPath
    }
    var tagline: String {
        if _tagline == nil {
            _tagline = "Can't find movie tagline"
        }
        return _tagline
    }
    var overview: String {
        if _overview == nil {
            _overview = "Can't find movie overview"
        }
        return _overview
    }
    
    func downloadDetails(movieId: Int, completed: @escaping DownloadCompleted) {
        let detailsString = "\(detailsStringP1)\(movieId)\(detailsStringP2)"
        let detailsURL = URL(string: detailsString)
        Alamofire.request(detailsURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let title = jsonData["title"] as? String {
                    self._title = title
                }
                if let genres = jsonData["genres"] as? [Dictionary<String, AnyObject>] {
                    if genres.count == 0 {
                        self._typeOne = "Can't find movie types"
                        self._typeTwo = ""
                    } else {
                        if genres.count > 1 {
                            if let typeOne = genres[0]["name"] as? String {
                                self._typeOne = typeOne
                            }
                            if let typeTwo = genres[1]["name"] as? String {
                                self._typeTwo = typeTwo
                            }
                        } else {
                            if let typeOne = genres[0]["name"] as? String {
                                self._typeOne = typeOne
                                self._typeTwo = ""
                            }
                        }
                    }
                    if let vote = jsonData["vote_average"] as? Double {
                        self._voteAverage = vote
                    }
                    if let date = jsonData["release_date"] as? String {
                        self._releaseDate = date
                    }
                    
                    if let productions = jsonData["production_countries"] as? [Dictionary<String, AnyObject>] {
                        if productions.count == 0 {
                            self._productionOne = "Can't find productions"
                            self._productionTwo = ""
                        } else {
                            if productions.count > 1 {
                                if let prodOne = productions[0]["iso_3166_1"] as? String {
                                    self._productionOne = prodOne
                                }
                                if let prodTwo = productions[1]["iso_3166_1"] as? String {
                                    self._productionTwo = prodTwo
                                }
                            } else {
                                if let prodOne = productions[0]["iso_3166_1"] as? String {
                                    self._productionOne = prodOne
                                    self._productionTwo = ""
                                }
                            }
                        }
                    }
                    if let revenue = jsonData["revenue"] as? Int {
                        self._boxOffice = revenue
                    }
                    if let duration = jsonData["runtime"] as? Int {
                        self._duration = duration
                    }
                    if let posterPath = jsonData["poster_path"] as? String {
                        self._posterPath = posterPath
                    }
                    if let tagline = jsonData["tagline"] as? String {
                        self._tagline = tagline
                    }
                    if let overview = jsonData["overview"] as? String {
                        self._overview = overview
                    }
                }
            }
            completed()
        }
        
    }
    
}
