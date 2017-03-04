//
//  Actor.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 21.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation
import Alamofire

class Actor {
    
    private var _biography: String!
    private var _birthday: String!
    private var _birthPlace: String!
    private var _imagePath: String!
    private var _actorName: String!
    private var _imdbId: String!
    private var _durationYears: Date!
    
    var biography: String {
        if _biography == nil {
            _biography = "Can't find information"
        }
        return _biography
    }
    var birthday: String {
        if _birthday == nil {
            _birthday = "Can't find information"
        }
        return _birthday
    }
    var birthPlace: String {
        if _birthPlace == nil {
            _birthPlace = "Can't find information"
        }
        return _birthPlace
    }
    var imagePath: String {
        if _imagePath == nil {
            _imagePath = ""
        }
        return _imagePath
    }
    var actorName: String {
        return _actorName
    }
    var imbdId: String {
        if _imdbId == nil {
            _imdbId = ""
        }
        return _imdbId
    }
    var durationYears: Date {
        if _durationYears == nil {
            _durationYears = Date()
        }
        return _durationYears
    }
    
    func getActorDetails(actorId: Int, completed: @escaping DownloadCompleted) {
        let detailsLink = "\(actorDetailsP1)\(actorId)\(actorDetailsP2)"
        let detailsURL = URL(string: detailsLink)
        Alamofire.request(detailsURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let biography = jsonData["biography"] as? String {
                    self._biography = biography
                }
                if let name = jsonData["name"] as? String {
                    self._actorName = name
                }
                if let dateOfBirth = jsonData["birthday"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let myDate = dateFormatter.date(from: dateOfBirth)
                    self._durationYears = myDate
                    self._birthday = dateOfBirth
                }
                if let birthPlace = jsonData["place_of_birth"] as? String {
                    self._birthPlace = birthPlace
                }
                if let profilePath = jsonData["profile_path"] as? String {
                    self._imagePath = profilePath
                }
                if let imdb = jsonData["imdb_id"] as? String {
                    self._imdbId = imdb
                }
            }
            completed()
        }
    }
    
}
