//
//  AlamofireNetworkManager.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 18.10.2025.
//

import Foundation
import Alamofire

// Soyutlama - Abstraction
// bu servisimizi extraction yapmamız gerekiyor ( soyutlama ). Bu yapıyı Alamofire'a döünüştüreceğiz diyelim bunun için bir protocol ile soyutlayacağız
// Soyutlama için, bir gün Alamofire'a dönüştürmek veya farklı işlemler için soyutlayacağız
/*
 Bu protokol, bir "sözleşme" veya bir "yetki belgesi" gibidir. Şöyle der: "Benimle çalışmak isteyen herhangi bir class, fetchData adında bir fonksiyonu olmak zorundadır. Bu fonksiyon, bir EndPoint almalı ve işi bitince geriye Result tipinde bir sonuç dönmelidir. Bu işi nasıl yaptığı (URLSession ile mi, Alamofire ile mi, yoksa başka bir kütüphane ile mi) beni ilgilendirmez."
 */

/*
 Değiştirilebilirlik: Bugün URLSession kullanan NetworkCaller class'ını kullanırız. Yarın patronun gelip "Artık tüm projede Alamofire kullanacağız!" dediğinde, NetworkCaller'ı çöpe atıp yerine AlamofireCaller diye yeni bir class yazarız. ViewModel gibi bu servisi kullanan üst katmanların haberi bile olmaz, çünkü onlar sadece sözleşmeye (NetworkServiceProtocol) güvenirler, class'ın kendisine değil. Kodun geri kalanında tek bir satırı bile değiştirmen gerekmez.
 */
/*
 Test Edilebilirlik: ViewModel'ını test etmek istediğinde, gerçek bir API isteği atmak istemezsin. Bu hem yavaş olur hem de internet bağlantısına bağımlıdır. Bunun yerine, sahte veriler dönen bir MockNetworkCaller class'ı yazarsın. Bu mock class da aynı protokolü uyguladığı için, ViewModel'a "Al, test boyunca bu sahte servis ile çalış" diyebilirsin. Buna Bağımlılık Enjeksiyonu (Dependency Injection) diyoruz ve modern iOS geliştirmede hayati öneme sahiptir.
 */
protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(_ endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void)
}

final class AlamofireNetworkManager: NetworkServiceProtocol {
    
    func fetchData<T:Decodable>(_ endPoint: EndPoint, completion: @escaping (Result<T, any Error>) -> Void) {
        // validate() fonksiyonu, status code'un 200-299 arasında olduğunu otomatik olarak kontrol eder.
        // Eğer değilse, .failure bloğunu tetikler. Manuel kontrol yapmamıza gerek kalmaz.
        // Gelen cevabı belirttiğimiz T tipine (Decodable olmalı) otomatik olarak parse eder.
        // JSONDecoder işlemini kendi içinde yapar.
        AF.request(endPoint.request())
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case.success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
