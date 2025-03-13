import SwiftUI


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
    // MARK: - Dynamic Section States
    @Published var workExperiences: [WorkExperienceInput] = []
    @Published var educationExperiences: [EducationInput] = []
    @Published var skills: [SkillInput] = []
    @Published var previewImage: Image = Image(systemName: "doc")
    @Published var filename: String = "myCV"
    @Published var selectedWorkIndex: Int? = nil
    @Published var newDuties: [String] = [""]
    
    let maxWorkExperience = 4
    let maxEducation = 2
    let maxSkills = 3
    @Published var selectedImage: UIImage? = nil
    @Published var showImagePicker: Bool = false
    
    
    
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
