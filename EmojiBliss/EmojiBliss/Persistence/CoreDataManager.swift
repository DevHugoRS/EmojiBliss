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
                fatalError("Erro Loading Core Data: \(error.localizedDescription)")
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
                print("Erro Loading Core Data: \(error.localizedDescription)")
            }
        }
    } //: FUNC SAVE CONDITIONS
    
//    MARK: EMOJI FUNCTIONS
    func saveEmojis(_ emojis: [Emoji]) {
        clearEmojis()
        
        for emoji in emojis {
            let entity = EmojiEntity(context: conditions)
            entity.name = emoji.name
            entity.url = emoji.url
        }
        
        saveCondition()
        
    } //: FUNC SAVE EMOJIS
    
    func searchEmojis() -> [Emoji] {
        let requisition: NSFetchRequest<EmojiEntity> = EmojiEntity.fetchRequest()
        do {
            return try conditions.fetch(requisition).map {
                Emoji(name: $0.name ?? "", url: $0.url ?? "")
            }
        } catch {
            print("Erro Searching for Emojis: \(error.localizedDescription)")
            return []
        }
    }
    
    func clearEmojis() {
        let requisition: NSFetchRequest<NSFetchRequestResult> = EmojiEntity.fetchRequest()
        let deleteRequisition = NSBatchDeleteRequest(fetchRequest: requisition)
        do {
            try conditions.execute(deleteRequisition)
        } catch {
            print("Erro Clearing emojis: \(error.localizedDescription)")
        }
    }
} //: CLASS COREDATA MANAGER
