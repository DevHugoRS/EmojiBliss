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
    
//    MARK: - EMOJI FUNCTIONS
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

// MARK: - AVATAR FUNCTIONS

extension CoreDataManager {
    func saveAvatar(_ avatar: UserAvatar) {
//        let existing = searchAvatarById(avatar.id)
//        if existing != nil { return }
        let requisition: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        requisition.predicate = NSPredicate(format: "id == %d", avatar.id)
        requisition.fetchLimit = 1
        
        let entity = (try? conditions.fetch(requisition).first) ?? AvatarEntity(context: conditions)
        entity.id = Int64(avatar.id)
        entity.login = avatar.login
        entity.avatarURL = avatar.avatarUrl
        saveCondition()
    } //: FUNC SAVE AVATAR
    
    func searchAvatar() -> [UserAvatar] {
        let requisition: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        do {
            return try conditions.fetch(requisition).map {
                UserAvatar(id: Int($0.id),
                           login: $0.login ?? "",
                           avatarUrl: $0.avatarURL ?? "")
            }
        } catch {
            print("Error fetching Avatars: \(error.localizedDescription)")
        }
        return []
    } //: FUNC SEARCH AVATAR
    
    func searchAvatarById(_ id: Int) -> UserAvatar? {
        let requisition: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        requisition.predicate = NSPredicate(format: "id == %d", id)
        requisition.fetchLimit = 1
        do {
            if let avatarEntity = try conditions.fetch(requisition).first {
                return UserAvatar(id: Int(avatarEntity.id), login: avatarEntity.login ?? "", avatarUrl: avatarEntity.avatarURL ?? "")
            }
        } catch {
            print("Error fetching Avatars: \(error.localizedDescription)")
        }
        return nil
    } //: FUNC SEARCH AVATAR BY ID
    
    func deleteAvatar(_ avatar: UserAvatar) {
        let requisition: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        requisition.predicate = NSPredicate(format: "id == %d", avatar.id)
        do {
            if let entity = try conditions.fetch(requisition).first {
                conditions.delete(entity)
                saveCondition()
            }
        } catch {
            print("Error deleting Avatar: \(error.localizedDescription)")
        }
    } //: FUNC DELETE AVATAR
}
