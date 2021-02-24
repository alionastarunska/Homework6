//
//  RequestProtocol.swift
//  Homework_4
//
//  Created by Aliona Starunska on 23.01.2021.
//

import Foundation

protocol APIRequest {
    var url: String { get }
    var parameters: [String: String] { get }
}
