//
//  Persistence.swift
//  Devote-app
//
//  Created by TI Digital on 13/07/21.
//

import CoreData

struct PersistenceController {
    // MARK : - 1. Persistent controller
    static let shared = PersistenceController()

   // MARK : - 2. Persistent container
    let container: NSPersistentContainer

    // MARK : - 3. Initialization (load the persistent store)
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Devote_app") //Path to temporary storage
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK : - 4. Preview
    static var preview: PersistenceController = {
      let result = PersistenceController(inMemory: true) // switch to memory
      let viewContext = result.container.viewContext
      for _ in 0..<10 {
        let newItem = Item(context: viewContext) // sample data
        newItem.timestamp = Date()
      }
      do {
        try viewContext.save() //save data to memory
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
      return result
    }()
}
