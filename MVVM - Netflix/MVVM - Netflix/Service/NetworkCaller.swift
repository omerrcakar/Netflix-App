//
//  NetworkCaller.swift
//  MVVM - Netflix
//
//  Created by ÖMER  on 16.10.2025.
//

import Foundation




final class NetworkCaller: NetworkServiceProtocol {
    
    func fetchData<T: Decodable>(_ endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void){
        
        
        let task = URLSession.shared.dataTask(with: endPoint.request()) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200, response.statusCode < 300 else {
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            do {
                let decoderData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoderData))
            }catch let error{
                print(error)
            }
        }
        task.resume()
        
    }
    
}
