//
//  CoreDataManager.swift
//  CD
//
//  Created by Vladislav Simovic on 11/5/16.
//  Copyright © 2016 CustomDeal. All rights reserved.
//

import CoreData

class CoreDataManager : NSPersistentContainer {
    
    static let sharedInstance = CoreDataManager(name:"CD")
    
    // MARK: - Initialization
    
    public override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
        
        // load persistent store
        self.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    public convenience init(name: String) {
        let modelURL = Bundle.main.url(forResource: name, withExtension: "momd")!
        self.init(name: name, managedObjectModel: NSManagedObjectModel(contentsOf: modelURL)!)
    }
    
    
    // MARK: - Helper methods
    
    func createScratchpadContext(onMainThread: Bool) -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(concurrencyType: onMainThread ? .mainQueueConcurrencyType : .privateQueueConcurrencyType)
        childContext.parent = self.viewContext
        return childContext
    }
    
    func save(scratchpadContext:NSManagedObjectContext) -> Void {
        if scratchpadContext.hasChanges {
            do {
                try scratchpadContext.save()
            } catch {
                
                // return some error
                return
            }
        }
        
        // save main context
        self.saveContext()
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = self.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
