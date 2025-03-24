import SwiftUI


final class ProfileViewModel: ObservableObject {
    @Published var profileData: ProfileDataType = .skills
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
    var couldGoNext: Bool {
        switch profileData {
        case .profile:
            return !(firstname.isEmpty && lastname.isEmpty && jobTitle.isEmpty && summary.isEmpty)
        case .contact:
            return !(email.isEmpty && phone.isEmpty && site.isEmpty && location.isEmpty)
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
    
    
    
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func popView() {
        coordinator.popView()
    }
}
