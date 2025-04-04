import SwiftUI
import sharelink_for_swiftui

import SwiftUI
import PDFKit

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

// MARK: - Transferable PDFDocument Extensions
extension PDFDocument {
    // Capture the first page of the PDF as a UIImage
    public var imageRepresenation: UIImage? {
        guard let pdfPage = self.page(at: 0) else { return nil }
        let pageBounds = pdfPage.bounds(for: .cropBox)
        
        let renderer = UIGraphicsImageRenderer(size: pageBounds.size)
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageBounds)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageBounds.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            UIGraphicsPushContext(ctx.cgContext)
            pdfPage.draw(with: .cropBox, to: ctx.cgContext)
            UIGraphicsPopContext()
        }
        return image
    }
    
    // (Optional) Return the PDF’s title
    public var title: String? {
        guard
            let attributes = self.documentAttributes,
            let titleAttribute = attributes[PDFDocumentAttribute.titleAttribute]
        else {
            return nil
        }
        return titleAttribute as? String
    }
}

// Conform PDFDocument to Transferable so it can be shared
extension PDFDocument: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .pdf) { pdf in
            guard let data = pdf.dataRepresentation() else {
                fatalError("Could not create a pdf file from dataRepresentation()")
            }
            var fileURL = FileManager.default.temporaryDirectory
            
            // If the PDF document has a title, use that as the filename
            if let title = pdf.title {
                fileURL = fileURL.appendingPathComponent(title).appendingPathExtension("pdf")
            } else {
                // Fallback if no title is set
                fileURL = fileURL.appendingPathComponent("cvDocument").appendingPathExtension("pdf")
            }
            
            try data.write(to: fileURL)
            return SentTransferredFile(fileURL)
        }
    }
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



var inity =  CVConstructor(
    firstname: "Katherine",
    lastname: "Monroe",
    email: "katherinem@email.com",
    phone: "+99 (99) 9.9999-9999",
    summary: String("Accomplished iOS Developer with a proven track record of designing, developing, and deploying innovative iOS applications. With [X years] of experience in Swift, Objective-C, and modern iOS frameworks, I excel at translating complex requirements into user-friendly mobile solutions. I am adept at agile methodologies, version control systems (e.g., Git), and integrating RESTful APIs to enhance app functionality. My passion for clean code, performance optimization, and continuous learning drives my commitment to delivering high-quality software that meets both business objectives and user needsAccomplished iOS Developer with a proven track record of designing, developing, and deploying innovative iOS applications. With [X years] of experience in Swift, Objective-C, and modern iOS frameworks, I excel at translating complex requirements into user-friendly mobile solutions. I am adept at agile methodologies, version control systems (e.g., Git), and integrating RESTful APIs to enhance app functionality.".prefix(600)),
    jobTitle: "UX/UI Designer",
    site: "=https:\\iopjkwropkwedkepw.com",
    location: "Minsk",
    workExperience: [
        WorkExperienceInput(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", jobDescirption: "Accomplished iOS Developer with a proven track record of designing, developing, and deploying innovative iOS applications. With [X years] of experience in Swift, Objective-C, and modern iOS frameworks ,"),
        
        WorkExperienceInput(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", jobDescirption: "Accomplished iOS Developer with a proven track record of designing, developing, and deploying innovative iOS applications. With [X years] of experience in Swift, Objective-C, and modern iOS frameworks ,"),
        
        WorkExperienceInput(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", jobDescirption: "Accomplished iOS Developer with a proven track record of designing, developing, and deploying innovative iOS applications. With [X years] of experience in Swift, Objective-C, and modern iOS frameworks ,"),
        
        WorkExperienceInput(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", jobDescirption: "Accomplished iOS Developer with a proven track record of designing, developing, and deploying innovative iOS applications. With [X years] of experience in Swift, Objective-C, and modern iOS frameworks ,")
    ],
    education: [
        EducationInput(startedDate: Date(), endedDate: Date(), education: "It-Academy", description: "Belarussian State"),
        EducationInput(startedDate: Date(), endedDate: Date(), education: "It-Academy", description: "Full Stack Web designer ")
    ],
    skills: [
        SkillInput(description: "Axure"),
        SkillInput(description: "Figma"),
        SkillInput(description: "Sketch"),
        SkillInput(description: "Photoshop"),
        SkillInput(description: "Illustrator"),
        SkillInput(description: "XD"),
        SkillInput(description: "Unity"),
        SkillInput(description: "Zeplin"),
        SkillInput(description: "Principle"),
        SkillInput(description: "NPM"),
        SkillInput(description: "JavaScript"),
        SkillInput(description: "HTML"),
        SkillInput(description: "CSS"),
        SkillInput(description: "Bootstrap"),
        SkillInput(description: "Git"),
        SkillInput(description: "Lit"),
        SkillInput(description: "Axure"),
        SkillInput(description: "Figma"),
        SkillInput(description: "Sketch"),
        SkillInput(description: "Photoshop"),
        SkillInput(description: "Illustrator"),
        SkillInput(description: "XD"),
        SkillInput(description: "Unity"),
        SkillInput(description: "Zeplin"),
        SkillInput(description: "Principle"),
        SkillInput(description: "NPM"),
        SkillInput(description: "JavaScript"),
        SkillInput(description: "HTML"),
        SkillInput(description: "CSS"),
        SkillInput(description: "Bootstrap"),
        SkillInput(description: "Git"),
        SkillInput(description: "Lit"),
        SkillInput(description: "Axure"),
        SkillInput(description: "Figma"),
        SkillInput(description: "Sketch"),
        SkillInput(description: "Photoshop"),
        SkillInput(description: "Illustrator"),
        SkillInput(description: "XD"),
        SkillInput(description: "Unity"),
        SkillInput(description: "Zeplin"),
        SkillInput(description: "Principle"),
        SkillInput(description: "NPM"),
        SkillInput(description: "JavaScript"),
        SkillInput(description: "HTML"),
    ],
    languages: [
        Language(name: "English"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "English"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "English"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "English"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
        Language(name: "Russian"),
    ], coverLetterCompanyName: "Solveit"
)

import SwiftUI
import PDFKit

struct ContentView: View {
    @State private var pdfDocument: PDFDocument = PDFDocument()
    @State private var data: Data = Data()
    @State private var previewImage: Image = Image(systemName: "doc")
    @State private var filename: String = "myCV"
    private let cvBuilder = ConstructHelper()
    
    private let maxWorkExperience = 4
    private let maxEducation = 2
    private let maxSkills = 3
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    // MARK: - PDF & Share States
    @State private var showShareSheet = false
    @State private var temporaryFileURL: URL?
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if pdfDocument.pageCount > 0 {
                        PDFKitRepresentedView(pdfDocument: pdfDocument)
                            .frame(minHeight: 600)
                    }
                    
                    if pdfDocument.pageCount > 0 {
                        ShareLink(
                            item: pdfDocument,
                            preview: SharePreview(
                                filename,
                                image: previewImage
                            )
                        )
                    }
                }
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .task {
                overlayTextOnPDF8(
                    cv: inity
                )
            }
        }
    }
    
    private func overlayTextOnСover(cv: CVConstructor) {
        let inity = cv
        
        guard let url = Bundle.main.url(forResource: R.file.coverLetterTemplatePdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load  pdf from bundle.")
            return
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return
        }
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 31,
                           y: cvBuilder.convertYCoordinate(
                            top: 34,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 400,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname
        nameAnnotation.font = R.font.figtreeRegular(size: 12)!
        nameAnnotation.fontColor = .blackMain
        nameAnnotation.backgroundColor = .clear
        nameAnnotation.color = .clear
        page.addAnnotation(nameAnnotation)
        
        let jobAnnotation = PDFAnnotation(
            bounds: CGRect(x: 31,
                           y: cvBuilder.convertYCoordinate(
                            top: 51,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 400,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        jobAnnotation.contents = inity.jobTitle
        jobAnnotation.font = R.font.figtreeRegular(size: 12)!
        jobAnnotation.fontColor = .blackMain
        jobAnnotation.backgroundColor = .clear
        jobAnnotation.color = .clear
        page.addAnnotation(jobAnnotation)
        
        
        let letterAnnotation = PDFAnnotation(
            bounds: CGRect(x: 60,
                           y: cvBuilder.convertYCoordinate(
                            top: 218,
                            elementHeight: 500,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 490,
                           height: 500),
            forType: .freeText,
            withProperties: nil
        )
        
        letterAnnotation.contents = "Hello, \(inity.coverLetterCompanyName ?? ""),\n\n\n\(inity.summary)\n\n\nAll the best,\n\(inity.firstname + " " + inity.lastname)"
        letterAnnotation.font = R.font.figtreeRegular(size: 12)!
        letterAnnotation.fontColor = .blackMain
        letterAnnotation.backgroundColor = .clear
        letterAnnotation.color = .clear
        page.addAnnotation(letterAnnotation)
        
        
        let siteAnnotation = PDFAnnotation(
            bounds: CGRect(x: 420,
                           y: cvBuilder.convertYCoordinate(
                            top: 760,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 200,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        
        siteAnnotation.contents = inity.site
        siteAnnotation.font = R.font.figtreeRegular(size: 12)!
        siteAnnotation.fontColor = .blackMain
        siteAnnotation.backgroundColor = .clear
        siteAnnotation.color = .clear
        page.addAnnotation(siteAnnotation)
        
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 420,
                           y: cvBuilder.convertYCoordinate(
                            top: 778,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = inity.phone
        emailAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 12)!
        emailAnnotation.fontColor = .blackMain
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        
        let phoneAnnotation = PDFAnnotation(
            bounds: CGRect(x: 420,
                           y: cvBuilder.convertYCoordinate(
                            top: 796,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 200,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneAnnotation.contents = inity.email
        phoneAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 12)!
        phoneAnnotation.fontColor = .blackMain
        phoneAnnotation.backgroundColor = .clear
        phoneAnnotation.color = .clear
        page.addAnnotation(phoneAnnotation)
        
        self.pdfDocument = pdfDoc
        
        exportPDF(document: pdfDoc)
    }
    
    private func overlayTextOnPDF1(cv: CVConstructor) {
        var inity = cv
        let workArray: [WorkExperienceInput] = inity.workExperience.reversed().map { input in
            return WorkExperienceInput(
                workStartedDate: input.workStartedDate,
                workEndedDate: input.workEndedDate,
                speciality: input.speciality,
                companyName: input.companyName,
                country: input.country,
                jobDescirption: input.jobDescirption
            )
        }
        
        let educationArray: [EducationInput] = inity.education.reversed().map { input in
            EducationInput(
                startedDate: input.startedDate,
                endedDate: input.endedDate,
                education: input.education,
                description: input.description
            )
        }
        
        
        inity.workExperience = workArray
        inity.education = educationArray
        
        guard let url = Bundle.main.url(forResource: R.file.template1Pdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load  pdf from bundle.")
            return
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return
        }
        
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
        
        //        if let imagePath = inity.profileImagePath {
        //            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //            let fileURL = documentsDirectory.appendingPathComponent(imagePath)
        //
        //            if FileManager.default.fileExists(atPath: fileURL.path) {
        //                if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
        //
        let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: UIImage(resource: .onb1) , properties: nil)
        
        page.addAnnotation(imageAnnotation)
        //                    print("Loaded image from: \(fileURL.path)")
        //                } else {
        //                    print("Failed to load image data from: \(fileURL.path)")
        //                }
        //            } else {
        //                print("No image found at: \(fileURL.path)")
        //            }
        //        }
        
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
        nameAnnotation.contents = inity.firstname + " " + inity.lastname
        nameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 21)!
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
        speciallityAnnotation.contents = inity.jobTitle
        speciallityAnnotation.font = R.font.figtreeBold.callAsFunction(size: 14.64)!
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
        phoneAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9.41)!
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
        emailAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9.41)!
        emailAnnotation.fontColor = .blackMain
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        let summaryTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 144.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        summaryTitleAnnotation.contents = "Summary"
        summaryTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 12)!
        summaryTitleAnnotation.fontColor = .blackMain
        summaryTitleAnnotation.backgroundColor = .clear
        summaryTitleAnnotation.color = .clear
        page.addAnnotation(summaryTitleAnnotation)
        
        let summaryAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 160.92,
                            elementHeight: 70,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 70),
            forType: .freeText,
            withProperties: nil
        )
        summaryAnnotation.contents = inity.summary
        summaryAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8.41)!
        summaryAnnotation.fontColor = .blackMain
        summaryAnnotation.backgroundColor = .clear
        summaryAnnotation.color = .clear
        page.addAnnotation(summaryAnnotation)
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 226.0,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        workExperienceTitleAnnotation.contents = "Work Experience"
        workExperienceTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 13.22)!
        workExperienceTitleAnnotation.fontColor = .blackMain
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        let baseY: CGFloat = 84.0
        let verticalSpacing: CGFloat = 140.0
        for (index, work) in inity.workExperience.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let jobTitleAnnotation = PDFAnnotation(
                bounds: CGRect(x: 70, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobTitleAnnotation.contents = work.speciality
            jobTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 9)!
            jobTitleAnnotation.fontColor = .blackMain
            jobTitleAnnotation.backgroundColor = .clear
            jobTitleAnnotation.color = .clear
            page.addAnnotation(jobTitleAnnotation)
            
            let companyAnnotation = PDFAnnotation(
                bounds: CGRect(x: 70, y: yPosition - 20, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            companyAnnotation.contents = work.companyName
            companyAnnotation.font = R.font.figtreeBold.callAsFunction(size: 10)!
            companyAnnotation.fontColor = .blackMain
            companyAnnotation.backgroundColor = .clear
            companyAnnotation.color = .clear
            page.addAnnotation(companyAnnotation)
            
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
            periodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            periodAnnotation.fontColor = .c595959
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            let locationAnnotation = PDFAnnotation(
                bounds: CGRect(x: 220, y: yPosition - 21, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            locationAnnotation.contents = work.country
            locationAnnotation.font = R.font.figtreeBold.callAsFunction(size: 8.41)!
            locationAnnotation.fontColor = .blackMain
            locationAnnotation.backgroundColor = .clear
            locationAnnotation.color = .clear
            page.addAnnotation(locationAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 76, y: yPosition - 86, width: 200, height: 70),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9.41)!
            leftDutiesAnnotation.fontColor = .c595959
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
        }
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 323.00,
                           y: cvBuilder.convertYCoordinate(top: 242.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 13.22)!
        educationTitleAnnotation.fontColor = .blackMain
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 230.0
        let educationSpacing: CGFloat = 95.0
        let educationBoxHeight: CGFloat = 72.0
        
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
            educationPeriodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
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
            educationNameAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 10)!
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
            descriptionAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            descriptionAnnotation.fontColor = .darkGray
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 323.00,
                           y: cvBuilder.convertYCoordinate(top: 470.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = R.string.localizable.skills()
        skillsTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 13.22)!
        skillsTitleAnnotation.fontColor = .blackMain
        skillsTitleAnnotation.backgroundColor = .clear
        skillsTitleAnnotation.color = .clear
        page.addAnnotation(skillsTitleAnnotation)
        
        let skillsBaseY: CGFloat = 460.0
        let skillsSpacing: CGFloat = 85.0
        let skillsBoxHeight: CGFloat = 70.0
        
        let yPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let ylPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let skillsDescAnnotation = PDFAnnotation(
            bounds: CGRect(x: 334, y: 160 - 35, width: 200, height: 200),
            forType: .freeText,
            withProperties: nil
        )
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        skillsDescAnnotation.fontColor = .darkGray
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 630,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 334, y: yllPosition - 5, width: 200, height: 20),
            forType: .freeText,
            withProperties: nil
        )
        langTitleAnnotation.contents = R.string.localizable.languages()
        langTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 10)!
        langTitleAnnotation.fontColor = .black
        langTitleAnnotation.backgroundColor = .clear
        langTitleAnnotation.color = .clear
        page.addAnnotation(langTitleAnnotation)
        
        
        let ylllPosition = cvBuilder.convertYCoordinate(
            top: 750,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        let langDescriptionAnnotation = PDFAnnotation(
            bounds: CGRect(x: 334, y: ylllPosition - 35, width: 200, height: 150),
            forType: .freeText,
            withProperties: nil
        )
        
        
        langDescriptionAnnotation.contents = inity.languages
            .flatMap { $0.name.components(separatedBy: ",") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: ", ")
        langDescriptionAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        langDescriptionAnnotation.fontColor = .darkGray
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        
        self.pdfDocument = pdfDoc
        
        exportPDF(document: pdfDoc)
    }
    
    private func overlayTextOnPDF2(cv: CVConstructor) {
        var inity = cv
        let workArray: [WorkExperienceInput] = inity.workExperience.reversed().map { input in
            return WorkExperienceInput(
                workStartedDate: input.workStartedDate,
                workEndedDate: input.workEndedDate,
                speciality: input.speciality,
                companyName: input.companyName,
                country: input.country,
                jobDescirption: input.jobDescirption
            )
        }.suffix(3)
        
        let educationArray: [EducationInput] = inity.education.reversed().map { input in
            EducationInput(
                startedDate: input.startedDate,
                endedDate: input.endedDate,
                education: input.education,
                description: input.description
            )
        }
        
        
        inity.workExperience = workArray
        inity.education = educationArray
        
        guard let url = Bundle.main.url(forResource: R.file.template2Pdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load  pdf from bundle.")
            return
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return
        }
        
        let imageFrame = CGRect(
            x: 40,
            y: cvBuilder.convertYCoordinate(
                top: 24,
                elementHeight: 65,
                pageHeight: cvBuilder.pageSize.height
            ),
            width: 65,
            height: 65
        )
        
        
        //        if let imagePath = inity.profileImagePath {
        //            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //            let fileURL = documentsDirectory.appendingPathComponent(imagePath)
        //
        //            if FileManager.default.fileExists(atPath: fileURL.path) {
        //                if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
        //
        let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: UIImage(resource: .onb1) , properties: nil, isCircle: true)
        
        page.addAnnotation(imageAnnotation)
        //                    print("Loaded image from: \(fileURL.path)")
        //                } else {
        //                    print("Failed to load image data from: \(fileURL.path)")
        //                }
        //            } else {
        //                print("No image found at: \(fileURL.path)")
        //            }
        //        }
        
        let speciallityAnnotation = PDFAnnotation(
            bounds: CGRect(x: 119.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 30,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        speciallityAnnotation.contents = inity.jobTitle
        speciallityAnnotation.font = R.font.figtreeRegular(size: 11)!
        speciallityAnnotation.fontColor = .blackMain
        speciallityAnnotation.backgroundColor = .clear
        speciallityAnnotation.color = .clear
        page.addAnnotation(speciallityAnnotation)
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 119,
                           y: cvBuilder.convertYCoordinate(
                            top: 53,
                            elementHeight: 50,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 50),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname
        nameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 25)!
        nameAnnotation.fontColor = .blackMain
        nameAnnotation.backgroundColor = .clear
        nameAnnotation.color = .clear
        page.addAnnotation(nameAnnotation)
        
        
        let contactsAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 120.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        contactsAnnotation.contents = "Contacts"
        contactsAnnotation.font = R.font.figtreeBold(size: 14)!
        contactsAnnotation.fontColor = .blackMain
        contactsAnnotation.backgroundColor = .clear
        contactsAnnotation.color = .clear
        page.addAnnotation(contactsAnnotation)
        
        
        let locationAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 146.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        locationAnnotation.contents = "•  " +  inity.location
        locationAnnotation.font = R.font.figtreeRegular(size: 11)!
        locationAnnotation.fontColor = .blackMain
        locationAnnotation.backgroundColor = .clear
        locationAnnotation.color = .clear
        page.addAnnotation(locationAnnotation)
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 170.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = "•  " + inity.email
        emailAnnotation.font = R.font.figtreeRegular(size: 11)!
        emailAnnotation.fontColor = .blackMain
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        
        let phoneAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 194.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneAnnotation.contents = "•  " + inity.phone
        phoneAnnotation.font = R.font.figtreeRegular(size: 11)!
        phoneAnnotation.fontColor = .blackMain
        phoneAnnotation.backgroundColor = .clear
        phoneAnnotation.color = .clear
        page.addAnnotation(phoneAnnotation)
        
        let siteAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 216.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 200,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        siteAnnotation.contents = "•  " +  inity.site
        siteAnnotation.font = R.font.figtreeRegular(size: 11)!
        siteAnnotation.fontColor = .blackMain
        siteAnnotation.backgroundColor = .clear
        siteAnnotation.color = .clear
        page.addAnnotation(siteAnnotation)
        
        
        
        let summaryTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 116.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        summaryTitleAnnotation.contents = "Summary"
        summaryTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 14)!
        summaryTitleAnnotation.fontColor = .blackMain
        summaryTitleAnnotation.backgroundColor = .clear
        summaryTitleAnnotation.color = .clear
        page.addAnnotation(summaryTitleAnnotation)
        
        let summaryAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 280.92,
                            elementHeight: 60,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 320,
                           height: 200),
            forType: .freeText,
            withProperties: nil
        )
        summaryAnnotation.contents = inity.summary
        summaryAnnotation.font = R.font.figtreeRegular(size: 10)!
        summaryAnnotation.fontColor = .blackMain
        summaryAnnotation.backgroundColor = .clear
        summaryAnnotation.color = .clear
        page.addAnnotation(summaryAnnotation)
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38,
                           y: cvBuilder.convertYCoordinate(top: 290.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 14)!
        educationTitleAnnotation.fontColor = .blackMain
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 272
        let educationSpacing: CGFloat = 55.0
        let educationBoxHeight: CGFloat = 72.0
        
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
                bounds: CGRect(x: 500, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationPeriodAnnotation.contents = "\(startDate) - \(endDate)"
            educationPeriodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            educationPeriodAnnotation.fontColor = .blackMain
            educationPeriodAnnotation.backgroundColor = .clear
            educationPeriodAnnotation.color = .clear
            page.addAnnotation(educationPeriodAnnotation)
            
            let educationNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationNameAnnotation.contents = edu.education
            educationNameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 11)!
            educationNameAnnotation.fontColor = .blackMain
            educationNameAnnotation.backgroundColor = .clear
            educationNameAnnotation.color = .clear
            page.addAnnotation(educationNameAnnotation)
            
            let descriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition - 30, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            descriptionAnnotation.contents = edu.description
            descriptionAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 10)!
            descriptionAnnotation.fontColor = .darkGray
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38,
                           y: cvBuilder.convertYCoordinate(
                            top: 440,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        workExperienceTitleAnnotation.contents = "Employment"
        workExperienceTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 13.22)!
        workExperienceTitleAnnotation.fontColor = .blackMain
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        let baseY: CGFloat = 300.0
        let verticalSpacing: CGFloat = 64.0
        for (index, work) in inity.workExperience.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let jobTitleAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobTitleAnnotation.contents = work.speciality + " at " + work.companyName
            jobTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 9)!
            jobTitleAnnotation.fontColor = .blackMain
            jobTitleAnnotation.backgroundColor = .clear
            jobTitleAnnotation.color = .clear
            page.addAnnotation(jobTitleAnnotation)
            
            
            let periodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 473, y: yPosition - 1, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: work.workStartedDate)
            let endDate = formatter.string(from: work.workEndedDate)
            periodAnnotation.contents = "\(startDate) - \(endDate)"
            periodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            periodAnnotation.fontColor = .c595959
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 37, y: yPosition - 90, width: 330, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .blackMain
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
        }
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40.00,
                           y: cvBuilder.convertYCoordinate(top: 684.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = "Skills"
        skillsTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 12)!
        skillsTitleAnnotation.fontColor = .blackMain
        skillsTitleAnnotation.backgroundColor = .clear
        skillsTitleAnnotation.color = .clear
        page.addAnnotation(skillsTitleAnnotation)
        
        let skillsBaseY: CGFloat = 840.0
        let skillsSpacing: CGFloat = 85.0
        let skillsBoxHeight: CGFloat = 70.0
        
        
        let ylPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let skillsDescAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40, y: ylPosition + 4, width: 330, height: 200),
            forType: .freeText,
            withProperties: nil
        )
        
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.figtreeRegular(size: 9)!
        skillsDescAnnotation.fontColor = .blackMain
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 630,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 400, y: yllPosition - 5, width: 200, height: 20),
            forType: .freeText,
            withProperties: nil
        )
        
        langTitleAnnotation.contents = "Languages"
        langTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 12)!
        langTitleAnnotation.fontColor = .blackMain
        langTitleAnnotation.backgroundColor = .clear
        langTitleAnnotation.color = .clear
        page.addAnnotation(langTitleAnnotation)
        
        
        let ylllPosition = cvBuilder.convertYCoordinate(
            top: 750,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        let langDescriptionAnnotation = PDFAnnotation(
            bounds: CGRect(x: 400, y: ylllPosition - 35, width: 180, height: 150),
            forType: .freeText,
            withProperties: nil
        )
        
        
        langDescriptionAnnotation.contents = inity.languages
            .flatMap { $0.name.components(separatedBy: ",") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: ", ")
        langDescriptionAnnotation.font = R.font.figtreeRegular(size: 9)!
        langDescriptionAnnotation.fontColor = .blackMain
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        
        self.pdfDocument = pdfDoc
        
        exportPDF(document: pdfDoc)
    }
    
    private func overlayTextOnPDF3(cv: CVConstructor) {
        var inity = cv
        let workArray: [WorkExperienceInput] = inity.workExperience.reversed().map { input in
            return WorkExperienceInput(
                workStartedDate: input.workStartedDate,
                workEndedDate: input.workEndedDate,
                speciality: input.speciality,
                companyName: input.companyName,
                country: input.country,
                jobDescirption: input.jobDescirption
            )
        }
        
        let educationArray: [EducationInput] = inity.education.reversed().map { input in
            EducationInput(
                startedDate: input.startedDate,
                endedDate: input.endedDate,
                education: input.education,
                description: input.description
            )
        }
        
        
        inity.workExperience = workArray
        inity.education = educationArray
        
        guard let url = Bundle.main.url(forResource: R.file.template3Pdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load  pdf from bundle.")
            return
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return
        }
        
        let speciallityAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 30.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        speciallityAnnotation.contents = inity.jobTitle
        speciallityAnnotation.font = R.font.figtreeRegular(size: 11)!
        speciallityAnnotation.fontColor = .blackMain
        speciallityAnnotation.backgroundColor = .clear
        speciallityAnnotation.color = .clear
        page.addAnnotation(speciallityAnnotation)
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 53.92,
                            elementHeight: 50,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 500,
                           height: 50),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname
        nameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 34)!
        nameAnnotation.fontColor = .blackMain
        nameAnnotation.backgroundColor = .clear
        nameAnnotation.color = .clear
        page.addAnnotation(nameAnnotation)
        
        
        let contactsAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 128.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        contactsAnnotation.contents = "Contacts"
        contactsAnnotation.font = R.font.figtreeBold(size: 13)!
        contactsAnnotation.fontColor = .blackMain
        contactsAnnotation.backgroundColor = .clear
        contactsAnnotation.color = .clear
        page.addAnnotation(contactsAnnotation)
        
        let locationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 152.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        locationTitleAnnotation.contents = "Address"
        locationTitleAnnotation.font = R.font.figtreeBold(size: 11)!
        locationTitleAnnotation.fontColor = .blackMain
        locationTitleAnnotation.backgroundColor = .clear
        locationTitleAnnotation.color = .clear
        page.addAnnotation(locationTitleAnnotation)
        
        let locationAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 170.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        locationAnnotation.contents = inity.location
        locationAnnotation.font = R.font.figtreeRegular(size: 11)!
        locationAnnotation.fontColor = .blackMain
        locationAnnotation.backgroundColor = .clear
        locationAnnotation.color = .clear
        page.addAnnotation(locationAnnotation)
        
        let emailTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380,
                           y: cvBuilder.convertYCoordinate(
                            top: 200.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailTitleAnnotation.contents = "Email"
        emailTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 11)!
        emailTitleAnnotation.fontColor = .blackMain
        emailTitleAnnotation.backgroundColor = .clear
        emailTitleAnnotation.color = .clear
        page.addAnnotation(emailTitleAnnotation)
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380,
                           y: cvBuilder.convertYCoordinate(
                            top: 220.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = inity.email
        emailAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9.41)!
        emailAnnotation.fontColor = .blackMain
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        let phoneTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 244.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneTitleAnnotation.contents = "Phone"
        phoneTitleAnnotation.font = R.font.figtreeBold(size: 11)!
        phoneTitleAnnotation.fontColor = .blackMain
        phoneTitleAnnotation.backgroundColor = .clear
        phoneTitleAnnotation.color = .clear
        page.addAnnotation(phoneTitleAnnotation)
        
        let phoneAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 262.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneAnnotation.contents = inity.phone
        phoneAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9.41)!
        phoneAnnotation.fontColor = .blackMain
        phoneAnnotation.backgroundColor = .clear
        phoneAnnotation.color = .clear
        page.addAnnotation(phoneAnnotation)
        
        
        let summaryTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38.0,
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
        summaryTitleAnnotation.contents = "Summary"
        summaryTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 14)!
        summaryTitleAnnotation.fontColor = .blackMain
        summaryTitleAnnotation.backgroundColor = .clear
        summaryTitleAnnotation.color = .clear
        page.addAnnotation(summaryTitleAnnotation)
        
        let summaryAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 290.92,
                            elementHeight: 60,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 320,
                           height: 200),
            forType: .freeText,
            withProperties: nil
        )
        summaryAnnotation.contents = inity.summary
        summaryAnnotation.font = R.font.figtreeRegular(size: 10)!
        summaryAnnotation.fontColor = .blackMain
        summaryAnnotation.backgroundColor = .clear
        summaryAnnotation.color = .clear
        page.addAnnotation(summaryAnnotation)
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38,
                           y: cvBuilder.convertYCoordinate(top: 300.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 14)!
        educationTitleAnnotation.fontColor = .blackMain
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 276
        let educationSpacing: CGFloat = 55.0
        let educationBoxHeight: CGFloat = 72.0
        
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
                bounds: CGRect(x: 288, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationPeriodAnnotation.contents = "\(startDate) - \(endDate)"
            educationPeriodAnnotation.font = R.font.figtreeRegular(size: 9)!
            educationPeriodAnnotation.fontColor = .darkGray
            educationPeriodAnnotation.backgroundColor = .clear
            educationPeriodAnnotation.color = .clear
            page.addAnnotation(educationPeriodAnnotation)
            
            let educationNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationNameAnnotation.contents = edu.education
            educationNameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 11)!
            educationNameAnnotation.fontColor = .black
            educationNameAnnotation.backgroundColor = .clear
            educationNameAnnotation.color = .clear
            page.addAnnotation(educationNameAnnotation)
            
            let descriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition - 30, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            descriptionAnnotation.contents = edu.description
            descriptionAnnotation.font = R.font.figtreeRegular(size: 10)!
            descriptionAnnotation.fontColor = .darkGray
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38,
                           y: cvBuilder.convertYCoordinate(
                            top: 440,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        workExperienceTitleAnnotation.contents = "Employment"
        workExperienceTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 13.22)!
        workExperienceTitleAnnotation.fontColor = .blackMain
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        let baseY: CGFloat = 300.0
        let verticalSpacing: CGFloat = 100.0
        for (index, work) in inity.workExperience.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let jobTitleAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobTitleAnnotation.contents = work.speciality + " at " + work.companyName
            jobTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 9)!
            jobTitleAnnotation.fontColor = .blackMain
            jobTitleAnnotation.backgroundColor = .clear
            jobTitleAnnotation.color = .clear
            page.addAnnotation(jobTitleAnnotation)
            
            
            let periodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 260, y: yPosition - 1, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: work.workStartedDate)
            let endDate = formatter.string(from: work.workEndedDate)
            periodAnnotation.contents = "\(startDate) - \(endDate)"
            periodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            periodAnnotation.fontColor = .c595959
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 37, y: yPosition - 90, width: 330, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .blackMain
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
        }
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.00,
                           y: cvBuilder.convertYCoordinate(top: 430.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = "Skills"
        skillsTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 13.22)!
        skillsTitleAnnotation.fontColor = .blackMain
        skillsTitleAnnotation.backgroundColor = .clear
        skillsTitleAnnotation.color = .clear
        page.addAnnotation(skillsTitleAnnotation)
        
        let skillsBaseY: CGFloat = 280.0
        let skillsSpacing: CGFloat = 85.0
        let skillsBoxHeight: CGFloat = 70.0
        
        let yPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let ylPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let skillsDescAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380, y: 220 - 35, width: 200, height: 200),
            forType: .freeText,
            withProperties: nil
        )
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        skillsDescAnnotation.fontColor = .blackMain
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 600,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380, y: yllPosition - 5, width: 200, height: 20),
            forType: .freeText,
            withProperties: nil
        )
        langTitleAnnotation.contents = "Languages"
        langTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 10)!
        langTitleAnnotation.fontColor = .blackMain
        langTitleAnnotation.backgroundColor = .clear
        langTitleAnnotation.color = .clear
        page.addAnnotation(langTitleAnnotation)
        
        
        let ylllPosition = cvBuilder.convertYCoordinate(
            top: 720,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        let langDescriptionAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380, y: ylllPosition - 35, width: 200, height: 150),
            forType: .freeText,
            withProperties: nil
        )
        
        
        langDescriptionAnnotation.contents = inity.languages
            .flatMap { $0.name.components(separatedBy: ",") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: ", ")
        langDescriptionAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        langDescriptionAnnotation.fontColor = .blackMain
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        
        self.pdfDocument = pdfDoc
        
        exportPDF(document: pdfDoc)
    }
    
    private func overlayTextOnPDF4(cv: CVConstructor) {
        var inity = cv
        let workArray: [WorkExperienceInput] = inity.workExperience.reversed().map { input in
            return WorkExperienceInput(
                workStartedDate: input.workStartedDate,
                workEndedDate: input.workEndedDate,
                speciality: input.speciality,
                companyName: input.companyName,
                country: input.country,
                jobDescirption: input.jobDescirption
            )
        }.suffix(3)
        
        let educationArray: [EducationInput] = inity.education.reversed().map { input in
            EducationInput(
                startedDate: input.startedDate,
                endedDate: input.endedDate,
                education: input.education,
                description: input.description
            )
        }
        
        
        inity.workExperience = workArray
        inity.education = educationArray
        
        guard let url = Bundle.main.url(forResource: R.file.template4Pdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load  pdf from bundle.")
            return
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return
        }
        
        let imageFrame = CGRect(
            x: 40,
            y: cvBuilder.convertYCoordinate(
                top: 24,
                elementHeight: 65,
                pageHeight: cvBuilder.pageSize.height
            ),
            width: 65,
            height: 65
        )
        
        
        //        if let imagePath = inity.profileImagePath {
        //            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //            let fileURL = documentsDirectory.appendingPathComponent(imagePath)
        //
        //            if FileManager.default.fileExists(atPath: fileURL.path) {
        //                if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
        //
        let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: UIImage(resource: .onb1) , properties: nil, isCircle: true)
        
        page.addAnnotation(imageAnnotation)
        //                    print("Loaded image from: \(fileURL.path)")
        //                } else {
        //                    print("Failed to load image data from: \(fileURL.path)")
        //                }
        //            } else {
        //                print("No image found at: \(fileURL.path)")
        //            }
        //        }
        
        let speciallityAnnotation = PDFAnnotation(
            bounds: CGRect(x: 119.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 30,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        speciallityAnnotation.contents = inity.jobTitle
        speciallityAnnotation.font = R.font.figtreeRegular(size: 11)!
        speciallityAnnotation.fontColor = .blackMain
        speciallityAnnotation.backgroundColor = .clear
        speciallityAnnotation.color = .clear
        page.addAnnotation(speciallityAnnotation)
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 119,
                           y: cvBuilder.convertYCoordinate(
                            top: 53,
                            elementHeight: 50,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 50),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname
        nameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 25)!
        nameAnnotation.fontColor = .blackMain
        nameAnnotation.backgroundColor = .clear
        nameAnnotation.color = .clear
        page.addAnnotation(nameAnnotation)
        
        
        let contactsAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 120.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        contactsAnnotation.contents = "Contacts"
        contactsAnnotation.font = R.font.figtreeBold(size: 14)!
        contactsAnnotation.fontColor = .blackMain
        contactsAnnotation.backgroundColor = .clear
        contactsAnnotation.color = .clear
        page.addAnnotation(contactsAnnotation)
        
        
        let locationAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 146.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        locationAnnotation.contents = "•  " +  inity.location
        locationAnnotation.font = R.font.figtreeRegular(size: 11)!
        locationAnnotation.fontColor = .blackMain
        locationAnnotation.backgroundColor = .clear
        locationAnnotation.color = .clear
        page.addAnnotation(locationAnnotation)
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 170.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = "•  " + inity.email
        emailAnnotation.font = R.font.figtreeRegular(size: 11)!
        emailAnnotation.fontColor = .blackMain
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        
        let phoneAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 194.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneAnnotation.contents = "•  " + inity.phone
        phoneAnnotation.font = R.font.figtreeRegular(size: 11)!
        phoneAnnotation.fontColor = .blackMain
        phoneAnnotation.backgroundColor = .clear
        phoneAnnotation.color = .clear
        page.addAnnotation(phoneAnnotation)
        
        let siteAnnotation = PDFAnnotation(
            bounds: CGRect(x: 380.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 216.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 200,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        siteAnnotation.contents = "•  " +  inity.site
        siteAnnotation.font = R.font.figtreeRegular(size: 11)!
        siteAnnotation.fontColor = .blackMain
        siteAnnotation.backgroundColor = .clear
        siteAnnotation.color = .clear
        page.addAnnotation(siteAnnotation)
        
        
        
        let summaryTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 116.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        summaryTitleAnnotation.contents = "Summary"
        summaryTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 14)!
        summaryTitleAnnotation.fontColor = .blackMain
        summaryTitleAnnotation.backgroundColor = .clear
        summaryTitleAnnotation.color = .clear
        page.addAnnotation(summaryTitleAnnotation)
        
        let summaryAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 280.92,
                            elementHeight: 60,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 320,
                           height: 200),
            forType: .freeText,
            withProperties: nil
        )
        summaryAnnotation.contents = inity.summary
        summaryAnnotation.font = R.font.figtreeRegular(size: 10)!
        summaryAnnotation.fontColor = .blackMain
        summaryAnnotation.backgroundColor = .clear
        summaryAnnotation.color = .clear
        page.addAnnotation(summaryAnnotation)
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38,
                           y: cvBuilder.convertYCoordinate(top: 290.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 14)!
        educationTitleAnnotation.fontColor = .blackMain
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 272
        let educationSpacing: CGFloat = 55.0
        let educationBoxHeight: CGFloat = 72.0
        
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
                bounds: CGRect(x: 500, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationPeriodAnnotation.contents = "\(startDate) - \(endDate)"
            educationPeriodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            educationPeriodAnnotation.fontColor = .blackMain
            educationPeriodAnnotation.backgroundColor = .clear
            educationPeriodAnnotation.color = .clear
            page.addAnnotation(educationPeriodAnnotation)
            
            let educationNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationNameAnnotation.contents = edu.education
            educationNameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 11)!
            educationNameAnnotation.fontColor = .blackMain
            educationNameAnnotation.backgroundColor = .clear
            educationNameAnnotation.color = .clear
            page.addAnnotation(educationNameAnnotation)
            
            let descriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition - 30, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            descriptionAnnotation.contents = edu.description
            descriptionAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 10)!
            descriptionAnnotation.fontColor = .darkGray
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38,
                           y: cvBuilder.convertYCoordinate(
                            top: 440,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        workExperienceTitleAnnotation.contents = "Employment"
        workExperienceTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 13.22)!
        workExperienceTitleAnnotation.fontColor = .blackMain
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        let baseY: CGFloat = 300.0
        let verticalSpacing: CGFloat = 64.0
        for (index, work) in inity.workExperience.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let jobTitleAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobTitleAnnotation.contents = work.speciality + " at " + work.companyName
            jobTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 9)!
            jobTitleAnnotation.fontColor = .blackMain
            jobTitleAnnotation.backgroundColor = .clear
            jobTitleAnnotation.color = .clear
            page.addAnnotation(jobTitleAnnotation)
            
            
            let periodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 473, y: yPosition - 1, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: work.workStartedDate)
            let endDate = formatter.string(from: work.workEndedDate)
            periodAnnotation.contents = "\(startDate) - \(endDate)"
            periodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            periodAnnotation.fontColor = .c595959
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 37, y: yPosition - 90, width: 330, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .blackMain
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
        }
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40.00,
                           y: cvBuilder.convertYCoordinate(top: 684.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = "Skills"
        skillsTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 12)!
        skillsTitleAnnotation.fontColor = .blackMain
        skillsTitleAnnotation.backgroundColor = .clear
        skillsTitleAnnotation.color = .clear
        page.addAnnotation(skillsTitleAnnotation)
        
        let skillsBaseY: CGFloat = 840.0
        let skillsSpacing: CGFloat = 85.0
        let skillsBoxHeight: CGFloat = 70.0
        
        
        let ylPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let skillsDescAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40, y: ylPosition + 4, width: 330, height: 200),
            forType: .freeText,
            withProperties: nil
        )
        
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.figtreeRegular(size: 9)!
        skillsDescAnnotation.fontColor = .blackMain
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 630,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 400, y: yllPosition - 5, width: 200, height: 20),
            forType: .freeText,
            withProperties: nil
        )
        
        langTitleAnnotation.contents = "Languages"
        langTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 12)!
        langTitleAnnotation.fontColor = .blackMain
        langTitleAnnotation.backgroundColor = .clear
        langTitleAnnotation.color = .clear
        page.addAnnotation(langTitleAnnotation)
        
        
        let ylllPosition = cvBuilder.convertYCoordinate(
            top: 750,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        let langDescriptionAnnotation = PDFAnnotation(
            bounds: CGRect(x: 400, y: ylllPosition - 35, width: 180, height: 150),
            forType: .freeText,
            withProperties: nil
        )
        
        
        langDescriptionAnnotation.contents = inity.languages
            .flatMap { $0.name.components(separatedBy: ",") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: ", ")
        langDescriptionAnnotation.font = R.font.figtreeRegular(size: 9)!
        langDescriptionAnnotation.fontColor = .blackMain
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        
        self.pdfDocument = pdfDoc
        
        exportPDF(document: pdfDoc)
    }
    
    
    private func overlayTextOnPDF5(cv: CVConstructor) {
        var inity = cv
        let workArray: [WorkExperienceInput] = inity.workExperience.reversed().map { input in
            return WorkExperienceInput(
                workStartedDate: input.workStartedDate,
                workEndedDate: input.workEndedDate,
                speciality: input.speciality,
                companyName: input.companyName,
                country: input.country,
                jobDescirption: input.jobDescirption
            )
        }
        
        let educationArray: [EducationInput] = inity.education.reversed().map { input in
            EducationInput(
                startedDate: input.startedDate,
                endedDate: input.endedDate,
                education: input.education,
                description: input.description
            )
        }
        
        inity.workExperience = workArray
        inity.education = educationArray
        
        guard let url = Bundle.main.url(forResource: R.file.template5Pdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load  pdf from bundle.")
            return
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return
        }
        
        let imageFrame = CGRect(
            x: 45,
            y: cvBuilder.convertYCoordinate(
                top: 32,
                elementHeight: 76,
                pageHeight: cvBuilder.pageSize.height
            ),
            width: 76,
            height: 76
        )
        
        //        if let imagePath = inity.profileImagePath {
        //            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //            let fileURL = documentsDirectory.appendingPathComponent(imagePath)
        //
        //            if FileManager.default.fileExists(atPath: fileURL.path) {
        //                if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
        //
        let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: UIImage(resource: .onb1) , properties: nil, isCircle: true)
        
        page.addAnnotation(imageAnnotation)
        //                    print("Loaded image from: \(fileURL.path)")
        //                } else {
        //                    print("Failed to load image data from: \(fileURL.path)")
        //                }
        //            } else {
        //                print("No image found at: \(fileURL.path)")
        //            }
        //        }
        
        
        let locationAnnotation = PDFAnnotation(
            bounds: CGRect(x: 208,
                           y: cvBuilder.convertYCoordinate(
                            top: 30,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        locationAnnotation.contents = inity.location
        locationAnnotation.font = R.font.figtreeRegular(size: 8)!
        locationAnnotation.fontColor = .blackMain
        locationAnnotation.backgroundColor = .clear
        locationAnnotation.color = .clear
        page.addAnnotation(locationAnnotation)
        
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 208,
                           y: cvBuilder.convertYCoordinate(
                            top: 44,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = inity.phone + " " + inity.email
        emailAnnotation.font = R.font.figtreeRegular(size: 8)!
        emailAnnotation.fontColor = .blackMain
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 208,
                           y: cvBuilder.convertYCoordinate(
                            top: 78,
                            elementHeight: 50,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 50),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname + ", " + inity.jobTitle
        nameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 15)!
        nameAnnotation.fontColor = .blackMain
        
        nameAnnotation.backgroundColor = .clear
        nameAnnotation.color = .clear
        page.addAnnotation(nameAnnotation)
        
        let summaryAnnotation = PDFAnnotation(
            bounds: CGRect(x: 208,
                           y: cvBuilder.convertYCoordinate(
                            top: 240.92,
                            elementHeight: 60,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 380,
                           height: 200),
            forType: .freeText,
            withProperties: nil
        )
        summaryAnnotation.contents = inity.summary
        summaryAnnotation.font = R.font.figtreeRegular(size: 11)!
        summaryAnnotation.fontColor = .blackMain70
        summaryAnnotation.backgroundColor = .clear
        summaryAnnotation.color = .clear
        page.addAnnotation(summaryAnnotation)
        
        let experienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40,
                           y: cvBuilder.convertYCoordinate(top: 240.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        experienceTitleAnnotation.contents = "Experience"
        experienceTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 11)!
        experienceTitleAnnotation.fontColor = .blackMain50
        experienceTitleAnnotation.backgroundColor = .clear
        experienceTitleAnnotation.color = .clear
        page.addAnnotation(experienceTitleAnnotation)
        
        let baseY: CGFloat = 72
        let verticalSpacing: CGFloat = 76.0
        for (index, work) in inity.workExperience.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let jobTitleAnnotation = PDFAnnotation(
                bounds: CGRect(x: 208, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobTitleAnnotation.contents = work.speciality + ",  " + work.companyName
            jobTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 10)!
            jobTitleAnnotation.fontColor = .blackMain
            jobTitleAnnotation.backgroundColor = .clear
            jobTitleAnnotation.color = .clear
            page.addAnnotation(jobTitleAnnotation)
            
            
            let jobLocationAnnotation = PDFAnnotation(
                bounds: CGRect(x: 520, y: yPosition - 16, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobLocationAnnotation.contents = work.country
            jobLocationAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            jobLocationAnnotation.fontColor = .blackMain
            jobLocationAnnotation.backgroundColor = .clear
            jobLocationAnnotation.color = .clear
            page.addAnnotation(jobLocationAnnotation)
            
            let periodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 208, y: yPosition - 16, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: work.workStartedDate)
            let endDate = formatter.string(from: work.workEndedDate)
            periodAnnotation.contents = "\(startDate) - \(endDate)"
            periodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            periodAnnotation.fontColor = .blackMain70
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 208, y: yPosition - 100, width: 330, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .c3333333
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
        }
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40,
                           y: cvBuilder.convertYCoordinate(top: 560.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 11)!
        educationTitleAnnotation.fontColor = .blackMain50
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        
        let educationBaseY: CGFloat = 510
        let educationSpacing: CGFloat = 50.0
        let educationBoxHeight: CGFloat = 72.0
        
        for (index, edu) in inity.education.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: educationBaseY + CGFloat(index) * educationSpacing,
                elementHeight: educationBoxHeight,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: edu.startedDate)
            let endDate = formatter.string(from: edu.endedDate)
            let period = "\(startDate) - \(endDate)"
            
            
            let educationNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 208, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationNameAnnotation.contents = edu.education
            educationNameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 10)!
            educationNameAnnotation.fontColor = .blackMain
            educationNameAnnotation.backgroundColor = .clear
            educationNameAnnotation.color = .clear
            page.addAnnotation(educationNameAnnotation)
            
            let descriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 208, y: yPosition - 30, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            descriptionAnnotation.contents = edu.description +  ",  " + period
            descriptionAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 10)!
            descriptionAnnotation.fontColor = .blackMain50
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        let skillsBaseY: CGFloat = 800.0
        let skillsSpacing: CGFloat = 85.0
        let skillsBoxHeight: CGFloat = 70.0
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 606,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40, y: yllPosition, width: 200, height: 20),
            forType: .freeText,
            withProperties: nil
        )
        
        langTitleAnnotation.contents = "Languages"
        langTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 11)!
        langTitleAnnotation.fontColor = .blackMain50
        langTitleAnnotation.backgroundColor = .clear
        langTitleAnnotation.color = .clear
        page.addAnnotation(langTitleAnnotation)
        
        
        let ylllPosition = cvBuilder.convertYCoordinate(
            top: 736,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        let langDescriptionAnnotation = PDFAnnotation(
            bounds: CGRect(x: 208, y: ylllPosition, width: 360, height: 150),
            forType: .freeText,
            withProperties: nil
        )
        
        
        langDescriptionAnnotation.contents = inity.languages
            .flatMap { $0.name.components(separatedBy: ",") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: "  |  ")
        langDescriptionAnnotation.font = R.font.figtreeRegular(size: 9)!
        langDescriptionAnnotation.fontColor = .blackMain
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40.00,
                           y: cvBuilder.convertYCoordinate(top: 700.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = "Skills"
        skillsTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 11)!
        skillsTitleAnnotation.fontColor = .blackMain50
        skillsTitleAnnotation.backgroundColor = .clear
        skillsTitleAnnotation.color = .clear
        page.addAnnotation(skillsTitleAnnotation)
        
        let ylPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let skillsDescAnnotation = PDFAnnotation(
            bounds: CGRect(x: 208, y: ylPosition - 30, width: 330, height: 200),
            forType: .freeText,
            withProperties: nil
        )
        
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }
            .joined(separator: "  |  ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.figtreeRegular(size: 9)!
        skillsDescAnnotation.fontColor = .blackMain
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        
        let siteTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40.00,
                           y: cvBuilder.convertYCoordinate(top: 793.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        siteTitleAnnotation.contents = "Link"
        siteTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 11)!
        siteTitleAnnotation.fontColor = .blackMain50
        siteTitleAnnotation.backgroundColor = .clear
        siteTitleAnnotation.color = .clear
        page.addAnnotation(siteTitleAnnotation)
        
        let siteAnnotation = PDFAnnotation(
            bounds: CGRect(x: 208,
                           y: cvBuilder.convertYCoordinate(
                            top: 793.0,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 200,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        siteAnnotation.contents =  inity.site
        siteAnnotation.font = R.font.figtreeRegular(size: 9)!
        siteAnnotation.fontColor = .blackMain
        siteAnnotation.backgroundColor = .clear
        siteAnnotation.color = .clear
        page.addAnnotation(siteAnnotation)
        
        self.pdfDocument = pdfDoc
        
        exportPDF(document: pdfDoc)
    }
    
    private func overlayTextOnPDF6(cv: CVConstructor) {
        var inity = cv
        let workArray: [WorkExperienceInput] = inity.workExperience.reversed().map { input in
            return WorkExperienceInput(
                workStartedDate: input.workStartedDate,
                workEndedDate: input.workEndedDate,
                speciality: input.speciality,
                companyName: input.companyName,
                country: input.country,
                jobDescirption: input.jobDescirption
            )
        }
        
        let educationArray: [EducationInput] = inity.education.reversed().map { input in
            EducationInput(
                startedDate: input.startedDate,
                endedDate: input.endedDate,
                education: input.education,
                description: input.description
            )
        }
        
        
        inity.workExperience = workArray
        inity.education = educationArray
        
        guard let url = Bundle.main.url(forResource: R.file.template6Pdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load  pdf from bundle.")
            return
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return
        }
        
        let imageFrame = CGRect(
            x: 40,
            y: cvBuilder.convertYCoordinate(
                top: 40,
                elementHeight: 56,
                pageHeight: cvBuilder.pageSize.height
            ),
            width: 56,
            height: 56
        )
        
        
        
        //        if let imagePath = inity.profileImagePath {
        //            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //            let fileURL = documentsDirectory.appendingPathComponent(imagePath)
        //
        //            if FileManager.default.fileExists(atPath: fileURL.path) {
        //                if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
        //
        let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: UIImage(resource: .onb1) , properties: nil, isCircle: true)
        
        page.addAnnotation(imageAnnotation)
        //                    print("Loaded image from: \(fileURL.path)")
        //                } else {
        //                    print("Failed to load image data from: \(fileURL.path)")
        //                }
        //            } else {
        //                print("No image found at: \(fileURL.path)")
        //            }
        //        }
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 111,
                           y: cvBuilder.convertYCoordinate(
                            top: 50,
                            elementHeight: 50,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 50),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname
        nameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 20)!
        nameAnnotation.fontColor = .blackMain
        nameAnnotation.backgroundColor = .clear
        nameAnnotation.color = .clear
        page.addAnnotation(nameAnnotation)
        
        
        
        let speciallityAnnotation = PDFAnnotation(
            bounds: CGRect(x: 111,
                           y: cvBuilder.convertYCoordinate(
                            top: 75,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        speciallityAnnotation.contents = inity.jobTitle
        speciallityAnnotation.font = R.font.figtreeRegular(size: 10)!
        speciallityAnnotation.fontColor = .blackMain
        speciallityAnnotation.backgroundColor = .clear
        speciallityAnnotation.color = .clear
        page.addAnnotation(speciallityAnnotation)
        
        
        
        let contactsAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(
                            top: 40,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        contactsAnnotation.contents = "Details"
        contactsAnnotation.font = R.font.figtreeBold(size: 15)!
        contactsAnnotation.fontColor = .blackMain
        contactsAnnotation.backgroundColor = .clear
        contactsAnnotation.color = .clear
        page.addAnnotation(contactsAnnotation)
        
        let locationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(
                            top: 73,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        locationTitleAnnotation.contents = "Address"
        locationTitleAnnotation.font = R.font.figtreeBold(size: 11)!
        locationTitleAnnotation.fontColor = .blackMain
        locationTitleAnnotation.backgroundColor = .clear
        locationTitleAnnotation.color = .clear
        page.addAnnotation(locationTitleAnnotation)
        
        
        
        let locationAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(
                            top: 90,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        locationAnnotation.contents = inity.location
        locationAnnotation.font = R.font.figtreeRegular(size: 9)!
        locationAnnotation.fontColor = .blackMain
        locationAnnotation.backgroundColor = .clear
        locationAnnotation.color = .clear
        page.addAnnotation(locationAnnotation)
        
        
        let phoneTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(
                            top: 112,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneTitleAnnotation.contents = "Phone"
        phoneTitleAnnotation.font = R.font.figtreeBold(size: 11)!
        phoneTitleAnnotation.fontColor = .blackMain
        phoneTitleAnnotation.backgroundColor = .clear
        phoneTitleAnnotation.color = .clear
        page.addAnnotation(phoneTitleAnnotation)
        
        let phoneAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(
                            top: 128,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 100,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneAnnotation.contents = inity.phone
        phoneAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9.41)!
        phoneAnnotation.fontColor = .blackMain
        phoneAnnotation.backgroundColor = .clear
        phoneAnnotation.color = .clear
        page.addAnnotation(phoneAnnotation)
        
        let emailTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(
                            top: 148,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailTitleAnnotation.contents = "Email"
        emailTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 11)!
        emailTitleAnnotation.fontColor = .blackMain
        emailTitleAnnotation.backgroundColor = .clear
        emailTitleAnnotation.color = .clear
        page.addAnnotation(emailTitleAnnotation)
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(
                            top: 166,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = inity.email
        emailAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9.41)!
        emailAnnotation.fontColor = .blackMain
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        let linksTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(
                            top: 220,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        linksTitleAnnotation.contents = "Link"
        linksTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 15)!
        linksTitleAnnotation.fontColor = .blackMain
        linksTitleAnnotation.backgroundColor = .clear
        linksTitleAnnotation.color = .clear
        page.addAnnotation(linksTitleAnnotation)
        
        
        
        let linkAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(
                            top: 250,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        linkAnnotation.contents = inity.site
        linkAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9.41)!
        linkAnnotation.fontColor = .blackMain
        linkAnnotation.backgroundColor = .clear
        linkAnnotation.color = .clear
        page.addAnnotation(linkAnnotation)
        
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(top: 300.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = "Skills"
        skillsTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 15)!
        skillsTitleAnnotation.fontColor = .blackMain
        skillsTitleAnnotation.backgroundColor = .clear
        skillsTitleAnnotation.color = .clear
        page.addAnnotation(skillsTitleAnnotation)
        
        let skillsBaseY: CGFloat = 310.0
        let skillsSpacing: CGFloat = 85.0
        let skillsBoxHeight: CGFloat = 70.0
        
        let yPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let ylPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let skillsDescAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434, y: 214, width: 150, height: 300),
            forType: .freeText,
            withProperties: nil
        )
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        skillsDescAnnotation.fontColor = .blackMain
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 545,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434, y: yllPosition - 5, width: 200, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        langTitleAnnotation.contents =  "Languages"
        langTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 15)!
        langTitleAnnotation.fontColor = .blackMain
        langTitleAnnotation.backgroundColor = .clear
        langTitleAnnotation.color = .clear
        page.addAnnotation(langTitleAnnotation)
        
        
        let ylllPosition = cvBuilder.convertYCoordinate(
            top: 700,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        let langDescriptionAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434, y: ylllPosition , width: 150, height: 150),
            forType: .freeText,
            withProperties: nil
        )
        
        
        langDescriptionAnnotation.contents = inity.languages
            .flatMap { $0.name.components(separatedBy: ",") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: ", ")
        langDescriptionAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        langDescriptionAnnotation.fontColor = .blackMain
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        
        
        
        let summaryTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40,
                           y: cvBuilder.convertYCoordinate(
                            top: 110.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        summaryTitleAnnotation.contents = "Profile"
        summaryTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 15)!
        summaryTitleAnnotation.fontColor = .blackMain
        summaryTitleAnnotation.backgroundColor = .clear
        summaryTitleAnnotation.color = .clear
        page.addAnnotation(summaryTitleAnnotation)
        
        let summaryAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40,
                           y: cvBuilder.convertYCoordinate(
                            top: 270.92,
                            elementHeight: 60,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 320,
                           height: 200),
            forType: .freeText,
            withProperties: nil
        )
        summaryAnnotation.contents = inity.summary
        summaryAnnotation.font = R.font.figtreeRegular(size: 9)!
        summaryAnnotation.fontColor = .blackMain70
        summaryAnnotation.backgroundColor = .clear
        summaryAnnotation.color = .clear
        page.addAnnotation(summaryAnnotation)
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40,
                           y: cvBuilder.convertYCoordinate(
                            top: 254,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        workExperienceTitleAnnotation.contents = "Experience"
        workExperienceTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 15)!
        workExperienceTitleAnnotation.fontColor = .blackMain
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        let baseY: CGFloat = 114.0
        let verticalSpacing: CGFloat = 110.0
        for (index, work) in inity.workExperience.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let jobNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 40, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobNameAnnotation.contents = work.companyName
            jobNameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 10)!
            jobNameAnnotation.fontColor = .blackMain
            jobNameAnnotation.backgroundColor = .clear
            jobNameAnnotation.color = .clear
            page.addAnnotation(jobNameAnnotation)
            
            
            let jobTitleAnnotation = PDFAnnotation(
                bounds: CGRect(x: 40, y: yPosition - 20, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobTitleAnnotation.contents = work.speciality
            jobTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            jobTitleAnnotation.fontColor = .blackMain
            jobTitleAnnotation.backgroundColor = .clear
            jobTitleAnnotation.color = .clear
            page.addAnnotation(jobTitleAnnotation)
            
            
            let periodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 40, y: yPosition - 40, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: work.workStartedDate)
            let endDate = formatter.string(from: work.workEndedDate)
            periodAnnotation.contents = "\(startDate) - \(endDate)"
            periodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            periodAnnotation.fontColor = .blackMain70
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            
            let locationAnnotation = PDFAnnotation(
                bounds: CGRect(x: 300, y: yPosition - 40, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            locationAnnotation.contents = work.country
            locationAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            locationAnnotation.fontColor = .blackMain70
            locationAnnotation.backgroundColor = .clear
            locationAnnotation.color = .clear
            page.addAnnotation(locationAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 40, y: yPosition - 130, width: 330, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .c3333333
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
        }
        
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38,
                           y: cvBuilder.convertYCoordinate(top: 740, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.figtreeBold.callAsFunction(size: 14)!
        educationTitleAnnotation.fontColor = .blackMain
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 710
        let educationSpacing: CGFloat = 35.0
        let educationBoxHeight: CGFloat = 72.0
        
        for (index, edu) in inity.education.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: educationBaseY + CGFloat(index) * educationSpacing,
                elementHeight: educationBoxHeight,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: edu.startedDate)
            let endDate = formatter.string(from: edu.endedDate)
            
            
            let educationNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationNameAnnotation.contents = edu.education
            educationNameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 11)!
            educationNameAnnotation.fontColor = .black
            educationNameAnnotation.backgroundColor = .clear
            educationNameAnnotation.color = .clear
            page.addAnnotation(educationNameAnnotation)
            
            let descriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 38, y: yPosition - 30, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            descriptionAnnotation.contents = edu.description + ", " + "\(startDate) - \(endDate)"
            descriptionAnnotation.font = R.font.figtreeRegular(size: 10)!
            descriptionAnnotation.fontColor = .blackMain70
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        
        self.pdfDocument = pdfDoc
        
        exportPDF(document: pdfDoc)
    }
    
    
    private func overlayTextOnPDF7(cv: CVConstructor) {
        var inity = cv
        let workArray: [WorkExperienceInput] = inity.workExperience.reversed().map { input in
            return WorkExperienceInput(
                workStartedDate: input.workStartedDate,
                workEndedDate: input.workEndedDate,
                speciality: input.speciality,
                companyName: input.companyName,
                country: input.country,
                jobDescirption: input.jobDescirption
            )
        }
        
        let educationArray: [EducationInput] = inity.education.reversed().map { input in
            EducationInput(
                startedDate: input.startedDate,
                endedDate: input.endedDate,
                education: input.education,
                description: input.description
            )
        }.suffix(3)
        
        
        inity.workExperience = workArray
        inity.education = educationArray
        
        guard let url = Bundle.main.url(forResource: R.file.template7Pdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load  pdf from bundle.")
            return
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return
        }
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 208,
                           y: cvBuilder.convertYCoordinate(
                            top: 31,
                            elementHeight: 200,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 400,
                           height: 200),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname + ",  " + inity.jobTitle
        nameAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 39)!
        nameAnnotation.fontColor = .white
        nameAnnotation.backgroundColor = .clear
        nameAnnotation.color = .clear
        page.addAnnotation(nameAnnotation)
        
        let contactsAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 54,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 180,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        contactsAnnotation.contents = "Contacts"
        contactsAnnotation.font = R.font.figtreeRegular(size: 15)!
        contactsAnnotation.fontColor = .white
        contactsAnnotation.backgroundColor = .clear
        contactsAnnotation.color = .clear
        page.addAnnotation(contactsAnnotation)
        
        let locationAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 90,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 160,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        locationAnnotation.contents = inity.site
        locationAnnotation.font = R.font.figtreeRegular(size: 9)!
        locationAnnotation.fontColor = .white
        locationAnnotation.backgroundColor = .clear
        locationAnnotation.color = .clear
        page.addAnnotation(locationAnnotation)
        
        
        let phoneAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 110,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 200,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneAnnotation.contents = inity.email
        phoneAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        phoneAnnotation.fontColor = .white
        phoneAnnotation.backgroundColor = .clear
        phoneAnnotation.color = .clear
        page.addAnnotation(phoneAnnotation)
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 130,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = inity.phone
        emailAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9 )!
        emailAnnotation.fontColor = .white
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 402,
                           y: cvBuilder.convertYCoordinate(top: 140.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = "Skills"
        skillsTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 15)!
        skillsTitleAnnotation.fontColor = .white
        skillsTitleAnnotation.backgroundColor = .clear
        skillsTitleAnnotation.color = .clear
        page.addAnnotation(skillsTitleAnnotation)
        
        let skillsBaseY: CGFloat = 40.0
        let skillsSpacing: CGFloat = 85.0
        let skillsBoxHeight: CGFloat = 70.0
        
        let yPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let ylPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let skillsDescAnnotation = PDFAnnotation(
            bounds: CGRect(x: 420, y: cvBuilder.convertYCoordinate(top: 324, elementHeight: 150, pageHeight: cvBuilder.pageSize.height), width: 150, height: 300),
            forType: .freeText,
            withProperties: nil
        )
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        skillsDescAnnotation.fontColor = .white
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 270,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 402, y: yllPosition, width: 200, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        langTitleAnnotation.contents =  "Languages"
        langTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 15)!
        langTitleAnnotation.fontColor = .white
        langTitleAnnotation.backgroundColor = .clear
        langTitleAnnotation.color = .clear
        page.addAnnotation(langTitleAnnotation)
        
        
        let ylllPosition = cvBuilder.convertYCoordinate(
            top: 430,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        let langDescriptionAnnotation = PDFAnnotation(
            bounds: CGRect(x: 420, y: ylllPosition , width: 150, height: 150),
            forType: .freeText,
            withProperties: nil
        )
        
        
        langDescriptionAnnotation.contents = inity.languages
            .flatMap { $0.name.components(separatedBy: ",") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: ", ")
        langDescriptionAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        langDescriptionAnnotation.fontColor = .white
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 210,
                           y: cvBuilder.convertYCoordinate(
                            top: 140,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        
        workExperienceTitleAnnotation.contents = "Experience"
        workExperienceTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 14)!
        workExperienceTitleAnnotation.fontColor = .white
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        let baseY: CGFloat = 10.0
        let verticalSpacing: CGFloat = 120.0
        for (index, work) in inity.workExperience.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let jobNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition - 20, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobNameAnnotation.contents = work.companyName
            jobNameAnnotation.font = R.font.figtreeSemiBold.callAsFunction(size: 12)!
            jobNameAnnotation.fontColor = .white
            jobNameAnnotation.backgroundColor = .clear
            jobNameAnnotation.color = .clear
            page.addAnnotation(jobNameAnnotation)
            
            
            let periodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: work.workStartedDate)
            let endDate = formatter.string(from: work.workEndedDate)
            periodAnnotation.contents = "\(startDate) - \(endDate)"
            periodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            periodAnnotation.fontColor = .white
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            
            let locationAnnotation = PDFAnnotation(
                bounds: CGRect(x: 340, y: yPosition , width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            locationAnnotation.contents = work.country
            locationAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            locationAnnotation.fontColor = .white
            locationAnnotation.backgroundColor = .clear
            locationAnnotation.color = .clear
            page.addAnnotation(locationAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition - 110, width: 200, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .white
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
        }
        
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 210,
                           y: cvBuilder.convertYCoordinate(top: 670, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 14)!
        educationTitleAnnotation.fontColor = .white
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 650
        let educationSpacing: CGFloat = 55.0
        let educationBoxHeight: CGFloat = 72.0
        
        for (index, edu) in inity.education.enumerated() {
            
            let yPosition = cvBuilder.convertYCoordinate(
                top: educationBaseY + CGFloat(index) * educationSpacing,
                elementHeight: educationBoxHeight,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: edu.startedDate)
            let endDate = formatter.string(from: edu.endedDate)
            
            let dateAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            dateAnnotation.contents = "\(startDate) - \(endDate)"
            dateAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            dateAnnotation.fontColor = .white
            dateAnnotation.backgroundColor = .clear
            dateAnnotation.color = .clear
            page.addAnnotation(dateAnnotation)
            
            
            let educationNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition - 14, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationNameAnnotation.contents = edu.education
            educationNameAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 11)!
            educationNameAnnotation.fontColor = .white
            educationNameAnnotation.backgroundColor = .clear
            educationNameAnnotation.color = .clear
            page.addAnnotation(educationNameAnnotation)
            
            let descriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition - 42, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            descriptionAnnotation.contents = edu.description
            descriptionAnnotation.font = R.font.figtreeRegular(size: 10)!
            descriptionAnnotation.fontColor = .white
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        
        self.pdfDocument = pdfDoc
        
        exportPDF(document: pdfDoc)
    }
    
    
    private func overlayTextOnPDF8(cv: CVConstructor) {
        var inity = cv
        let workArray: [WorkExperienceInput] = inity.workExperience.reversed().map { input in
            return WorkExperienceInput(
                workStartedDate: input.workStartedDate,
                workEndedDate: input.workEndedDate,
                speciality: input.speciality,
                companyName: input.companyName,
                country: input.country,
                jobDescirption: input.jobDescirption
            )
        }
        
        let educationArray: [EducationInput] = inity.education.reversed().map { input in
            EducationInput(
                startedDate: input.startedDate,
                endedDate: input.endedDate,
                education: input.education,
                description: input.description
            )
        }.suffix(3)
        
        
        inity.workExperience = workArray
        inity.education = educationArray
        
        guard let url = Bundle.main.url(forResource: R.file.template8Pdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load  pdf from bundle.")
            return
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return
        }
        
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 208,
                           y: cvBuilder.convertYCoordinate(
                            top: 31,
                            elementHeight: 200,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 400,
                           height: 200),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname + ",  " + inity.jobTitle
        nameAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 39)!
        nameAnnotation.fontColor = .blackMain
        nameAnnotation.backgroundColor = .clear
        nameAnnotation.color = .clear
        page.addAnnotation(nameAnnotation)
        
        let contactsAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 54,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 180,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        contactsAnnotation.contents = "Contacts"
        contactsAnnotation.font = R.font.figtreeRegular(size: 15)!
        contactsAnnotation.fontColor = .blackMain
        contactsAnnotation.backgroundColor = .clear
        contactsAnnotation.color = .clear
        page.addAnnotation(contactsAnnotation)
        
        let locationAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 90,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 160,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        locationAnnotation.contents = inity.site
        locationAnnotation.font = R.font.figtreeRegular(size: 9)!
        locationAnnotation.fontColor = .blackMain
        locationAnnotation.backgroundColor = .clear
        locationAnnotation.color = .clear
        page.addAnnotation(locationAnnotation)
        
        
        let phoneAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 110,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 200,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneAnnotation.contents = inity.email
        phoneAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        phoneAnnotation.fontColor = .blackMain
        phoneAnnotation.backgroundColor = .clear
        phoneAnnotation.color = .clear
        page.addAnnotation(phoneAnnotation)
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 130,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = inity.phone
        emailAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9 )!
        emailAnnotation.fontColor = .blackMain
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 402,
                           y: cvBuilder.convertYCoordinate(top: 140.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = "Skills"
        skillsTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 15)!
        skillsTitleAnnotation.fontColor = .blackMain
        skillsTitleAnnotation.backgroundColor = .clear
        skillsTitleAnnotation.color = .clear
        page.addAnnotation(skillsTitleAnnotation)
        
        let skillsBaseY: CGFloat = 40.0
        let skillsSpacing: CGFloat = 85.0
        let skillsBoxHeight: CGFloat = 70.0
        
        let yPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let ylPosition = cvBuilder.convertYCoordinate(
            top: skillsBaseY,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let skillsDescAnnotation = PDFAnnotation(
            bounds: CGRect(x: 420, y: cvBuilder.convertYCoordinate(top: 324, elementHeight: 150, pageHeight: cvBuilder.pageSize.height), width: 150, height: 300),
            forType: .freeText,
            withProperties: nil
        )
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        skillsDescAnnotation.fontColor = .blackMain
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 270,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 402, y: yllPosition, width: 200, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        langTitleAnnotation.contents =  "Languages"
        langTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 15)!
        langTitleAnnotation.fontColor = .blackMain
        langTitleAnnotation.backgroundColor = .clear
        langTitleAnnotation.color = .clear
        page.addAnnotation(langTitleAnnotation)
        
        
        let ylllPosition = cvBuilder.convertYCoordinate(
            top: 430,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        let langDescriptionAnnotation = PDFAnnotation(
            bounds: CGRect(x: 420, y: ylllPosition , width: 150, height: 150),
            forType: .freeText,
            withProperties: nil
        )
        
        
        langDescriptionAnnotation.contents = inity.languages
            .flatMap { $0.name.components(separatedBy: ",") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .joined(separator: ", ")
        langDescriptionAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
        langDescriptionAnnotation.fontColor = .blackMain
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 210,
                           y: cvBuilder.convertYCoordinate(
                            top: 140,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        
        workExperienceTitleAnnotation.contents = "Experience"
        workExperienceTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 14)!
        workExperienceTitleAnnotation.fontColor = .blackMain
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        let baseY: CGFloat = 10.0
        let verticalSpacing: CGFloat = 120.0
        for (index, work) in inity.workExperience.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let jobNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition - 20, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobNameAnnotation.contents = work.companyName
            jobNameAnnotation.font = R.font.figtreeBold.callAsFunction(size: 12)!
            jobNameAnnotation.fontColor = .blackMain
            jobNameAnnotation.backgroundColor = .clear
            jobNameAnnotation.color = .clear
            page.addAnnotation(jobNameAnnotation)
            
            
            let periodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: work.workStartedDate)
            let endDate = formatter.string(from: work.workEndedDate)
            periodAnnotation.contents = "\(startDate) - \(endDate)"
            periodAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            periodAnnotation.fontColor = .blackMain
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            
            let locationAnnotation = PDFAnnotation(
                bounds: CGRect(x: 340, y: yPosition , width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            locationAnnotation.contents = work.country
            locationAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            locationAnnotation.fontColor = .blackMain
            locationAnnotation.backgroundColor = .clear
            locationAnnotation.color = .clear
            page.addAnnotation(locationAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition - 110, width: 200, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .blackMain
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
        }
        
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 210,
                           y: cvBuilder.convertYCoordinate(top: 670, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 14)!
        educationTitleAnnotation.fontColor = .blackMain
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 650
        let educationSpacing: CGFloat = 55.0
        let educationBoxHeight: CGFloat = 72.0
        
        for (index, edu) in inity.education.enumerated() {
            
            let yPosition = cvBuilder.convertYCoordinate(
                top: educationBaseY + CGFloat(index) * educationSpacing,
                elementHeight: educationBoxHeight,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: edu.startedDate)
            let endDate = formatter.string(from: edu.endedDate)
            
            let dateAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            dateAnnotation.contents = "\(startDate) - \(endDate)"
            dateAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 8)!
            dateAnnotation.fontColor = .blackMain
            dateAnnotation.backgroundColor = .clear
            dateAnnotation.color = .clear
            page.addAnnotation(dateAnnotation)
            
            
            let educationNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition - 14, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationNameAnnotation.contents = edu.education
            educationNameAnnotation.font = R.font.figtreeRegular.callAsFunction(size: 11)!
            educationNameAnnotation.fontColor = .black
            educationNameAnnotation.backgroundColor = .clear
            educationNameAnnotation.color = .clear
            page.addAnnotation(educationNameAnnotation)
            
            let descriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 210, y: yPosition - 42, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            descriptionAnnotation.contents = edu.description
            descriptionAnnotation.font = R.font.figtreeRegular(size: 10)!
            descriptionAnnotation.fontColor = .blackMain
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        self.pdfDocument = pdfDoc
        
        exportPDF(document: pdfDoc)
    }
    
    private func exportPDF(document: PDFDocument) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("myCV.pdf")
        if document.write(to: tempURL) {
            print("PDF successfully saved at: \(tempURL)")
            
            do {
                let fileData = try Data(contentsOf: tempURL)
                if let generatedPDF = PDFDocument(data: fileData),
                   let firstPageImage = generatedPDF.imageRepresenation {
                    
                    generatedPDF.documentAttributes = [
                        PDFDocumentAttribute.titleAttribute: filename
                    ]
                    
                    // Update our @State values
                    self.pdfDocument = generatedPDF
                    self.data = fileData
                    self.previewImage = Image(uiImage: firstPageImage)
                }
            } catch {
                print("Error reading temp PDF back as Data: \(error)")
            }
            
        } else {
            print("Failed to write PDF file.")
        }
    }
}

#Preview {
    ContentView()
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
    private let isCircle: Bool
    init(bounds: CGRect, image: UIImage , properties: [AnyHashable : Any]?, isCircle: Bool = false) {
        self.stampImage = image
        self.isCircle = isCircle
        super.init(bounds: bounds, forType: .stamp, withProperties: properties)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        guard let cgImage = stampImage.cgImage else { return }
        
        context.saveGState()
        
        if isCircle {
            let circlePath = UIBezierPath(ovalIn: bounds)
            context.addPath(circlePath.cgPath)
            context.clip()
        }
        
        context.draw(cgImage, in: bounds)
        context.restoreGState()
    }
}

final class ConstructHelper: ObservableObject {
    let pageSize = CGSize(width: 595.2, height: 841.8)
    
    func convertYCoordinate(top: CGFloat, elementHeight: CGFloat, pageHeight: CGFloat) -> CGFloat {
        return pageHeight - (top + elementHeight)
    }
}
//
//#Preview {
//    ContentView()
//}
