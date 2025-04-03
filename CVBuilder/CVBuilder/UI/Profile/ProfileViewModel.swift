import SwiftUI
import PDFKit

final class ProfileViewModel: ObservableObject {
    @Published var profileData: ProfileDataType = .profile
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var summary: String = ""
    @Published var jobTitle: String = ""
    @Published var site: String = ""
    @Published var location: String = ""
    @Published var showWorkSheet: Bool = false
    @Published var showEducationSheet: Bool = false
    @Published var showSkillsSheet: Bool = false
    @Published var showLanguagesSheet: Bool = false
    @Published var isShowingAlert: Bool = false
    @Published var isCloseResumeAlert: Bool = false
    @Published var appError: AppError = .raw(title: R.string.localizable.somethingWentWrong(), subTitle: R.string.localizable.pleaseTryAgain())
    // MARK: - Dynamic Section States
    @Published var workExperiences: [WorkExperienceInput] = []
    @Published var educationExperiences: [EducationInput] = []
    @Published var skills: [SkillInput] = []
    @Published var previewImage: Image = Image(systemName: "doc")
    @Published var filename: String = "myCV"
    @Published var selectedWorkIndex: Int? = nil
    @Published var newWorkExperience: WorkExperienceInput = WorkExperienceInput()
    @Published var newEducationExperience: EducationInput = EducationInput()
    @Published var languages: [Language] = []
    @Published var chosenTemplate: CVTemplate?
    let keychain: KeychainService = .init()
    private let generator: CVGenerator = .init()
    
    var couldGoNext: Bool {
        switch profileData {
        case .profile:
            return !firstname.isEmpty && !lastname.isEmpty && !jobTitle.isEmpty && !summary.isEmpty
        case .contact:
            return !email.isEmpty && !phone.isEmpty && !site.isEmpty && !location.isEmpty
        case .workExperience:
            return !workExperiences.isEmpty
        case .education:
            return !educationExperiences.isEmpty
        case .skills:
            return !skills.isEmpty
        }
    }
    
    let maxWorkExperience = 4
    let maxEducation = 2
    let maxSkills = 20
    let maxLanguages = 10
    @Published var selectedImage: UIImage? = nil
    @Published var showImagePicker: Bool = false
    
    var resultCompletion: (() -> Void)?
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator, chosenTemplate: CVTemplate?, resultCompletion: (() -> Void)?) {
        self.coordinator = coordinator
        self.chosenTemplate = chosenTemplate
        self.resultCompletion = resultCompletion
        preloadData()
    }
    
    func preloadData() {
        guard let user = keychain.user else { return }
        let savedData = user.savedData
        firstname = savedData.firstname
        lastname = savedData.lastname
        email = savedData.email
        phone = savedData.phone
        summary = savedData.summary
        jobTitle = savedData.jobTitle
        site = savedData.site
        location = savedData.location
        workExperiences = savedData.workExperience
        educationExperiences = savedData.education
        skills = savedData.skills
        languages = savedData.languages
        
        if let imagePath = savedData.profileImagePath {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsDirectory.appendingPathComponent(imagePath)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
                    selectedImage = loadedImage
                    previewImage = Image(uiImage: loadedImage)
                    print("Loaded image from: \(fileURL.path)")
                } else {
                    print("Failed to load image data from: \(fileURL.path)")
                }
            } else {
                print("No image found at: \(fileURL.path)")
            }
        }
    }
    
    func dismiss() {
        coordinator.dismissSheet()
    }
    
    func saveProfile() {
        keychain.user?.savedData.firstname = firstname
        keychain.user?.savedData.lastname = lastname
        keychain.user?.savedData.email = email
        keychain.user?.savedData.phone = phone
        keychain.user?.savedData.summary = summary
        keychain.user?.savedData.jobTitle = jobTitle
        keychain.user?.savedData.site = site
        keychain.user?.savedData.location = location
        keychain.user?.savedData.workExperience = workExperiences
        keychain.user?.savedData.education = educationExperiences
        keychain.user?.savedData.skills = skills
        keychain.user?.savedData.languages = languages
        
        saveImageToFileManager()
    }
    
    func saveImageToFileManager() {
        guard let image = selectedImage, let imageData = image.pngData() else { return }
        let fileName = "profileImage.png"  // Store only the file name
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        do {
            try imageData.write(to: fileURL)
            keychain.user?.savedData.profileImagePath = fileName // Save the file name instead of the absolute path
            print("Image saved at: \(fileURL.path)")
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
}
