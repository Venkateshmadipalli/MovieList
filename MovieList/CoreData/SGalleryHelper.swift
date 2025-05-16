//
//  SGalleryHelper.swift
//  Scoopro-Reporter
//
//  Created by Apple on 20/09/23.
//


import UIKit
import Foundation
import CoreData

class SGalleryHelper: NSObject {
    static let shared = SGalleryHelper()
    var allFiles: [NSManagedObject] = []
    private override init() { }
    
    func getAllDataFromScoops() -> [GalleryDataModel] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SGalleryInfo")
        do {
            allFiles = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        var galleryList = [GalleryDataModel]()
        for obj in allFiles {
            let tmp: GalleryDataModel = GalleryDataModel()
            galleryList.append(tmp.initWithData(galleryList: obj))
        }
        return galleryList.reversed()
    }
    func saveData(galleryInfo: [String: Any])  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "SGalleryInfo",
                                                in: managedContext)!
        
        let newGallery = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
        
        newGallery.setValuesForKeys(galleryInfo)
        do {
            try managedContext.save()
            print("saved")
        } catch {
            print("Failed saving")
        }
    }
    
}
