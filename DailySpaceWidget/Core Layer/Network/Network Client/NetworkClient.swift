//
//  NetworkClient.swift
//  MVVM-Demo
//
//  Created by Derrick Park on 2020-05-29.
//  Copyright © 2020 CICCC. All rights reserved.
//

import RxSwift
import RxCocoa

final class NetworkClient {
  typealias Parameters = [String: String]
  var baseURL: URL?
  
  init(baseUrlString: String) {
    self.baseURL = URL(string: baseUrlString)
  }
}


// MARK: - For App

extension NetworkClient {
  
  func getArray<T: Decodable>(
    _ type: [T].Type,
    _ urlString: String,
    parameters: Parameters = [:],
    printURL: Bool = false
  ) -> Observable<([T]?, Error?)> {
    
    return Observable.create { [unowned self] observer in
      guard let url = URL(string: urlString, relativeTo: self.baseURL) else {
        observer.onNext((nil, NetworkError.invalidURL))
        return Disposables.create()
      }
      guard var urlComponents = URLComponents(string: url.absoluteString) else {
        observer.onNext((nil, NetworkError.invalidURL))
        return Disposables.create()
      }
      
      if !parameters.isEmpty {
        urlComponents.queryItems = parameters.compactMap{
          URLQueryItem(name: $0.key, value: $0.value)
        }
      }
      
      var urlRequest = URLRequest(url: urlComponents.url!)
      urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
      if printURL { print(urlRequest.url!.absoluteString) }
      
      let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        guard let data = data,
              let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                if let error = error {
                  observer.onNext((nil, error))
                } else {
                  observer.onNext((nil, NetworkError.unknown))
                }
                return
              }
        
        do {
          let model = try JSONDecoder().decode(type, from: data)
          observer.onNext((model, nil))
        } catch {
          observer.onNext((nil, error))
        }
      }
      
      task.resume()
      
      return Disposables.create {
        task.cancel()
      }
    }
  }
}


// MARK: - For Sync for Widget

extension NetworkClient {
  
  func getArraySync<T: Decodable>(
    _ type: [T].Type,
    _ urlString: String,
    parameters: Parameters = [:],
    printURL: Bool = false
  ) -> ([T]?, Error?) {
    
    guard let url = URL(string: urlString, relativeTo: self.baseURL) else {
      return (nil, NetworkError.invalidURL)
    }
    
    guard var urlComponents = URLComponents(string: url.absoluteString) else {
      return (nil, NetworkError.invalidURL)
    }
    
    if !parameters.isEmpty {
      urlComponents.queryItems = parameters.compactMap {
        URLQueryItem(name: $0.key, value: $0.value)
      }
    }

    let data = try? Data(contentsOf: urlComponents.url!)
    
    guard let data = data else { return (nil, NetworkError.unknown) }
    
    do {
      let model = try JSONDecoder().decode(type, from: data)
      return (model, nil)
    } catch {
      return (nil, error)
    }
  }
}
