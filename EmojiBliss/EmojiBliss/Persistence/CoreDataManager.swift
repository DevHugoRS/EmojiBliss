//
//  CoreDataManager.swift
//  EmojiBliss
//
//  Created by Hugo Rodrigues on 11/08/25.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "EmojiBliss")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Erro Loanding Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    var conditions: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveCondition() {
        if conditions.hasChanges {
            do {
                try conditions.save()
            } catch {
                print("Erro Loanding Core Data: \(error.localizedDescription)")
            }
        }
    } //: FUNC SAVE CONDITIONS
} //: CLASS COREDATA MANAGER
