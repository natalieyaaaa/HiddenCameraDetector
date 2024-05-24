//
//  CoreDataManager.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 23.05.2024.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataManager: ObservableObject {
    
    static var shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Devices")
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {print("Error of init CoreDataService: \(error!.localizedDescription)"); return}
        }
    }
    
    func updateEntity() {
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            persistentContainer.viewContext.rollback()
            print("Error updating CoreData entity: \(error.localizedDescription)")
        }
    }
    
    func saveEntity(name: String, ipAdress: String, id: UUID, date: String, connectionType: String, isSuspicious: Bool) {
        let entity = Device(context: persistentContainer.viewContext)
        entity.name = name
        entity.ipAdress = ipAdress
        entity.id = id
        entity.date = date
        entity.connectionType = connectionType
        entity.isSuspicious = isSuspicious
        
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            persistentContainer.viewContext.rollback()
            print("Error saving CoreData entity: \(error.localizedDescription)")
        }
    }
        
        func deleteEntity(entity: Device) {
            persistentContainer.viewContext.delete(entity)
            updateEntity()
            print("entity deleted")
        }
        
        func allEntities() -> [Device] {
            let fetchRequest: NSFetchRequest<Device> = Device.fetchRequest()
            do {
                return try persistentContainer.viewContext.fetch(fetchRequest)
            } catch let error {
                print("Error getting all CoreData entities: \(error.localizedDescription)")
                return []
            }
        }
    
    func deleteAllEntities() {
         let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Device.fetchRequest()
         let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

         do {
             try persistentContainer.viewContext.execute(batchDeleteRequest)
             try persistentContainer.viewContext.save()
             print("All entities deleted")
         } catch let error {
             persistentContainer.viewContext.rollback()
             print("Error deleting all entities: \(error.localizedDescription)")
         }
     }
    }
