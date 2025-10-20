//
//  HomeViewController.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 14.10.2025.
//

import UIKit


// Her bir bölümün (section) ne olduğunu ve sırasını tanımlayan enum.
// CaseIterable, bu enum'ın tüm case'lerini bir dizi gibi (Sections.allCases) almamızı sağlar.
enum Sections: Int, CaseIterable {
    
    case popular = 0
    case upcoming = 1
    case topRated = 2
    
    // Her bölümün başlığını döndüren bir property.
    var title: String {
        switch self {
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming Movies"
        case .topRated:
            return "Top Rated"
        }
    }
}

class HomeViewController: UIViewController {
    
    private var viewModel = HomeViewModel()
    private let headerView = MainHeaderView(frame: .zero) // Header'ı burada oluştur
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.identifier)
        tableView.separatorStyle = .none // Hücreler arası çizgi kaldır
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 1. Delegate'i ayarlıyoruz. ViewModel'ın patronu artık bu ViewController.
        viewModel.delegate = self
        viewModel.fetchPopularMovies()
        viewModel.fetchTopRatedMovies()
        viewModel.fetchUpcomingMovies()
    }
    
    func setupUI(){
        view.backgroundColor = .systemBackground
        
        // headerView'ı burada frame ile oluşturmak yerine property olarak tanımla
        // ve tableView'a ata.
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.45)
        tableView.tableHeaderView = headerView
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }

}

// ViewController'ı ViewModel'ın delegesi yapıyoruz.
extension HomeViewController: HomeViewModelDelegate{
    func moviesLoaded() {
        // Header'ı güncelle!
        if let randomMovie = viewModel.randomPopularMovie {
            headerView.configure(with: randomMovie)
        }
        tableView.reloadData()
    }
    
    func moviesFailed(error: any Error) {
        // ViewModel "Hata var!" dedi. Kullanıcıya bir uyarı gösterebiliriz.
        print("Hata oluştu: \(error.localizedDescription)")
        // TODO: Kullanıcıya bir alert göster.
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    // Kaç tane bölümümüz (kategorimiz) olacağını enum'dan alıyoruz.
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    // Her 1 section içinde 1 row ( satır) olucak
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.identifier, for: indexPath) as! MoviesTableViewCell
        
        
        // BU SATIR ÇOK ÖNEMLİ!
        // Her hücreye, onun delegesinin HomeViewController'ın kendisi olduğunu söylüyoruz.
        cell.delegate = self
        
        // O anki bölümü (section) bul.
        guard let section = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
        
        // ViewModel'dan filmleri alıyoruz. (nil gelme ihtimaline karşı boş bir dizi atıyoruz)
        let moviesForSection = viewModel.movies[section] ?? []
        
        cell.configure(with: moviesForSection)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // Her bölümün başına bir başlık ekleyelim.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Mevcut section index'ine göre enum'dan doğru başlığı bulup döndürüyoruz.
        return Sections(rawValue: section)?.title
    }
    // Başlıkların stilini düzenleyelim.
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
}

extension HomeViewController: MoviesTableViewCellDelegate {
    func moviesTableViewCell(_ cell: MoviesTableViewCell, didSelectMovie movie: Movie) {
        print("Seçilen Film: \(movie.originalTitle ?? "N/A")")
        
        // Detay sayfasını oluştur.
        let detailViewController = MovieDetailViewController()
        
        // Seçilen film verisini detay sayfasına gönder.
        detailViewController.configure(with: movie)
        
        // Navigasyon push
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
}
