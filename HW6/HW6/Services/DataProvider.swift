//
//  DataProvider.swift
//  HW6
//
//  Created by Aliona Starunska on 24.02.2021.
//

import CoreData

typealias PhotosHandler = ([Photo]) -> Void

class DataProvider {
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private(set) var persistentContainer: NSPersistentContainer
    private(set) var imagesService: ImagesService
    
    init(persistentContainer: NSPersistentContainer = CoreDataService.shared.persistentContainer,
         imagesService: ImagesService = DefaultImagesService()) {
        self.persistentContainer = persistentContainer
        self.imagesService = imagesService
    }
    
    func load() {
        imagesService.getImages { (images, error) in
            guard error == nil else { return }
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil

            let _ = self.syncImages(images: images ?? [], taskContext: taskContext)
        }
    }
    
    func loadData(for image: Photo) {
        guard let url = image.url else { return }
        imagesService.loadImage(from: url) { (data, error) in
            if let data = data {
                image.imageData = data
                try? image.managedObjectContext?.save()
            }
        }
    }
    
    private func syncImages(images: [Image], taskContext: NSManagedObjectContext) -> Bool {
        var successfull = false
        taskContext.performAndWait {
            var existingNames: [String] = []
            let allPhotosRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Photo.self))
            do {
                let allPhotos = try (taskContext.fetch(allPhotosRequest)) as? [Photo]
                existingNames = allPhotos?.compactMap({ $0.name }) ?? []
            } catch {
                print("Error: \(error)\nCould not fetch all existing photos.")
                return
            }
            var namesToDelete = [String]()
            var imagesToInsert = [Image]()
            let newNames = images.compactMap({ $0.name })
            for name in existingNames {
                if !newNames.contains(name) {
                    namesToDelete.append(name)
                }
            }
            for name in newNames {
                if !existingNames.contains(name), let image = images.first(where: { $0.name == name }) {
                    imagesToInsert.append(image)
                }
            }
            
            let matchingPhotosRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Photo.self))
            matchingPhotosRequest.predicate = NSPredicate(format: "name in %@", argumentArray: [namesToDelete])
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingPhotosRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch {
                print("Error: \(error)\nCould not batch delete existing records.")
                return
            }
                        
            for image in imagesToInsert {
                let photo = NSEntityDescription.insertNewObject(forEntityName: String(describing: Photo.self), into: taskContext) as? Photo
                photo?.name = image.name
                photo?.url = image.downloadUrl
            }
            
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                }
                taskContext.reset()
            }
            successfull = true
        }
        return successfull
    }
}
