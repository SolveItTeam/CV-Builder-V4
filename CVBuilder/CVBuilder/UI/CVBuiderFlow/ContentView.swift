import SwiftUI

import SwiftUI
import PDFKit

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

struct WorkExperienceInput: Identifiable {
    var id = UUID()
    var workStartedDate: Date = Date()
    var workEndedDate: Date = Date()
    var speciality: String = ""
    var companyName: String = ""
    var country: String = ""
    // Duties entered as a comma‑separated string (later split into an array)
    var duties: String = ""
}

struct EducationInput: Identifiable {
    var id = UUID()
    var startedDate: Date = Date()
    var endedDate: Date = Date()
    var education: String = ""
    var description: String = ""
}

struct SkillInput: Identifiable {
    var id = UUID()
    var type: String = ""
    var description: String = ""
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let pdfDocument: PDFDocument?
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


import SwiftUI
import PDFKit

struct ContentView: View {
    // MARK: - User Inputs
    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var summary: String = ""
    
    // MARK: - Dynamic Section States
    @State private var workExperiences: [WorkExperienceInput] = []
    @State private var educationExperiences: [EducationInput] = []
    @State private var skills: [SkillInput] = []
    
    private let maxWorkExperience = 4
    private let maxEducation = 2
    private let maxSkills = 3
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    // MARK: - PDF & Share States
    @State private var pdfDocument: PDFDocument?
    @State private var showShareSheet = false
    @State private var temporaryFileURL: URL?
    @StateObject var cvBuilder: CVBuilder = CVBuilder()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Personal Information
                    Group {
                        Text("Personal Information")
                            .font(.headline)
                        TextField("Full Name", text: $fullname)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Phone", text: $phone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Summary", text: $summary)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            Button("Select Photo") {
                                showImagePicker = true
                            }
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    
                    // MARK: Work Experience Section
                    Group {
                        HStack {
                            Text("Work Experience")
                                .font(.headline)
                            Spacer()
                            if workExperiences.count < maxWorkExperience {
                                Button {
                                    workExperiences.append(WorkExperienceInput())
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                }
                            }
                        }
                        
                        ForEach($workExperiences) { $work in
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Speciality", text: $work.speciality)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("Company Name", text: $work.companyName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("Country", text: $work.country)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                DatePicker("Start Date", selection: $work.workStartedDate, displayedComponents: .date)
                                DatePicker("End Date", selection: $work.workEndedDate, displayedComponents: .date)
                                TextField("Duties (separated by commas)", text: $work.duties)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                    }
                    
                    // MARK: Education Section
                    Group {
                        HStack {
                            Text("Education")
                                .font(.headline)
                            Spacer()
                            if educationExperiences.count < maxEducation {
                                Button {
                                    educationExperiences.append(EducationInput())
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                }
                            }
                        }
                        ForEach($educationExperiences) { $edu in
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Education Name", text: $edu.education)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("Description", text: $edu.description)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                DatePicker("Start Date", selection: $edu.startedDate, displayedComponents: .date)
                                DatePicker("End Date", selection: $edu.endedDate, displayedComponents: .date)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                    }
                    
                    // MARK: Skills Section
                    Group {
                        HStack {
                            Text("Skills")
                                .font(.headline)
                            Spacer()
                            if skills.count < maxSkills {
                                Button {
                                    skills.append(SkillInput())
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                }
                            }
                        }
                        ForEach($skills) { $skill in
                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Skill Type", text: $skill.type)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("Description", text: $skill.description)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                    }
                    
                    // MARK: PDF Generation & Preview
                    Button("Generate PDF") {
                        generatePDF()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    if let pdfDocument {
                        Text("PDF Preview")
                            .font(.headline)
                        PDFKitRepresentedView(pdfDocument: pdfDocument)
                            .frame(minHeight: 300)
                    }
                    
                    if pdfDocument != nil {
                        Button("Share PDF") {
                            if let doc = pdfDocument { exportPDF(document: doc) }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                
            }
            .padding()
            // Present share sheet when needed
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [temporaryFileURL])
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            //            .onAppear {
            //                overlayTextOnPDF(
            //                    inity: CVConstructor(
            //                        fullname: "Katherine Monroe",
            //                        speciality: "UX/UI Designer",
            //                        phone: "+99 (99) 9.9999-9999",
            //                        email: "katherinem@email.com ",
            //                        summary: "A creative and detail-oriented graphic designer with experience in creating visually appealing and functional designs. I have skills in developing identities, corporate styles.",
            //                        workExperience: [
            //                            Work(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", duties: ["Visual Design", "Prototyping", "UX Researching", "Front-end Dev", "Unity 3d Models", "Principle", "Presentations", "Web / Mobile"]),
            //
            //                            Work(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", duties: ["Visual Design", "Prototyping", "UX Researching", "Front-end Dev", "Unity 3d Models", "Principle", "Presentations", "Web / Mobile"]),
            //
            //                            Work(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", duties: ["Visual Design", "Prototyping", "UX Researching", "Front-end Dev", "Unity 3d Models", "Principle", "Presentations", "Web / Mobile"]),
            //
            //                            Work(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", duties: ["Visual Design", "Prototyping", "UX Researching", "Front-end Dev", "Unity 3d Models", "Principle", "Presentations", "Web / Mobile"])
            //                        ],
            //                        education: [
            //                            Education(startedDate: Date(), endedDate: Date(), education: "It-Academy", description: "Belarussian State\nPedagogical University (Minsk)"),
            //                            Education(startedDate: Date(), endedDate: Date(), education: "It-Academy", description: "Full Stack Web designer\nFront-end Dev (Minsk)")
            //                        ],
            //                        skills: [
            //                            Skills(type: "Hard Skills", description: "Axure, Figma, Sketch, Photoshop,\nIllustrator, XD, Unity, Zeplin, Principle"),
            //                            Skills(type: "Soft Skills", description: "NPM, JavaScript, HTML, CSS, Bootstrap, Git, Lit"),
            //                            Skills(type: "Languages", description: "English, Spanish, Russian"),
            //                        ]))
            //            }
        }
    }
    
    
    private func generatePDF() {
        let workArray: [Work] = workExperiences.reversed().map { input in
            let duties = input.duties
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            return Work(
                workStartedDate: input.workStartedDate,
                workEndedDate: input.workEndedDate,
                speciality: input.speciality,
                companyName: input.companyName,
                country: input.country,
                duties: duties
            )
        }
        
        let educationArray: [Education] = educationExperiences.reversed().map { input in
            Education(
                startedDate: input.startedDate,
                endedDate: input.endedDate,
                education: input.education,
                description: input.description
            )
        }
        
        let skillsArray: [Skills] = skills.map { input in
            Skills(
                type: input.type,
                description: input.description
            )
        }
        
        
        let cvModel = CVConstructor(
            fullname: fullname,
            speciality: workArray.first?.speciality ?? "",
            phone: phone,
            email: email,
            summary: summary,
            workExperience: workArray,
            education: educationArray,
            skills: skillsArray
        )
        
        overlayTextOnPDF(inity: cvModel)
    }
    
    // MARK: - Fill PDF
    /// Loads the local PDF from the app bundle, finds form fields, and updates them.
    private func overlayTextOnPDF(inity: CVConstructor) {
        guard let url = Bundle.main.url(forResource: R.file.coloredTemplatePdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load cv.pdf from bundle.")
            return
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return
        }
        
        // -- PHOTO ANNOTATION --
        let imageFrame = CGRect(
            x: 328,
            y: cvBuilder.convertYCoordinate(
                top: 132,
                elementHeight: 20,
                pageHeight: cvBuilder.pageSize.height
            ),
            width: 124,
            height: 124
        )
        
        let photo = selectedImage ?? UIImage(resource: .woman)
        let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: photo, properties: nil)
        page.addAnnotation(imageAnnotation)
        
        // -- PERSONAL INFO --
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 73.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.fullname
        nameAnnotation.font = R.font.latoExtraBold.callAsFunction(size: 21.64)!
        nameAnnotation.fontColor = .blackMain
        nameAnnotation.backgroundColor = .clear
        nameAnnotation.color = .clear
        page.addAnnotation(nameAnnotation)
        
        let speciallityAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 103.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        speciallityAnnotation.contents = inity.speciality
        speciallityAnnotation.font = R.font.latoRegular.callAsFunction(size: 14.64)!
        speciallityAnnotation.fontColor = .blackMain
        speciallityAnnotation.backgroundColor = .clear
        speciallityAnnotation.color = .clear
        page.addAnnotation(speciallityAnnotation)
        
        let phoneAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 130.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneAnnotation.contents = inity.phone
        phoneAnnotation.font = R.font.latoMedium.callAsFunction(size: 9.41)!
        phoneAnnotation.fontColor = .blackMain
        phoneAnnotation.backgroundColor = .clear
        phoneAnnotation.color = .clear
        page.addAnnotation(phoneAnnotation)
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 200.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 130.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = inity.email
        emailAnnotation.font = R.font.latoRegular.callAsFunction(size: 9.41)!
        emailAnnotation.fontColor = .blackMain
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        let summaryTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 160.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        summaryTitleAnnotation.contents = R.string.localizable.summary.callAsFunction()
        summaryTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 10.41)!
        summaryTitleAnnotation.fontColor = .blackMain
        summaryTitleAnnotation.backgroundColor = .clear
        summaryTitleAnnotation.color = .clear
        page.addAnnotation(summaryTitleAnnotation)
        
        let summaryAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 150.92,
                            elementHeight: 60,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        summaryAnnotation.contents = inity.summary
        summaryAnnotation.font = R.font.latoRegular.callAsFunction(size: 8.41)!
        summaryAnnotation.fontColor = .blackMain
        summaryAnnotation.backgroundColor = .clear
        summaryAnnotation.color = .clear
        page.addAnnotation(summaryAnnotation)
        
        // -- WORK EXPERIENCE TITLE --
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 220.0,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        workExperienceTitleAnnotation.contents = R.string.localizable.workExperience()
        workExperienceTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 13.22)!
        workExperienceTitleAnnotation.fontColor = .blackMain
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        // -- WORK EXPERIENCE LOOP (TOP-TO-BOTTOM) --
        let baseY: CGFloat = 84.0   // Starting "top" for first job
        let verticalSpacing: CGFloat = 140.0 // Space between jobs
        for (index, work) in inity.workExperience.enumerated() {
            // For each job, we add (index * spacing) so that the next job is lower on the page
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            // Job Title
            let jobTitleAnnotation = PDFAnnotation(
                bounds: CGRect(x: 70, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobTitleAnnotation.contents = work.speciality
            jobTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 9)!
            jobTitleAnnotation.fontColor = .blackMain
            jobTitleAnnotation.backgroundColor = .clear
            jobTitleAnnotation.color = .clear
            page.addAnnotation(jobTitleAnnotation)
            
            // Company
            let companyAnnotation = PDFAnnotation(
                bounds: CGRect(x: 70, y: yPosition - 20, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            companyAnnotation.contents = work.companyName
            companyAnnotation.font = R.font.latoExtraBold.callAsFunction(size: 10)!
            companyAnnotation.fontColor = .blackMain
            companyAnnotation.backgroundColor = .clear
            companyAnnotation.color = .clear
            page.addAnnotation(companyAnnotation)
            
            // Period
            let periodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition - 1, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: work.workStartedDate)
            let endDate = formatter.string(from: work.workEndedDate)
            periodAnnotation.contents = "\(startDate) - \(endDate)"
            periodAnnotation.font = R.font.latoRegular.callAsFunction(size: 8)!
            periodAnnotation.fontColor = .c595959
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            // Location
            let locationAnnotation = PDFAnnotation(
                bounds: CGRect(x: 220, y: yPosition - 21, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            locationAnnotation.contents = work.country
            locationAnnotation.font = R.font.latoRegular.callAsFunction(size: 8.41)!
            locationAnnotation.fontColor = .blackMain
            locationAnnotation.backgroundColor = .clear
            locationAnnotation.color = .clear
            page.addAnnotation(locationAnnotation)
            
            // Duties (two-column split)
            let leftDuties = work.duties.prefix(work.duties.count / 2)
            let rightDuties = work.duties.suffix(work.duties.count / 2)
            let leftDutiesText = leftDuties.map { "• \($0)" }.joined(separator: "\n")
            let rightDutiesText = rightDuties.map { "• \($0)" }.joined(separator: "\n")
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 76, y: yPosition - 80, width: 200, height: 60),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = leftDutiesText
            leftDutiesAnnotation.font = R.font.sourceSansProRegular.callAsFunction(size: 7.81)!
            leftDutiesAnnotation.fontColor = .c595959
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
            
            let rightDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 180, y: yPosition - 81, width: 200, height: 60),
                forType: .freeText,
                withProperties: nil
            )
            rightDutiesAnnotation.contents = rightDutiesText
            rightDutiesAnnotation.font = R.font.sourceSansProRegular.callAsFunction(size: 7.81)!
            rightDutiesAnnotation.fontColor = .c595959
            rightDutiesAnnotation.backgroundColor = .clear
            rightDutiesAnnotation.color = .clear
            page.addAnnotation(rightDutiesAnnotation)
        }
        
        // -- EDUCATION SECTION --
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 323.00,
                           y: cvBuilder.convertYCoordinate(top: 242.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = R.string.localizable.education()
        educationTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 13.22)!
        educationTitleAnnotation.fontColor = .blackMain
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 230.0
        let educationSpacing: CGFloat = 95.0
        let educationBoxHeight: CGFloat = 72.0
        // *No .reversed()*, top-to-bottom
        for (index, edu) in inity.education.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: educationBaseY + CGFloat(index) * educationSpacing,
                elementHeight: educationBoxHeight,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let startDate = formatter.string(from: edu.startedDate)
            let endDate = formatter.string(from: edu.endedDate)
            
            let educationPeriodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 334, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationPeriodAnnotation.contents = "\(startDate)-\(endDate)"
            educationPeriodAnnotation.font = R.font.latoRegular.callAsFunction(size: 9)!
            educationPeriodAnnotation.fontColor = .darkGray
            educationPeriodAnnotation.backgroundColor = .clear
            educationPeriodAnnotation.color = .clear
            page.addAnnotation(educationPeriodAnnotation)
            
            let educationNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 334, y: yPosition - 14, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationNameAnnotation.contents = edu.education
            educationNameAnnotation.font = R.font.latoBold.callAsFunction(size: 10)!
            educationNameAnnotation.fontColor = .black
            educationNameAnnotation.backgroundColor = .clear
            educationNameAnnotation.color = .clear
            page.addAnnotation(educationNameAnnotation)
            
            let descriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 334, y: yPosition - 40, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            descriptionAnnotation.contents = edu.description
            descriptionAnnotation.font = R.font.latoRegular.callAsFunction(size: 9)!
            descriptionAnnotation.fontColor = .darkGray
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        
        // -- SKILLS SECTION --
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 323.00,
                           y: cvBuilder.convertYCoordinate(top: 470.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = R.string.localizable.skills()
        skillsTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 13.22)!
        skillsTitleAnnotation.fontColor = .blackMain
        skillsTitleAnnotation.backgroundColor = .clear
        skillsTitleAnnotation.color = .clear
        page.addAnnotation(skillsTitleAnnotation)
        
        let skillsBaseY: CGFloat = 460.0
        let skillsSpacing: CGFloat = 85.0
        let skillsBoxHeight: CGFloat = 70.0
        // *No .reversed()*, top-to-bottom
        for (index, skill) in inity.skills.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: skillsBaseY + CGFloat(index) * skillsSpacing,
                elementHeight: skillsBoxHeight,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let skillsTitleAnnotation = PDFAnnotation(
                bounds: CGRect(x: 334, y: yPosition - 5, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            skillsTitleAnnotation.contents = skill.type
            skillsTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 10)!
            skillsTitleAnnotation.fontColor = .black
            skillsTitleAnnotation.backgroundColor = .clear
            skillsTitleAnnotation.color = .clear
            page.addAnnotation(skillsTitleAnnotation)
            
            let skillsDescriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 334, y: yPosition - 35, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            skillsDescriptionAnnotation.contents = skill.description
            skillsDescriptionAnnotation.font = R.font.latoRegular.callAsFunction(size: 9)!
            skillsDescriptionAnnotation.fontColor = .darkGray
            skillsDescriptionAnnotation.backgroundColor = .clear
            skillsDescriptionAnnotation.color = .clear
            page.addAnnotation(skillsDescriptionAnnotation)
        }
        
        // -- FINALIZE --
        self.pdfDocument = pdfDoc
    }
    
    private func exportPDF(document: PDFDocument) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("myCV.pdf")
        if document.write(to: tempURL) {
            print("PDF successfully saved at:", tempURL)
            
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: tempURL.path)
                let fileSize = attributes[.size] as? Int ?? 0
                print("PDF file size: \(fileSize) bytes")
            } catch {
                print("Failed to get file attributes:", error)
            }
            
            temporaryFileURL = tempURL
            showShareSheet = true
        } else {
            print("Failed to write PDF file.")
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

import PDFKit
import UIKit

class ImageStampAnnotation: PDFAnnotation {
    private let stampImage: UIImage
    
    init(bounds: CGRect, image: UIImage , properties: [AnyHashable : Any]?) {
        self.stampImage = image
        super.init(bounds: bounds, forType: .stamp, withProperties: properties)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Draw the UIImage inside the annotation’s bounds
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        guard let cgImage = stampImage.cgImage else { return }
        
        context.saveGState()
        
        context.draw(cgImage, in: bounds)
        context.restoreGState()
    }
}

final class CVBuilder: ObservableObject {
    let pageSize = CGSize(width: 595.2, height: 841.8)
    
    func convertYCoordinate(top: CGFloat, elementHeight: CGFloat, pageHeight: CGFloat) -> CGFloat {
        return pageHeight - (top + elementHeight)
    }
}

#Preview {
    ContentView()
}
