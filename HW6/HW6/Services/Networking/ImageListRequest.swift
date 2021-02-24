//
//  ImageListRequest.swift
//  HW6
//
//  Created by Aliona Starunska on 24.02.2021.
//

import Foundation

struct ImageListRequest {
    private var token: String
    
    init(token: String) {
        self.token = token
    }
}

extension ImageListRequest: APIRequest {
    
    var url: String { "https://api.github.com/repos/alionastarunska/HW6_photos/contents" }
    var parameters: [String: String] { [:] }
    var headers: [String: Any] { return ["Authorization": "token " + token,
                                         "Accept": "application/vnd.github.v3+json",
                                         "User-Agent": "alionastarunska"]
    
    }
}
