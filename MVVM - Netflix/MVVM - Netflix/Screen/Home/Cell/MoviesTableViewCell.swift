//
//  MoviesTableViewCell.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 15.10.2025.
//

import UIKit


// Bu protokol, TableView hücresinin ViewController'a "Hey, içimdeki filmlerden birine tıklandı!" demesini sağlayacak.
protocol MoviesTableViewCellDelegate: AnyObject {
    // Hangi hücreden hangi filmin seçildiğini haber veren fonksiyon.
    func moviesTableViewCell(_ cell: MoviesTableViewCell, didSelectMovie movie: Movie)
}


class MoviesTableViewCell: UITableViewCell {
    // MoviesTableViewCell'e bu delegeyi tutması için bir property ekleyelim.
    weak var delegate: MoviesTableViewCellDelegate?
    
    
    // Her hücre için bir "yeniden kullanım kimliği" (reuse identifier) belirlemek best practice'dir.
    // Bu sayede ViewController'da string olarak yazma hatası yapmayız.
    static let identifier = "MoviesTableViewCell"
    
    // 1. Gelen filmleri tutmak için bir property ekliyoruz.
    // Dışarıdan erişilmemesi için 'private' yapıyoruz.
    private var movies: [Movie] = []
    
    // MARK: Collection View
    // Table View içinde collection view olucak
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: Initializer
    // Hücre kodla oluştrulduğunda bu init çalışır
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenWidth * 0.3, height: screenWidth * 0.45)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
    }
    
    // Bu fonksiyon ViewControllerdan film dizisini alıcak
    public func configure(with movies: [Movie]) {
        self.movies = movies
            
        // Veri değiştiği için, CollectionView'ın kendini yeniden çizmesi gerektiğini
        // ana thread'de söylüyoruz. Bu çok önemli!
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

}

extension MoviesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as! MoviesCollectionViewCell
        
        // O anki hücreye denk gelen filmi 'movies' dizisinden buluyoruz.
        let movie = movies[indexPath.row]
        
        // Şimdi bu tekil 'movie' objesini CollectionViewCell'e göndermemiz gerekiyor.
        // Tıpkı TableViewCell için yaptığımız gibi, CollectionViewCell'in de bir 'configure' metoduna ihtiyacı olacak.
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Tıklanan filmi 'movies' dizisinden bul.
        let selectedMovie = movies[indexPath.item]
        
        // Delegemize haber ver!
        // "Hey patron (HomeViewController), ben (self), şu filmin (selectedMovie) seçildiğini bildiriyorum."
        delegate?.moviesTableViewCell(self, didSelectMovie: selectedMovie)
        // Artık HomeViewController'ı Delegate Olarak Ayarla, bu haberi alıcak olan yer
    }
    
    
}
