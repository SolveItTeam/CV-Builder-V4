import Foundation

struct CreatedTemplate: Identifiable  {
    let id: UUID = UUID()
    var cvData: CVConstructor
    var fileAbsolutePath: String
}

struct Work: Codable {
    var workStartedDate: Date
    var workEndedDate: Date
    var speciality: String
    var companyName: String
    var country: String
    var duties: [String]
}

struct Education: Codable {
    var startedDate: Date
    var endedDate: Date
    var education: String
    var description: String
}

struct Skills: Codable {
    var type: String
    var description: String
}

struct CVConstructor: Codable {
    var firstname: String
    var lastname: String
    var email: String
    var phone: String
    var summary: String
    var jobTitle: String
    var site: String
    var location: String
    var workExperience: [WorkExperienceInput]
    var education: [EducationInput]
    var skills: [SkillInput]
    var languages: [Language]
    var profileImagePath: String?
}

struct WorkExperienceInput: Identifiable, Hashable, Codable {
    var id = UUID()
    var workStartedDate: Date = Date()
    var workEndedDate: Date = Date()
    var speciality: String = ""
    var companyName: String = ""
    var country: String = ""
    var stillWorkingHere: Bool = false
    var jobDescirption: String = ""
}

struct EducationInput: Identifiable, Codable {
    var id = UUID()
    var startedDate: Date = Date()
    var endedDate: Date = Date()
    var degree: String = ""
    var education: String = ""
    var description: String = ""
    var stillStudyingHere: Bool = false
}

struct SkillInput: Identifiable, Hashable, Codable {
    var id = UUID() 
    var description: String = ""
}

struct Language: Identifiable, Hashable, Codable  {
    var id = UUID()
    var name: String = ""
}
