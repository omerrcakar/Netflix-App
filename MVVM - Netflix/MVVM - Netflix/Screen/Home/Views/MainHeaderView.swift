//
//  MainHeaderView.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 16.10.2025.
//

import UIKit
import SDWebImage

class MainHeaderView: UIView {
    
    // MARK: UI Components
   
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // Resmi orantılı şekilde doldurur
        imageView.clipsToBounds = true // Resmin view dışına taşmasını engeller
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Gradient katmanını bir property olarak tanımlıyoruz ki her yerden erişebilelim.
    private let gradientLayer = CAGradientLayer()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Bu fonksiyon, view'ın (ve alt view'larının) frame'i her değiştiğinde çağrılır.
    // Döndürme, boyutlandırma gibi durumlarda gradient'ın da doğru boyutta kalmasını sağlar.
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds // Gradient'ın frame'ini burada güncelliyoruz!
    }
    
    private func createUI(){
        addSubview(imageView)
        
        // Gradient katmanını imageView'ın katmanının üzerine ekliyoruz.
        // Bu sayede gradient, resmin üzerinde görünür.
        layer.addSublayer(gradientLayer)
        
        // Sadece alttan değil, üstten de bir geçiş istersen diye daha gelişmiş bir gradient:
        // En üst: Arkaplan rengi -> Orta: Şeffaf -> En Alt: Arkaplan rengi
        gradientLayer.colors = [
            UIColor.systemBackground.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        
        // Bu 'locations' dizisi, renklerin nerede başlayıp biteceğini kontrol eder.
        // 0.0: en üst, 1.0: en alt.
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        
        NSLayoutConstraint.activate([
            // imageView'ı view'ın kendisine sabitliyoruz, safeArea'ya değil.
            // Bu, resmin ekranın en tepesine kadar uzanmasını sağlar.
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor) // Header view'ın tamamını kaplasın
        ])
    }
    
    // MARK: - Configuration
    // ViewController bu fonksiyonu çağırarak header'a hangi filmi göstereceğini söyleyecek.
    public func configure(with movie: Movie) {
        guard let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else {
            return
        }
        imageView.sd_setImage(with: url)
    }

}
