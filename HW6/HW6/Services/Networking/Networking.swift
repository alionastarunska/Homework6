//
//  Networking.swift
//  HW6
//
//  Created by Aliona Starunska on 21.02.2021.
//

import Foundation

protocol Networking {
    func execute<Response: Codable>(request: APIRequest, completion: @escaping (Response?, Error?) -> ())
}

/// https://stackoverflow.com/questions/42944556/how-can-i-append-dictionary-to-url-as-parameters/42945384
class DefaultNetworkService: Networking{
    func execute<Response: Codable>(request: APIRequest, completion: @escaping (Response?, Error?) -> ()) {
        guard let url = URL(string: request.url) else {
            completion(nil, NSError.badRequest)
            return
        }
        let queryItems = request.parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        guard let requestUrl = urlComponents?.url else {
            completion(nil, NSError.badRequest)
            return
        }
        let task = URLRequest(url: requestUrl)
        URLSession.shared.dataTask(with: task) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let result = try JSONDecoder().decode(Response.self, from: data)
                completion(result, error)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}

// MARK: - Private

fileprivate extension NSError {
    static var badRequest: NSError { return NSError(domain: "Bad Request", code: 400, userInfo: nil) }
}
