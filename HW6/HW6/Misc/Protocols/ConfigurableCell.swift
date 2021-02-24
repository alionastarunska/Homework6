//
//  ConfigurableCell.swift
//  Homework_4
//
//  Created by Aliona Starunska on 25.01.2021.
//

import Foundation

protocol ConfigurableCell {
    associatedtype Item
    
    func configure(with item: Item)
}
