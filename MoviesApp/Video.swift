//
//  MovieVideo.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 13.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import Alamofire

class Video {
    
    private var _youtubeKey: String!
    
    var youtubeKey: String {
        return _youtubeKey
    }
    
    func downloadVideo(movieId: Int, completed: @escaping DownloadCompleted) {
        let videoString = "\(videoStringP1)\(movieId)\(videoStringP2)"
        let videoURL = URL(string: videoString)
        Alamofire.request(videoURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let results = jsonData["results"] as? [Dictionary<String, AnyObject>] {
                    if results.count > 0 {
                        if let ytKey = results[0]["key"] as? String {
                            self._youtubeKey = ytKey
                        }
                    } else {
                        self._youtubeKey = ""
                    }
                }
            }
            completed()
        }
    }
    
    
}
