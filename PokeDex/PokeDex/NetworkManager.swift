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

fileprivate struct APIResponse: Codable {
    let sprites: Sprites
}

class NetworkManager {
  
  static var shared = NetworkManager()
  
  private var images = NSCache<NSString, NSData>()
  
  let session: URLSession
  
  init() {
      session = URLSession(configuration: .default)
  }
  

  
  func Pokemons(completion: @escaping (String?, Error?) -> (Void)) {
      let req = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    
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
        let response = try JSONDecoder().decode(APIResponse.self, from: data)
          completion(response.sprites.front_default!, nil)
          print(response)
      } catch let error {
        completion(nil, error)
      }
    }
    
    task.resume()
  }
  
  private func download(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
    if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
      print("using cached images")
      completion(imageData as Data, nil)
      return
    }
    
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
  
  func image(pokemon: Pokemon, completion: @escaping (Data?, Error?) -> (Void)) {
      if let safeString = pokemon.sprites.front_default {
          let url = URL(string: safeString)!
          download(imageURL: url, completion: completion)
      }
  }
  
  
  
}
