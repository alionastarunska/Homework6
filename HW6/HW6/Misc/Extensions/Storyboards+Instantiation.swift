//
//  Storyboards+Instantiation.swift
//  task_4
//
//  Created by Aliona Starunska on 25.12.2020.
//

import UIKit

extension UIStoryboard {
    func get<T: UIViewController>() -> T? {
        return instantiateViewController(identifier: String(describing: T.self)) as? T
    }
}
