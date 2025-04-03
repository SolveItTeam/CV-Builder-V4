import SwiftUI
import PDFKit

final class ResultViewModel: ObservableObject {
    @Published var pdfDocument: PDFDocument?
    @Published var fileData: Data?
    @Published var previewImage: Image?
    
    @Published var imagesForTemplates: [String: Image] = [:]
    
    @Published var chosenTemplate: CVTemplate
    @Published var currentIndex: Int
    
    @Published var isLoading: Bool = false
    @Published var showProIcon: Bool
    
    @Published var shareSheetIsPresented: Bool = false
    var temporaryShareURL: URL?
    
    @Published var isDocumentPickerPresented: Bool = false
    var exportFileURL: URL?
    
    private let coordinator: Coordinator
    private let generator: CVGenerator = .init()
    private let keychain: KeychainService = .init()
    private let purchaseManager: PurchaseManager = .shared
    
    let isResult: Bool
    let historyItem: HistoryItem?
     
    var historySaved: Bool = false
    
    init(coordinator: Coordinator,
         chosenTemplate: CVTemplate,
         isResult: Bool,
         historyItem: HistoryItem?) {
        self.coordinator = coordinator
        self.chosenTemplate = chosenTemplate
        self.isResult = isResult
        self.historyItem = historyItem
        self.currentIndex = templatesList.firstIndex {
            $0.fileToUseString == chosenTemplate.fileToUseString
        } ?? 0
        
        self.showProIcon = !purchaseManager.isPremium
        purchaseManager.$isPremium
            .map { !$0 }
            .assign(to: &$showProIcon)
    }
    
    func backTapped() {
        coordinator.popView()
    }
    
    func showPaywall() {
        coordinator.showPaywall()
    }
    
    func generateAllCVPreviews() {
        guard let data = keychain.user?.savedData else { return }
        isLoading = true
        
        Task {
            var tempImages: [String: Image] = [:]
            for template in templatesList {
                if let result = await generator.build(with: template, cvConstructor: data) {
                    tempImages[template.fileToUseString] = result.previewImage
                }
            }
            await MainActor.run {
                self.imagesForTemplates = tempImages
                self.isLoading = false
            }
        }
    }
    
    func showProfile() {
        coordinator.showProfileView()
    }
    
    func generateCV() {
        guard let data = keychain.user?.savedData else { return }
        
        Task {
            let result = await generator.build(with: chosenTemplate, cvConstructor: data)
            await MainActor.run {
                if let result = result {
                    self.pdfDocument = result.doc
                    self.fileData = result.fileData
                    self.previewImage = result.previewImage
                     
                    if !self.historySaved, let fileData = self.fileData {
                        let fileName = self.chosenTemplate.fileToUseString
                        let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                                    in: .userDomainMask).first!
                        let fileURL = documentsURL.appendingPathComponent(fileName)
                        
                        do {
                            try fileData.write(to: fileURL)
                            self.saveCVToHistory(jobTitle: self.obtainJobTitleFromData(), fullName: data.firstname + " " + data.lastname, fileURL: fileURL)
                            self.historySaved = true
                        } catch {
                            print("Error saving PDF in generateCV: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func prepareAndExportPDF() {
        let fileName: String
        if isResult, let historyItem = historyItem, let storedFileName = historyItem.filePath {
            fileName = storedFileName
        } else {
            fileName = chosenTemplate.fileToUseString
        }
         
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        if isResult {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("isResult: Using existing PDF file from history.")
            } else {
                print("isResult: PDF file not found in history!")
            }
        } else {
            guard let data = fileData else { return }
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("PDF already exists, using existing file.")
            } else {
                do {
                    try data.write(to: fileURL)
                    guard let profile = keychain.user?.savedData else { return }
                    self.saveCVToHistory(jobTitle: self.obtainJobTitleFromData(), fullName: profile.firstname + " " + profile.lastname, fileURL: fileURL)
                    self.historySaved = true  
                } catch {
                    print("Error writing PDF: \(error)")
                }
            }
        }
        
        exportFileURL = fileURL
        isDocumentPickerPresented = true
        print("PDF file URL: \(fileURL.path)")
    }

    func sharePDF() {
        let fileName: String
        if isResult, let historyItem = historyItem, let storedFileName = historyItem.filePath {
            fileName = storedFileName
        } else {
            fileName = chosenTemplate.fileToUseString
        }
         
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        if isResult {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("isResult: Using existing PDF file for share.")
            } else {
                print("isResult: PDF file not found for share!")
            }
        } else {
            guard let data = fileData else { return }
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("PDF file already exists, using it for share.")
            } else {
                do {
                    try data.write(to: fileURL)
                    guard let profile = keychain.user?.savedData else { return }
                    self.saveCVToHistory(jobTitle: self.obtainJobTitleFromData(), fullName: profile.firstname + " " + profile.lastname, fileURL: fileURL)
                    self.historySaved = true
                } catch {
                    print("Error writing PDF for share: \(error)")
                }
            }
        }
        
        temporaryShareURL = fileURL
        shareSheetIsPresented = true
    }
    private func obtainJobTitleFromData() -> String {
        guard let data = keychain.user?.savedData else {
            return "Untitled"
        }
        return data.jobTitle.isEmpty ? "Untitled" : data.jobTitle
    }
    
    private func saveCVToHistory(jobTitle: String, fullName: String, fileURL: URL) {
        let fileName = fileURL.lastPathComponent
        let creationDate = Date()
        
        HistoryItemRepository.shared.createHistoryItem(
            jobTitle: jobTitle,
            creationDate: creationDate, fullName: fullName,
            filePath: fileName,
            cvConstructor: keychain.user?.savedData
        )
        
        objectWillChange.send()
    }
}
