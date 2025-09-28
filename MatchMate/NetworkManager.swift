//
//  NetworkManager.swift
//  MatchMate
//
//  Created by Mohammad Talha on 28/09/25.
//
import Foundation
import Combine

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchProfiles(count: Int = 10, completion: @escaping (Result<[RandomUser], Error>) -> Void) {
        let urlString = "https://randomuser.me/api/?results=\(count)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(decoded.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
