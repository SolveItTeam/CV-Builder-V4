import Foundation
import CoreData

final class HistoryItemRepository {
    
    static let shared = HistoryItemRepository()
    
    private init() {}
     
    func createHistoryItem(jobTitle: String, creationDate: Date, fullName: String, filePath: String?) {
        let context = DataController.shared.viewContext
        let newItem = HistoryItem(context: context)
        newItem.id = UUID()
        newItem.fullName = fullName
        newItem.jobTitle = jobTitle
        newItem.creationDate = creationDate
        newItem.filePath = filePath
         
        DataController.shared.save()
    }
     
    func fetchAll() -> [HistoryItem] {
        let context = DataController.shared.viewContext
        let request: NSFetchRequest<HistoryItem> = HistoryItem.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \HistoryItem.creationDate, ascending: false)
        ]
        
        do {
            let items = try context.fetch(request)
            return items
        } catch {
            print("\(error)")
            return []
        }
    }
     
    func delete(_ item: HistoryItem) {
        let context = DataController.shared.viewContext
        context.delete(item)
        DataController.shared.save()
    }
}
