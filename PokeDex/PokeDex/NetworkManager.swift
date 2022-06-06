//
//  NetworkManager.swift
//  PokeDex
//
//  Created by Cristina C on 6/2/22.
//

import Foundation

enum NetworkManagerError: Error {
  case badResponse(URLResponse?)
  case badData
  case badLocalUrl
}

struct Response: Codable {
    let pokemons: [Pokemon]
}

class NetworkManager {
  
  static var shared = NetworkManager()
  
  private var images = NSCache<NSString, NSData>()
  
  let session: URLSession
  
  init() {
      session = URLSession(configuration: .default)
  }
  

  // TODO: change name to getPokemons()
    func Pokemons(id: Int, completion: @escaping (Pokemon?, Error?) -> (Void)) {
      
      let req = URL(string: "https://pokeapi.co/api/v2/pokemon/" + String(id))!

        // url = "https://pokeapi.co/api/v2/pokemon" 
        // process the response in Result
        // imageUrl =
    
    
    let task = session.dataTask(with: req) { data, response, error in
      if let error = error {
        completion(nil, error)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        completion(nil, NetworkManagerError.badResponse(response))
        return
      }
      
      guard let data = data else {
        completion(nil, NetworkManagerError.badData)
        return
      }
      
      do {
        let response = try JSONDecoder().decode(Pokemon.self, from: data)
          completion(response, nil)
          
         // print(response)
      } catch let error {
        completion(nil, error)
      }
    }
    
    task.resume()
  }
  
    // TODO: - change name to downloadImage(with: URL)
  private func download(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
//    if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
//      //print("using cached images")
//      completion(imageData as Data, nil)
//      return
//    }
    
    let task = session.downloadTask(with: imageURL) { localUrl, response, error in
      if let error = error {
        completion(nil, error)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        completion(nil, NetworkManagerError.badResponse(response))
        return
      }
      
      guard let localUrl = localUrl else {
        completion(nil, NetworkManagerError.badLocalUrl)
        return
      }
      
      do {
        let data = try Data(contentsOf: localUrl)
        self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
        completion(data, nil)
      } catch let error {
        completion(nil, error)
      }
    }
    
    task.resume()
  }
  
    // TODO: - change name to getImage(ofType: Phototype)
    // When I call this I also save the image to a struct
    func image(pokemon: Pokemon, type: PhotoType, completion: @escaping (Data?, Error?) -> (Void)) {
        
        switch type {
            
        case .front:
            if let safeString = pokemon.sprites.front_default {
                let url = URL(string: safeString)!
                self.download(imageURL: url, completion: completion)
            }
        
        case .back:
            if let safeString = pokemon.sprites.back_default {
                let url = URL(string: safeString)!
                self.download(imageURL: url, completion: completion)
            }
        
        }
//
//        if let safeString = pokemon.sprites.front_default {
//            let url = URL(string: safeString)!
//            download(imageURL: url, completion: completion)
//        }
  }
  
    enum PhotoType: String {
        case front = "front_default"
        case back = "back_default"
//        case shiny = "front_shiny"
//        case back_shiny = "back_shiny"
    }
  
}
