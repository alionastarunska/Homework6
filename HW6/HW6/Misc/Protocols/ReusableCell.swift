//
//  AppDelegate.swift
//  Project_1_Starunska_Aliona
//
//  Created by Aliona Starunska on 18.01.2021.
//

import UIKit

protocol ReusableCell {
    
    static var reuseIdentifier: String { get }
    static var cellNib: UINib { get }
}

extension ReusableCell {
    
    static var reuseIdentifier: String { return String(describing: self) }
    static var cellNib: UINib { return UINib(nibName: String(describing: self), bundle: nil) }
}

extension UITableView {
    func register<T: ReusableCell>(_ type: T.Type) {
        register(type.cellNib, forCellReuseIdentifier: type.reuseIdentifier)
    }
}
