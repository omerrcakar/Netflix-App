//
//  HomeViewModel.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 18.10.2025.
//

import Foundation
// ViewModel'ın ViewController'a hangi mesajları göndereceğini tanımlayan protokol.
// "Hey ViewController, filmleri getirdim!" veya "Hey, bir hata oldu!" gibi.

protocol HomeViewModelDelegate: AnyObject {
    func moviesLoaded()
    func moviesFailed(error: Error)
}

class HomeViewModel {
    // BAĞIMLILIK ENJEKSİYONU (Dependency Injection)
    // ViewModel, network servisinin ne olduğunu bilmez, sadece sözleşmeyi (protokolü) bilir.
    // Bu sayede istediğimiz servisi (Alamofire, URLSession, Mock) ona verebiliriz.
    
    private let networkService: NetworkServiceProtocol
    
    // Şimdi HomeViewController'a gidelim ve ViewModel'dan gelen mesajları dinlemeye hazır olduğunu söyleyelim.
    weak var delegate: HomeViewModelDelegate?
    
    // Artık [Movie] tutuyoruz ve bölüm (section) bazında saklıyoruz.
    var movies: [Sections: [Movie]] = [:]
    var popularMovies: [Movie] = []
    var randomPopularMovie: Movie? // Header'da göstereceğimiz film
    
    // init ile network servisini dışarıdan alıyoruz.
    init(networkService: NetworkServiceProtocol = AlamofireNetworkManager()) {
        self.networkService = networkService
    }
    
    func fetchPopularMovies(){
        networkService.fetchData(.popular) { [weak self] (result: Result<MovieResponse,Error>) in
            // UI güncellemeleri her zaman ana iş parçacığında (main thread) yapılmalıdır.
            // Network isteği arka planda (background thread) çalışır, bu yüzden ana thread'e geçiş yapmalıyız.
            DispatchQueue.main.async {
                switch result {
                case.success(let movieResponse):
                    // Gelen filmleri 'movies' dictionary'mize ekliyoruz.
                    self?.movies[.popular] = movieResponse.results
                    self?.popularMovies = movieResponse.results ?? []
                    self?.randomPopularMovie = self?.popularMovies.randomElement()
                    // Her şey yolunda, delegate'e haber verelim: "Filmler yüklendi!"
                    self?.delegate?.moviesLoaded()
                    
                case.failure(let error):
                    // Bir hata oldu, delegate'e haber verelim: "Filmler yüklenemedi!"
                    self?.delegate?.moviesFailed(error: error)
                    
                }
            }
        }
    }
    
    func fetchTopRatedMovies(){
        networkService.fetchData(.topRated) { [weak self] (result: Result<MovieResponse,Error>) in
            DispatchQueue.main.async {
                switch result {
                case.success(let movieResponse):
                    // Gelen filmleri 'movies' dictionary'mize ekliyoruz.
                    self?.movies[.topRated] = movieResponse.results
                    
                    // Her şey yolunda, delegate'e haber verelim: "Filmler yüklendi!"
                    self?.delegate?.moviesLoaded()
                    
                case.failure(let error):
                    // Bir hata oldu, delegate'e haber verelim: "Filmler yüklenemedi!"
                    self?.delegate?.moviesFailed(error: error)
                    
                }
            }
        }
    }
    
    func fetchUpcomingMovies(){
        networkService.fetchData(.upComing) { [weak self] (result: Result<MovieResponse,Error>) in
            DispatchQueue.main.async {
                switch result {
                case.success(let movieResponse):
                    // Gelen filmleri 'movies' dictionary'mize ekliyoruz.
                    self?.movies[.upcoming] = movieResponse.results
                    
                    // Her şey yolunda, delegate'e haber verelim: "Filmler yüklendi!"
                    self?.delegate?.moviesLoaded()
                    
                case.failure(let error):
                    // Bir hata oldu, delegate'e haber verelim: "Filmler yüklenemedi!"
                    self?.delegate?.moviesFailed(error: error)
                    
                }
            }
        }
    }
}
