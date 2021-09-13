//
//  NetworkService.swift
//  Photos
//
//  Created by Ivan Zakharov on 3/9/21.
//

import Foundation

class NetworkService {
private let token = "yTsBvTOVn8J6qUgrOtA3qmAQjureSk5r6NvtofZ8mtI"
    func getPhotos(page: Int,completion: @escaping (Result<[PhotosModel], Error>) -> Void) {
        let urlString = "https://api.unsplash.com/photos?page=\(page)&client_id=\(token)"
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    let photos = try JSONDecoder().decode([PhotosModel].self, from: data)
                    completion(.success(photos))
                }
                catch let jsonError {
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
}
