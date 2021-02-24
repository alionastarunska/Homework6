//
//  ImagesViewController.swift
//  HW6
//
//  Created by Aliona Starunska on 20.02.2021.
//

import UIKit
import CoreData

class ImagesViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet private weak var imagesTableView: UITableView!
    @IBOutlet private weak var loguotButton: UIButton!
    private var datasourse: ImagesDataSourse<ImagesTableViewCell>?
    private var imagesService: ImagesService?
    private var dataProvider: DataProvider = DataProvider()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Photo> = {
        let fetchRequest = NSFetchRequest<Photo>(entityName: String(describing: Photo.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: dataProvider.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        dataProvider.load()
    }
    
    @IBAction private func logoutButtonAction(_ sender: UIButton) {
        logout()
    }
    
    private func setupTableView() {
        imagesTableView.register(ImagesTableViewCell.self)
        datasourse = ImagesDataSourse<ImagesTableViewCell>(fetchResultController: fetchedResultsController)
        imagesTableView.dataSource = datasourse
        imagesTableView.delegate = self
    }
    
    private func logout() {
        guard let viewController = UIStoryboard(name: String(describing: LoginViewController.self),
                                                bundle: Bundle.main).instantiateInitialViewController() as? LoginViewController else {
            return
        }
        DefaultKeychainService().deleteToken()
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
}

extension ImagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if fetchedResultsController.object(at: indexPath).imageData == nil {
            dataProvider.loadData(for: fetchedResultsController.object(at: indexPath))
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        imagesTableView.reloadData()
    }
}
