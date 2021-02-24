//
//  Image.swift
//  HW6
//
//  Created by Aliona Starunska on 21.02.2021.
//

import Foundation

struct Image: Codable {

    let name: String
    let downloadUrl: String
    var data: Data?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case downloadUrl = "download_url"
    }
}
