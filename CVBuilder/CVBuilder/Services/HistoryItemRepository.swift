import Foundation
import CoreData

final class HistoryItemRepository: ObservableObject {
    @Published var historyItems: [HistoryItem] = []
    @Published var coverLetterItems: [CoverLetterItem] = []
    static let shared = HistoryItemRepository()
    
    private init() {
        historyItems = fetchAllHistoryItems()
        coverLetterItems = fetchAllCoverLetterItems()
    }
     
    // MARK: - HistoryItem Methods
     
    func createHistoryItem(jobTitle: String, creationDate: Date, fullName: String, filePath: String?, cvConstructor: CVConstructor?) {
        let context = DataController.shared.viewContext
        let newItem = HistoryItem(context: context)
        newItem.id = UUID()
        newItem.fullName = fullName
        newItem.jobTitle = jobTitle
        newItem.creationDate = creationDate
        newItem.filePath = filePath
        
        if let cvConstructor = cvConstructor {
            do {
                let data = try JSONEncoder().encode(cvConstructor)
                newItem.cvConstructorData = data as NSData
            } catch {
                print("Error encoding CVConstructor: \(error)")
            }
        }
        
        DataController.shared.save()
        historyItems = fetchAllHistoryItems()
    }
     
    func fetchAllHistoryItems() -> [HistoryItem] {
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
     
    func deleteHistoryItem(_ item: HistoryItem) {
        let context = DataController.shared.viewContext
        context.delete(item)
        DataController.shared.save()
        
        historyItems = fetchAllHistoryItems()
    }
    
    func renameHistoryItem(_ item: HistoryItem, newJobTitle: String) {
        let context = DataController.shared.viewContext
        item.jobTitle = newJobTitle
        DataController.shared.save()
        historyItems = fetchAllHistoryItems()
    }
    
    // MARK: - CoverLetterItem Methods
    
    func createCoverLetterItem(jobTitle: String, creationDate: Date, fullName: String, filePath: String?, cvConstructor: CVConstructor?) {
        let context = DataController.shared.viewContext
        let newItem = CoverLetterItem(context: context)
        newItem.id = UUID()
        newItem.fullName = fullName
        newItem.jobTitle = jobTitle
        newItem.creationDate = creationDate
        newItem.filePath = filePath
        
        if let cvConstructor = cvConstructor {
            do {
                let data = try JSONEncoder().encode(cvConstructor)
                newItem.cvConstructorData = data as NSData
            } catch {
                print("Error encoding CVConstructor: \(error)")
            }
        }
        
        DataController.shared.save()
        coverLetterItems = fetchAllCoverLetterItems()
    }
    
    func fetchAllCoverLetterItems() -> [CoverLetterItem] {
        let context = DataController.shared.viewContext
        let request: NSFetchRequest<CoverLetterItem> = CoverLetterItem.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CoverLetterItem.creationDate, ascending: false)
        ]
        
        do {
            let items = try context.fetch(request)
            return items
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func deleteCoverLetterItem(_ item: CoverLetterItem) {
        let context = DataController.shared.viewContext
        context.delete(item)
        DataController.shared.save()
        
        coverLetterItems = fetchAllCoverLetterItems()
    }
    
    func renameCoverLetterItem(_ item: CoverLetterItem, newJobTitle: String) {
        let context = DataController.shared.viewContext
        item.jobTitle = newJobTitle
        DataController.shared.save()
        coverLetterItems = fetchAllCoverLetterItems()
    }
}
