//
//  Cast.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 15.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import Foundation


class Cast {
    
    private var _profilePath: String!
    private var _name: String!
    private var _character: String!
    private var _actorId: Int!
    
    var profilePath: String {
        if _profilePath == nil {
            _profilePath = ""
        }
        return _profilePath
    }
    var name: String {
        return _name
    }
    var character: String {
        return _character
    }
    var actorId: Int {
        if _actorId == nil {
            _actorId = 0
        }
        return _actorId
    }
    
    init(castDictionary: Dictionary<String, AnyObject>) {
        if let name = castDictionary["name"] as? String {
            self._name = name
        }
        if let profilePath = castDictionary["profile_path"] as? String {
            self._profilePath = profilePath
        }
        if let character = castDictionary["character"] as? String {
            self._character = character
        }
        if let id = castDictionary["id"] as? Int {
            self._actorId = id
        }
    }
    
}
