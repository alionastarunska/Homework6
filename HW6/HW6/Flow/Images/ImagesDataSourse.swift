//
//  ImagesDataSourse.swift
//  HW6
//
//  Created by Aliona Starunska on 23.02.2021.
//

import UIKit
import CoreData

typealias TableViewCell = UITableViewCell & ReusableCell & ConfigurableCell

class ImagesDataSourse<Cell: ImagesTableViewCell>: NSObject, UITableViewDataSource {
    
    private var fetchResultController: NSFetchedResultsController<Photo>
    
    init(fetchResultController: NSFetchedResultsController<Photo>) {
        self.fetchResultController = fetchResultController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        cell.configure(with: fetchResultController.object(at: indexPath))
        return cell
    }
}
