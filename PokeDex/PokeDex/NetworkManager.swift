//
//  NetworkManager.swift
//  PokeDex
//
//  Created by Cristina C on 6/2/22.
//

import Foundation

class NetworkManager {
    
    // MARK: - Singleton
    static var shared = NetworkManager()
    
    //
    let session: URLSession
      
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    //
    var urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"

        func request(completion: @escaping ([Pokemon]?, Error?) -> (Void)) {
        let resource = "1.png"
        self.urlString += resource
        let url = URL(string: urlString)!
        
        // MARK: - Treat the request
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Request error. Received: \(error)")
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print("Request error, no 200 status. Received: \(response.statusCode)")
            } else if let data = data {
                
                // MARK: - Have data
                var result: Response?
                do {
                    result = try JSONDecoder().decode(Response.self, from: data)
                } catch {
                    print("failed to convert JSON \(error.localizedDescription)")
                }
                
                // json = our decoded data
                guard let json = result else {
                    return
                }
                print(json.status)
                
            }
        }
        
    }
    
}

struct Response: Codable {
    let status: String
    let products: [Pokemon]
}
