import Foundation

struct Work {
    let workStartedDate: Date
    let workEndedDate: Date
    let speciality: String
    let companyName: String
    let country: String
    let duties: [String]
}

struct Education {
    let startedDate: Date
    let endedDate: Date
    let education: String
    let description: String
}

struct Skills {
    let type: String
    let description: String
}


struct CVConstructor {
    let fullname: String
    let speciality: String
    let phone: String
    let email: String
    let summary: String
    let workExperience: [Work]
    let education: [Education]
    let skills: [Skills]
}

struct WorkExperienceInput: Identifiable, Hashable {
    var id = UUID()
    var workStartedDate: Date = Date()
    var workEndedDate: Date = Date()
    var speciality: String = ""
    var companyName: String = ""
    var country: String = ""
    var duties: [String] = []
    var stillWorkingHere: Bool = false
    var jobDescirption: String = ""
}

struct EducationInput: Identifiable {
    var id = UUID()
    var startedDate: Date = Date()
    var endedDate: Date = Date()
    var degree: String = ""
    var education: String = ""
    var description: String = ""
    var stillStudyingHere: Bool = false
}

struct SkillInput: Identifiable, Hashable {
    var id = UUID() 
    var description: String = ""
}

struct Language: Identifiable, Hashable {
    var id = UUID()
    var name: String = ""
}
