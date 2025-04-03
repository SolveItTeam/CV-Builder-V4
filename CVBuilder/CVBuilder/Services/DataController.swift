import CoreData
import SwiftUI

class DataController: ObservableObject {
    static let shared = DataController()

    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "History")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Error loading persistent store: \(error)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("\(error)")
            }
        }
    }
}
