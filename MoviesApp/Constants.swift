//
//  Constants.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 08.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit

let popularString = "https://api.themoviedb.org/3/movie/popular?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US&page="

let imageURL = "https://image.tmdb.org/t/p/w300"

let topRatedString = "https://api.themoviedb.org/3/movie/top_rated?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US&page="

let castStringP1 = "https://api.themoviedb.org/3/movie/"
let castStringP2 = "/credits?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8"

let YTString = "https://www.youtube.com/watch?v="

let videoStringP1 = "https://api.themoviedb.org/3/movie/"
let videoStringP2 = "/videos?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US"

let detailsStringP1 = "https://api.themoviedb.org/3/movie/"
let detailsStringP2 = "?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US"

let upcomingString = "https://api.themoviedb.org/3/movie/upcoming?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US&page="

let nowPlayingString = "https://api.themoviedb.org/3/movie/now_playing?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US&page="

let searchMovieStringP1 = "https://api.themoviedb.org/3/search/movie?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US&query="
let searchMovieStringP2 = "&page=1&include_adult=false"

let actorDetailsP1 = "https://api.themoviedb.org/3/person/"
let actorDetailsP2 = "?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US"

let imdbP1 = "https://api.themoviedb.org/3/find/"
let imdbP2 = "?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US&external_source=imdb_id"

let requestString = "https://api.themoviedb.org/3/authentication/token/new?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8"

let validateRequestP1 = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&username="
let validateRequestP2 = "&password="
let validateRequestP3 = "&request_token="

let sessionString = "https://api.themoviedb.org/3/authentication/session/new?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&request_token="

let accountDetails = "https://api.themoviedb.org/3/account?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&session_id="


let addToFavouriteP1 = "https://api.themoviedb.org/3/account/"
let addToFavouriteP2 = "/favorite?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&session_id="


let favouriteMovieP1 = "https://api.themoviedb.org/3/account/"
let favouriteMovieP2 = "/favorite/movies?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&session_id="
let favouriteMovieP3 = "&language=en-US&sort_by=created_at.desc"
let favouriteMovieP4 = "&page="

let addToWatchlistP1 = "https://api.themoviedb.org/3/account/"
let addToWatchlistP2 = "/watchlist?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&session_id="

let watchlistMovieP1 = "https://api.themoviedb.org/3/account/"
let watchlistMovieP2 = "/watchlist/movies?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US&session_id="
let watchlistMovieP3 = "&sort_by=created_at.desc"
let watchlistMovieP4 = "&page="

let addRateMovieP1 = "https://api.themoviedb.org/3/movie/"
let addRateMovieP2 = "/rating?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&session_id="


let ratedMoviesP1 = "https://api.themoviedb.org/3/account/"
let ratedMoviesP2 = "/rated/movies?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US&session_id="
let ratedMoviesP3 = "&sort_by=created_at.desc"
let ratedMoviesP4 = "&page="


let createListP1 = "https://api.themoviedb.org/3/list?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&session_id="

let getListP1 = "https://api.themoviedb.org/3/account/"
let getListP2 = "/lists?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&session_id="
let getListP3 = "&page="

let addMovieToListP1 = "https://api.themoviedb.org/3/list/"
let addMovieToListP2 = "/add_item?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&session_id="

let listDetailsP1 = "https://api.themoviedb.org/3/list/"
let listDetailsP2 = "?api_key=6fc7bdce0b611a967ff8b6a61f9fc6e8&language=en-US"

typealias DownloadCompleted = () -> ()

struct Number {
    static let formatterWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Integer {
    var stringFormattedWithSeparator: String {
        return Number.formatterWithSeparator.string(from: self as! NSNumber) ?? ""
    }
}



extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
