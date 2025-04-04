import SwiftUI
import Combine
import CoreData

final class CoverLetterViewModel: ObservableObject {
    @Published var showProIcon: Bool
    @Published var repository: HistoryItemRepository = .shared
    @Published var coverLetterItems: [CoverLetterItem] = []
    @Published var historyItems: [HistoryItem] = []
    @Published var selectedCV: HistoryItem?
    @Published var selectedCoverLetter: CoverLetterItem?
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var summary: String = ""
    @Published var jobTitle: String = ""
    @Published var site: String = ""
    @Published var coverLetterCompanyName: String = ""
    @Published var isCloseResumeAlert: Bool = false
    
    
    private let coordinator: Coordinator
    private var cancellables = Set<AnyCancellable>()
    private let purchaseManager: PurchaseManager = .shared
    
    var couldGoNext: Bool {
        return !firstname.isEmpty && !lastname.isEmpty && !email.isEmpty && !phone.isEmpty && !summary.isEmpty && !jobTitle.isEmpty && !site.isEmpty && !coverLetterCompanyName.isEmpty
    }
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        
        showProIcon = !purchaseManager.isPremium
        
        purchaseManager.$isPremium
            .map { !$0 }
            .assign(to: &$showProIcon)
        
        repository.$coverLetterItems
            .assign(to: \.coverLetterItems, on: self)
            .store(in: &cancellables)
        
        repository.$historyItems
            .assign(to: \.historyItems, on: self)
            .store(in: &cancellables)
    }
    
    func prefill() {
        if let selectedCV,
           let nsdata = selectedCV.cvConstructorData as? NSData {
            let data = Data(referencing: nsdata)
            do {
                let cvConstructor = try JSONDecoder().decode(CVConstructor.self, from: data)
                firstname = cvConstructor.firstname
                lastname = cvConstructor.lastname
                email = cvConstructor.email
                phone = cvConstructor.phone
                summary = cvConstructor.summary
                jobTitle = cvConstructor.jobTitle
                site = cvConstructor.site
                coverLetterCompanyName = cvConstructor.coverLetterCompanyName ?? ""
            } catch {
                print("Error decoding CVConstructor: \(error)")
            }
        } else if let selectedCoverLetter,
                  let nsdata = selectedCoverLetter.cvConstructorData as? NSData {
            let data = Data(referencing: nsdata)
            do {
                let cvConstructor = try JSONDecoder().decode(CVConstructor.self, from: data)
                firstname = cvConstructor.firstname
                lastname = cvConstructor.lastname
                email = cvConstructor.email
                phone = cvConstructor.phone
                summary = cvConstructor.summary
                jobTitle = cvConstructor.jobTitle
                site = cvConstructor.site
                coverLetterCompanyName = cvConstructor.coverLetterCompanyName ?? ""
            } catch {
                print("Error decoding CVConstructor: \(error)")
            }
        }
    }
    
    func showResult() {
        if let selectedCV = selectedCV,
           let nsdata = selectedCV.cvConstructorData as? NSData {
            let data = Data(referencing: nsdata)
            do {
                var cvConstructor = try JSONDecoder().decode(CVConstructor.self, from: data)
                cvConstructor.coverLetterCompanyName = coverLetterCompanyName
                coordinator.showResultFromCover(cvConstructor: cvConstructor)
            } catch {
                print(error.localizedDescription)
            }
        } else if let selectedCoverLetter ,  let nsdata = selectedCoverLetter.cvConstructorData as? NSData {
            let data = Data(referencing: nsdata)
            do {
                
                var cvConstructor = try JSONDecoder().decode(CVConstructor.self, from: data)
                cvConstructor.coverLetterCompanyName = coverLetterCompanyName
                coordinator.showResultFromCover(cvConstructor: cvConstructor)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveCoverLetterChanges() {
        let id: UUID
        if let selectedCV = selectedCV, let modelID = selectedCV.id {
            id = modelID 
            let context = DataController.shared.viewContext
            let request: NSFetchRequest<CoverLetterItem> = CoverLetterItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                if let item = try context.fetch(request).first {
                    if let nsdata = item.cvConstructorData as? NSData {
                        let data = Data(referencing: nsdata)
                        var cvConstructor = try JSONDecoder().decode(CVConstructor.self, from: data)
                        
                        cvConstructor.firstname = firstname
                        cvConstructor.lastname = lastname
                        cvConstructor.email = email
                        cvConstructor.phone = phone
                        cvConstructor.summary = summary
                        cvConstructor.jobTitle = jobTitle
                        cvConstructor.site = site
                        cvConstructor.coverLetterCompanyName = coverLetterCompanyName
                        let updatedData = try JSONEncoder().encode(cvConstructor)
                        item.cvConstructorData = updatedData as NSData
                    } else {
                        let cvConstructor = CVConstructor(
                            firstname: firstname,
                            lastname: lastname,
                            email: email,
                            phone: phone,
                            summary: summary,
                            jobTitle: jobTitle,
                            site: site,
                            location: "",
                            workExperience: [],
                            education: [],
                            skills: [],
                            languages: [],
                            profileImagePath: nil,
                            coverLetterCompanyName: coverLetterCompanyName
                        )
                        let updatedData = try JSONEncoder().encode(cvConstructor)
                        item.cvConstructorData = updatedData as NSData
                    }
                    
                    try context.save()
                    print("Cover letter changes updated successfully.")
                } else {
                    let newItem = CoverLetterItem(context: context)
                    newItem.id = id
                    newItem.fullName = selectedCV.fullName
                    newItem.jobTitle = selectedCV.jobTitle
                    newItem.creationDate = selectedCV.creationDate
                    newItem.filePath = selectedCV.filePath
                    
                    let cvConstructor = CVConstructor(
                        firstname: firstname,
                        lastname: lastname,
                        email: email,
                        phone: phone,
                        summary: summary,
                        jobTitle: jobTitle,
                        site: site,
                        location: "",
                        workExperience: [],
                        education: [],
                        skills: [],
                        languages: [],
                        profileImagePath: nil,
                        coverLetterCompanyName: coverLetterCompanyName
                    )
                    let encodedData = try JSONEncoder().encode(cvConstructor)
                    newItem.cvConstructorData = encodedData as NSData
                    
                    try context.save()
                    print("New CoverLetterItem created and saved successfully.")
                }
            } catch {
                print("Error updating CoverLetterItem: \(error)")
            }
            
        } else if let selectedCoverLetter, let modelID = selectedCoverLetter.id {
            id = modelID
            
            
            let context = DataController.shared.viewContext
            let request: NSFetchRequest<CoverLetterItem> = CoverLetterItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                if let item = try context.fetch(request).first {
                    if let nsdata = item.cvConstructorData as? NSData {
                        let data = Data(referencing: nsdata)
                        var cvConstructor = try JSONDecoder().decode(CVConstructor.self, from: data)
                        
                        cvConstructor.firstname = firstname
                        cvConstructor.lastname = lastname
                        cvConstructor.email = email
                        cvConstructor.phone = phone
                        cvConstructor.summary = summary
                        cvConstructor.jobTitle = jobTitle
                        cvConstructor.site = site
                        cvConstructor.coverLetterCompanyName = coverLetterCompanyName
                        let updatedData = try JSONEncoder().encode(cvConstructor)
                        item.cvConstructorData = updatedData as NSData
                    } else {
                        let cvConstructor = CVConstructor(
                            firstname: firstname,
                            lastname: lastname,
                            email: email,
                            phone: phone,
                            summary: summary,
                            jobTitle: jobTitle,
                            site: site,
                            location: "",
                            workExperience: [],
                            education: [],
                            skills: [],
                            languages: [],
                            profileImagePath: nil,
                            coverLetterCompanyName: coverLetterCompanyName
                        )
                        let updatedData = try JSONEncoder().encode(cvConstructor)
                        item.cvConstructorData = updatedData as NSData
                    }
                    
                    try context.save()
                    print("Cover letter changes updated successfully.")
                } else {
                    let newItem = CoverLetterItem(context: context)
                    newItem.id = id
                    newItem.fullName = selectedCoverLetter.fullName
                    newItem.jobTitle = selectedCoverLetter.jobTitle
                    newItem.creationDate = selectedCoverLetter.creationDate
                    newItem.filePath = selectedCoverLetter.filePath
                    
                    let cvConstructor = CVConstructor(
                        firstname: firstname,
                        lastname: lastname,
                        email: email,
                        phone: phone,
                        summary: summary,
                        jobTitle: jobTitle,
                        site: site,
                        location: "",
                        workExperience: [],
                        education: [],
                        skills: [],
                        languages: [],
                        profileImagePath: nil,
                        coverLetterCompanyName: coverLetterCompanyName
                    )
                    let encodedData = try JSONEncoder().encode(cvConstructor)
                    newItem.cvConstructorData = encodedData as NSData
                    
                    try context.save()
                    print("New CoverLetterItem created and saved successfully.")
                }
            } catch {
                print("Error updating CoverLetterItem: \(error)")
            }
        }
    }
    
    func showPaywall() {
        coordinator.showPaywall()
    }
    
    func showResumeTemplates() {
        coordinator.showResumeTemplates()
    }
    
    func backTapped() {
        coordinator.popView()
    }
     
    func deleteItem(_ item: CoverLetterItem) {
        HistoryItemRepository.shared.deleteCoverLetterItem(item)
        objectWillChange.send()
    }
}

