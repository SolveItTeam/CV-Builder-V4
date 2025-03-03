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

import SwiftUI
import PDFKit

struct ContentView: View {
    // MARK: - User Inputs
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @StateObject var cvBuilder: CVBuilder = CVBuilder()
    // MARK: - PDF State
    @State private var pdfDocument: PDFDocument?
    
    // Share Sheet
    @State private var showShareSheet = false
    @State private var temporaryFileURL: URL?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // If the PDF is loaded, show it
                if let pdfDocument {
                    PDFKitRepresentedView(pdfDocument: pdfDocument)
                        .frame(minHeight: 300)
                }
            }
            .padding()
            // Present share sheet when needed
            .sheet(isPresented: $showShareSheet) {
                if let fileURL = temporaryFileURL {
                    ShareSheet(activityItems: [fileURL])
                }
            }
            .onAppear {
                overlayTextOnPDF(                   
                    inity: CVConstructor(
                        fullname: "Katherine Monroe",
                        speciality: "UX/UI Designer",
                        phone: "+99 (99) 9.9999-9999",
                        email: "katherinem@email.com ",
                        summary: "A creative and detail-oriented graphic designer with experience in creating visually appealing and functional designs. I have skills in developing identities, corporate styles.",
                        workExperience: [
                            Work(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", duties: ["Visual Design", "Prototyping", "UX Researching", "Front-end Dev", "Unity 3d Models", "Principle", "Presentations", "Web / Mobile"]),
                            
                            Work(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", duties: ["Visual Design", "Prototyping", "UX Researching", "Front-end Dev", "Unity 3d Models", "Principle", "Presentations", "Web / Mobile"]),
                            
                            Work(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", duties: ["Visual Design", "Prototyping", "UX Researching", "Front-end Dev", "Unity 3d Models", "Principle", "Presentations", "Web / Mobile"]),
                            
                            Work(workStartedDate: Date(), workEndedDate: Date(), speciality: "Lead UI/UX Designer", companyName: "Company Name", country: "Dubai, UAE", duties: ["Visual Design", "Prototyping", "UX Researching", "Front-end Dev", "Unity 3d Models", "Principle", "Presentations", "Web / Mobile"])
                        ],
                        education: [
                            Education(startedDate: Date(), endedDate: Date(), education: "It-Academy", description: "Belarussian State\nPedagogical University (Minsk)"),
                            Education(startedDate: Date(), endedDate: Date(), education: "It-Academy", description: "Full Stack Web designer\nFront-end Dev (Minsk)")
                        ],
                        skills: [
                            Skills(type: "Hard Skills", description: "Axure, Figma, Sketch, Photoshop,\nIllustrator, XD, Unity, Zeplin, Principle"),
                            Skills(type: "Soft Skills", description: "NPM, JavaScript, HTML, CSS, Bootstrap, Git, Lit"),
                            Skills(type: "Languages", description: "English, Spanish, Russian"),
                        ]))
            }
        }
    }
    
    // MARK: - Fill PDF
    /// Loads the local PDF from the app bundle, finds form fields, and updates them.
    private func overlayTextOnPDF(
        inity: CVConstructor
        
    ) {
        guard let url = Bundle.main.url(forResource:  R.file.coloredTemplatePdf.name, withExtension: "pdf"),
              let pdfDoc = PDFDocument(url: url) else {
            print("Could not load cv.pdf from bundle.")
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
    
        let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: UIImage(resource: .woman), properties: nil)
               
            page.addAnnotation(imageAnnotation)
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.00, y: cvBuilder.convertYCoordinate(
                top: 73.92,
                elementHeight: 30,
                pageHeight: cvBuilder.pageSize.height
            ), width: 300, height: 30),
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
            bounds: CGRect(x: 100.00, y: cvBuilder.convertYCoordinate(
                top: 103.92,
                elementHeight: 30,
                pageHeight: cvBuilder.pageSize.height
            ), width: 300, height: 30),
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
            bounds: CGRect(x: 100.00, y: cvBuilder.convertYCoordinate(
                top: 130.92,
                elementHeight: 30,
                pageHeight: cvBuilder.pageSize.height
            ), width: 100, height: 30),
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
            bounds: CGRect(x: 200.00, y: cvBuilder.convertYCoordinate(
                top: 130.92,
                elementHeight: 30,
                pageHeight: cvBuilder.pageSize.height
            ), width: 300, height: 30),
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
            bounds: CGRect(x: 100.00, y: cvBuilder.convertYCoordinate(
                top: 160.92,
                elementHeight: 30,
                pageHeight: cvBuilder.pageSize.height
            ), width: 300, height: 30),
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
            bounds: CGRect(x: 100.00, y: cvBuilder.convertYCoordinate(
                top: 150.92,
                elementHeight: 60,
                pageHeight: cvBuilder.pageSize.height
            ), width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        summaryAnnotation.contents = inity.summary
        summaryAnnotation.font = R.font.latoRegular.callAsFunction(size: 8.41)!
        summaryAnnotation.fontColor = .blackMain
        summaryAnnotation.backgroundColor = .clear
        summaryAnnotation.color = .clear
        page.addAnnotation(summaryAnnotation)
        
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 100.00, y: cvBuilder.convertYCoordinate(
                top: 220.0,
                elementHeight: 30,
                pageHeight: cvBuilder.pageSize.height
            ), width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        workExperienceTitleAnnotation.contents = R.string.localizable.workExperience()
        workExperienceTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 13.22)!
        workExperienceTitleAnnotation.fontColor = .blackMain
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        
        let baseY: CGFloat = 494.0  // Adjust as needed
        let verticalSpacing: CGFloat = 140.0  // Space between each section

        for (index, work) in inity.workExperience.reversed().enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY - CGFloat(index) * verticalSpacing,
                elementHeight: 200,
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
        
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 323.00, y: cvBuilder.convertYCoordinate(
                top: 242.0,
                elementHeight: 30,
                pageHeight: cvBuilder.pageSize.height
            ), width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = R.string.localizable.education()
        educationTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 13.22)!
        educationTitleAnnotation.fontColor = .blackMain
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 326.0
        let educationSpacing: CGFloat = 95.0
        let educationBoxHeight: CGFloat = 72.0  // Height of each education box
        let educationBoxWidth: CGFloat = 400.0  // Width of each education box

        for (index, edu) in inity.education.reversed().enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: educationBaseY - CGFloat(index) * educationSpacing,
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
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 323.00, y: cvBuilder.convertYCoordinate(
                top: 470.0,
                elementHeight: 30,
                pageHeight: cvBuilder.pageSize.height
            ), width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = R.string.localizable.skills()
        skillsTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 13.22)!
        skillsTitleAnnotation.fontColor = .blackMain
        skillsTitleAnnotation.backgroundColor = .clear
        skillsTitleAnnotation.color = .clear
        page.addAnnotation(skillsTitleAnnotation)
        
        
        // Base Y-position for Skills Section
        let skillsBaseY: CGFloat = 630.0  // Adjust as needed
        let skillsSpacing: CGFloat = 85.0  // Space between each section
        let skillsBoxHeight: CGFloat = 70.0  // Height of each skills box
        let skillsBoxWidth: CGFloat = 400.0  // Width of each skills box

        for (index, skill) in inity.skills.reversed().enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: skillsBaseY - CGFloat(index) * skillsSpacing,
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

            // Skill Description (Smaller, Gray)
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
        
        
        self.pdfDocument = pdfDoc
    }
    
    private func exportPDF(document: PDFDocument) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("myCV.pdf")
        if document.write(to: tempURL) {
            temporaryFileURL = tempURL
            showShareSheet = true
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
