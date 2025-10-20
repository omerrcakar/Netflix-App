//
//  NetworkConstants.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 16.10.2025.
//

import Foundation

protocol EndPointProtocol {
    var baseURL: String { get }
    var genreURL: String { get }
    var apiKey: String { get }
    var method: HTTPMethod { get }
    func movieApiURL() -> String
    func request() -> URLRequest
}


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}


enum EndPoint {
    case popular
    case topRated
    case upComing
}

extension EndPoint: EndPointProtocol {
    
    func request() -> URLRequest {
        guard let apiURL = URL(string: movieApiURL()) else { fatalError("Invalid URL") }
        var request = URLRequest(url: apiURL)
        request.httpMethod = method.rawValue
        return request
    }
    
    
    func movieApiURL() -> String {
        return "\(baseURL)\(genreURL)\(apiKey)"
    }
    
    var baseURL: String {
        return "https://api.themoviedb.org/3/movie/"
    }
    
    var genreURL: String {
        switch self {
        case .popular:
            return "popular"
        case.topRated:
            return "top_rated"
        case.upComing:
            return "upcoming"
        }
    }
    
    var apiKey: String {
        return "?api_key=1cd74f82f07f352de825519c1533ad6a"
    }
    
    var method: HTTPMethod {
        switch self{
        case.popular,.topRated,.upComing:
            return .get
        }
    }
}
