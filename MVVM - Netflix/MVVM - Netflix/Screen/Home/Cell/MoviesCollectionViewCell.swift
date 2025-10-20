//
//  MoviesCollectionViewCell.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 15.10.2025.
//



import UIKit
// Filmin posterini internetten çekip göstermek için bu kütüphaneyi projemize ekleyeceğiz.
// SDWebImage, hem asenkron indirme hem de cache'leme (önbelleğe alma) işini bizim için yapar.
// Bu, senior'ların kullandığı standart bir yöntemdir.
import SDWebImage

class MoviesCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "MoviesCollectionViewCell"
    
    // 1. Film afişini gösterecek olan image view'ı ekliyoruz.
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // Resmi orantılı şekilde doldur
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupConstraints() {
        // Image view'ı hücrenin tamamını kaplayacak şekilde ayarlıyoruz.
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // 2. İşte bu hücrenin 'configure' metodu. Tek bir 'Movie' objesi alıyor.
    public func configure(with movie: Movie) {
        // API'den gelen 'posterPath' sadece dosya adını içerir.
        // Tam URL'i bizim oluşturmamız gerekiyor.
        guard let posterPath = movie.posterPath else {
            // Eğer poster yoksa, bir placeholder resim gösterebiliriz.
            posterImageView.image = UIImage(systemName: "photo")
            return
        }
        
        guard let fullURL = URL(string: ConstantsURL.baseImageURL + posterPath) else { return }
        
        // SDWebImage'in sihri burada. Tek satırla resmi indirip, cache'leyip, image view'a set ediyoruz.
        posterImageView.sd_setImage(with: fullURL)
    }
}
