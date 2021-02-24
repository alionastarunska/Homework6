//
//  ImagesService.swift
//  HW6
//
//  Created by Aliona Starunska on 23.02.2021.
//

import Foundation

protocol ImagesService {
    func getImages(completion: @escaping (([Image]?, Error?) -> Void))
    func loadImage(from link: String, completion: @escaping (Data?, Error?) -> Void)
}

class DefaultImagesService: ImagesService {
 
    private let keychainService: KeychainService
    private let networkService: Networking
    private var loadingInProgress = Set<String>()
    
    init(keychainService: KeychainService = DefaultKeychainService(), networkService: Networking = DefaultNetworkService()) {
        self.keychainService = keychainService
        self.networkService = networkService
    }
    
    func getImages(completion: @escaping (([Image]?, Error?) -> Void)) {
        guard let token = keychainService.fetchToken() else { return }
        let request = ImageListRequest(token: token)
        networkService.execute(request: request) { (response: [Image]?, error) in
            completion(response, error)
        }
    }
    
    func loadImage(from link: String, completion: @escaping (Data?, Error?) -> Void) {
        guard !loadingInProgress.contains(link) else { return }
        loadingInProgress.insert(link)
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            completion(data, error)
            self?.loadingInProgress.remove(link)
        }.resume()
    }
}
