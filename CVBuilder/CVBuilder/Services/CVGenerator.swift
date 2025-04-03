import PDFKit
import SwiftUI

struct CVGenerator {
    
    private let cvBuilder = ConstructHelper()
    
    func build(with type: CVTemplate, cvConstructor: CVConstructor) async -> (doc: PDFDocument, fileData: Data, previewImage: Image)? {
        await withCheckedContinuation { continuation in
            let result = buildCV(with: type, cvConstructor: cvConstructor)
            continuation.resume(returning: result)
        }
    }
    
    func buildCV(with type: CVTemplate, cvConstructor: CVConstructor) -> (doc: PDFDocument, fileData: Data, previewImage: Image)? {
        switch type.num {
        case 1:
            return generate1(cvConstructor: cvConstructor)
        case 2:
            return generate3(cvConstructor: cvConstructor)
        case 3:
            return generate4(cvConstructor: cvConstructor)
        case 4:
            return generate5(cvConstructor: cvConstructor)
        case 5:
            return generate6(cvConstructor: cvConstructor)
        case 6:
            return generate7(cvConstructor: cvConstructor)
        case 7:
            return generate8(cvConstructor: cvConstructor)
        default:
            return generate3(cvConstructor: cvConstructor)
        }
    }
    
    private func generate1(cvConstructor: CVConstructor) -> (doc: PDFDocument, fileData: Data, previewImage: Image)? {
        var inity = cvConstructor
        let workArray: [WorkExperienceInput] = inity.workExperience.reversed().map { input in
            return WorkExperienceInput(
                workStartedDate: input.workStartedDate,
                workEndedDate: input.workEndedDate,
                speciality: input.speciality,
                companyName: input.companyName,
                country: input.country
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
            return nil
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return nil
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
        
        if let imagePath = inity.profileImagePath {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsDirectory.appendingPathComponent(imagePath)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
                    
                    let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: loadedImage , properties: nil)
                    
                    page.addAnnotation(imageAnnotation)
                    print("Loaded image from: \(fileURL.path)")
                } else {
                    print("Failed to load image data from: \(fileURL.path)")
                }
            } else {
                print("No image found at: \(fileURL.path)")
            }
        }
        
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
        nameAnnotation.contents = inity.firstname
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
        speciallityAnnotation.contents = inity.jobTitle
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
        summaryTitleAnnotation.contents = R.string.localizable.summaryTitle()
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
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 76, y: yPosition - 80, width: 200, height: 60),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.sourceSansProRegular.callAsFunction(size: 7.81)!
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
        educationTitleAnnotation.contents = R.string.localizable.education()
        educationTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 13.22)!
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
        skillsDescAnnotation.font = R.font.latoRegular.callAsFunction(size: 9)!
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
        langTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 10)!
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
        langDescriptionAnnotation.font = R.font.latoRegular.callAsFunction(size: 9)!
        langDescriptionAnnotation.fontColor = .darkGray
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        
        
        return exportPDF(document: pdfDoc, cvConstructor: cvConstructor)
    }
    
    
    private func generate3(cvConstructor: CVConstructor) -> (doc: PDFDocument, fileData: Data, previewImage: Image)? {
        var inity = cvConstructor
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
            return nil
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return nil
        }
        
        let speciallityAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 23.92,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        speciallityAnnotation.contents = inity.jobTitle
        speciallityAnnotation.font = R.font.ralewayLight(size: 11)!
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
                           width: 300,
                           height: 50),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname
        nameAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 34)!
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
        contactsAnnotation.contents = R.string.localizable.contact()
        contactsAnnotation.font = R.font.josefinSansBold(size: 13)!
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
        locationTitleAnnotation.contents = "Location"
        locationTitleAnnotation.font = R.font.josefinSansBold(size: 11)!
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
        locationAnnotation.font = R.font.ralewayLight(size: 11)!
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
        emailTitleAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 11)!
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
        emailAnnotation.font = R.font.latoRegular.callAsFunction(size: 9.41)!
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
        phoneTitleAnnotation.font = R.font.josefinSansBold(size: 11)!
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
        phoneAnnotation.font = R.font.latoMedium.callAsFunction(size: 9.41)!
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
        summaryTitleAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 14)!
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
        summaryAnnotation.font = R.font.ralewayLight.callAsFunction(size: 10)!
        summaryAnnotation.fontColor = .blackMain
        summaryAnnotation.backgroundColor = .clear
        summaryAnnotation.color = .clear
        page.addAnnotation(summaryAnnotation)
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38,
                           y: cvBuilder.convertYCoordinate(top: 306.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 14)!
        educationTitleAnnotation.fontColor = .blackMain
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 282
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
            educationPeriodAnnotation.font = R.font.ralewayLight.callAsFunction(size: 9)!
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
            educationNameAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 11)!
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
            descriptionAnnotation.font = R.font.ralewayLight.callAsFunction(size: 10)!
            descriptionAnnotation.fontColor = .blackMain
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
        workExperienceTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 13.22)!
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
            jobTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 9)!
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
            periodAnnotation.font = R.font.latoRegular.callAsFunction(size: 8)!
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
            leftDutiesAnnotation.font = R.font.ralewayLight.callAsFunction(size: 9)!
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
        skillsTitleAnnotation.contents = R.string.localizable.skills()
        skillsTitleAnnotation.font = R.font.ralewayLight.callAsFunction(size: 13.22)!
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
        skillsDescAnnotation.font = R.font.ralewayLight.callAsFunction(size: 9)!
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
        langTitleAnnotation.contents = R.string.localizable.languages()
        langTitleAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 10)!
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
        langDescriptionAnnotation.font = R.font.ralewayLight.callAsFunction(size: 9)!
        langDescriptionAnnotation.fontColor = .blackMain
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        return exportPDF(document: pdfDoc, cvConstructor: cvConstructor)
    }
    
    
    
    
    private func generate4(cvConstructor: CVConstructor) -> (doc: PDFDocument, fileData: Data, previewImage: Image)? {
        var inity = cvConstructor
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
            return nil
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return nil
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
        
        
        if let imagePath = inity.profileImagePath {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsDirectory.appendingPathComponent(imagePath)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
                    
                    let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: loadedImage , properties: nil, isCircle: true)
                    
                    page.addAnnotation(imageAnnotation)
                    print("Loaded image from: \(fileURL.path)")
                } else {
                    print("Failed to load image data from: \(fileURL.path)")
                }
            } else {
                print("No image found at: \(fileURL.path)")
            }
        }
        
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
        speciallityAnnotation.font = R.font.ralewayLight(size: 11)!
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
        nameAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 25)!
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
        contactsAnnotation.contents = R.string.localizable.contact()
        contactsAnnotation.font = R.font.josefinSansBold(size: 14)!
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
        locationAnnotation.font = R.font.ralewayLight(size: 9.41)!
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
        emailAnnotation.font = R.font.ralewayLight(size: 9.41)!
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
        phoneAnnotation.font = R.font.ralewayLight(size: 9.41)!
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
        siteAnnotation.font = R.font.ralewayLight(size: 9.41)!
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
        summaryTitleAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 14)!
        summaryTitleAnnotation.fontColor = .blackMain
        summaryTitleAnnotation.backgroundColor = .clear
        summaryTitleAnnotation.color = .clear
        page.addAnnotation(summaryTitleAnnotation)
        
        let summaryAnnotation = PDFAnnotation(
            bounds: CGRect(x: 38.0,
                           y: cvBuilder.convertYCoordinate(
                            top: 274.92,
                            elementHeight: 60,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 320,
                           height: 200),
            forType: .freeText,
            withProperties: nil
        )
        summaryAnnotation.contents = inity.summary
        summaryAnnotation.font = R.font.ralewayLight(size: 10)!
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
        educationTitleAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 14)!
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
            educationPeriodAnnotation.font = R.font.ralewayLight.callAsFunction(size: 9)!
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
            educationNameAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 11)!
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
            descriptionAnnotation.font = R.font.ralewayLight.callAsFunction(size: 10)!
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
        workExperienceTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 13.22)!
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
            jobTitleAnnotation.font = R.font.latoBold.callAsFunction(size: 9)!
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
            periodAnnotation.font = R.font.latoRegular.callAsFunction(size: 8)!
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
            leftDutiesAnnotation.font = R.font.ralewayLight.callAsFunction(size: 9)!
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
        skillsTitleAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 12)!
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
        skillsDescAnnotation.font = R.font.ralewayLight(size: 9)!
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
        langTitleAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 12)!
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
        langDescriptionAnnotation.font = R.font.ralewayLight(size: 9)!
        langDescriptionAnnotation.fontColor = .blackMain
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        
        
        return exportPDF(document: pdfDoc, cvConstructor: cvConstructor)
    }
    
    
    private func generate5(cvConstructor: CVConstructor) -> (doc: PDFDocument, fileData: Data, previewImage: Image)? {
        var inity = cvConstructor
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
            return nil
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return nil
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
        
        if let imagePath = inity.profileImagePath {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsDirectory.appendingPathComponent(imagePath)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
                    
                    let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: loadedImage, properties: nil, isCircle: true)
                    
                    page.addAnnotation(imageAnnotation)
                    print("Loaded image from: \(fileURL.path)")
                } else {
                    print("Failed to load image data from: \(fileURL.path)")
                }
            } else {
                print("No image found at: \(fileURL.path)")
            }
        }
        
        
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
        locationAnnotation.font = R.font.inter24ptRegular(size: 8)!
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
        emailAnnotation.font = R.font.inter24ptRegular(size: 8)!
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
        nameAnnotation.font = R.font.inter24ptBold.callAsFunction(size: 15)!
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
        summaryAnnotation.font = R.font.inter24ptRegular(size: 11)!
        summaryAnnotation.fontColor = .blackMain
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
        experienceTitleAnnotation.font = R.font.inter24ptMedium.callAsFunction(size: 11)!
        experienceTitleAnnotation.fontColor = .blackMain
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
            jobTitleAnnotation.font = R.font.inter24ptBold.callAsFunction(size: 10)!
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
            jobLocationAnnotation.font = R.font.inter24ptRegular.callAsFunction(size: 9)!
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
            periodAnnotation.font = R.font.inter24ptRegular.callAsFunction(size: 9)!
            periodAnnotation.fontColor = .c595959
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 208, y: yPosition - 100, width: 330, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.ralewayLight.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .blackMain
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
        educationTitleAnnotation.font = R.font.inter24ptMedium.callAsFunction(size: 11)!
        educationTitleAnnotation.fontColor = .blackMain
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
            educationNameAnnotation.font = R.font.inter24ptBold.callAsFunction(size: 10)!
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
            descriptionAnnotation.font = R.font.inter24ptRegular.callAsFunction(size: 10)!
            descriptionAnnotation.fontColor = .darkGray
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        let skillsBaseY: CGFloat = 800.0
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
        langTitleAnnotation.font = R.font.inter24ptMedium.callAsFunction(size: 11)!
        langTitleAnnotation.fontColor = .blackMain
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
            .joined(separator: ", ")
        langDescriptionAnnotation.font = R.font.inter24ptRegular(size: 9)!
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
        skillsTitleAnnotation.font = R.font.inter24ptMedium.callAsFunction(size: 11)!
        skillsTitleAnnotation.fontColor = .blackMain
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
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.inter24ptRegular(size: 9)!
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
        siteTitleAnnotation.font = R.font.inter24ptMedium.callAsFunction(size: 11)!
        siteTitleAnnotation.fontColor = .blackMain
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
        siteAnnotation.font = R.font.inter24ptRegular(size: 9)!
        siteAnnotation.fontColor = .blackMain
        siteAnnotation.backgroundColor = .clear
        siteAnnotation.color = .clear
        page.addAnnotation(siteAnnotation)
        
        return exportPDF(document: pdfDoc, cvConstructor: cvConstructor)
    }
    
    private func generate6(cvConstructor: CVConstructor) -> (doc: PDFDocument, fileData: Data, previewImage: Image)? {
        var inity = cvConstructor
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
            return nil
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return nil
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
        
        
        if let imagePath = inity.profileImagePath {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsDirectory.appendingPathComponent(imagePath)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
                    
                    let imageAnnotation = ImageStampAnnotation(bounds: imageFrame, image: loadedImage , properties: nil, isCircle: true)
                    
                    page.addAnnotation(imageAnnotation)
                    print("Loaded image from: \(fileURL.path)")
                } else {
                    print("Failed to load image data from: \(fileURL.path)")
                }
            } else {
                print("No image found at: \(fileURL.path)")
            }
        }
        
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
        nameAnnotation.font = R.font.robotoCondensedBold.callAsFunction(size: 20)!
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
        speciallityAnnotation.font = R.font.robotoCondensedRegular(size: 10)!
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
        contactsAnnotation.font = R.font.robotoCondensedBold(size: 15)!
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
        locationTitleAnnotation.font = R.font.robotoCondensedBold(size: 11)!
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
        locationAnnotation.font = R.font.robotoCondensedRegular(size: 9)!
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
        phoneTitleAnnotation.font = R.font.robotoCondensedBold(size: 11)!
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
        phoneAnnotation.font = R.font.robotoCondensedRegular.callAsFunction(size: 9.41)!
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
        emailTitleAnnotation.font = R.font.robotoCondensedBold.callAsFunction(size: 11)!
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
        emailAnnotation.font = R.font.robotoCondensedRegular.callAsFunction(size: 9.41)!
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
        linksTitleAnnotation.font = R.font.robotoCondensedBold.callAsFunction(size: 15)!
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
        linkAnnotation.font = R.font.robotoCondensedRegular.callAsFunction(size: 9.41)!
        linkAnnotation.fontColor = .blackMain
        linkAnnotation.backgroundColor = .clear
        linkAnnotation.color = .clear
        page.addAnnotation(linkAnnotation)
        
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434,
                           y: cvBuilder.convertYCoordinate(top: 290.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = "Skills"
        skillsTitleAnnotation.font = R.font.robotoCondensedBold.callAsFunction(size: 15)!
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
            bounds: CGRect(x: 434, y: 224, width: 150, height: 300),
            forType: .freeText,
            withProperties: nil
        )
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.robotoCondensedRegular.callAsFunction(size: 9)!
        skillsDescAnnotation.fontColor = .blackMain
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 530,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 434, y: yllPosition - 5, width: 200, height: 20),
            forType: .freeText,
            withProperties: nil
        )
        langTitleAnnotation.contents =  "Languages"
        langTitleAnnotation.font = R.font.robotoCondensedBold.callAsFunction(size: 15)!
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
        langDescriptionAnnotation.font = R.font.robotoCondensedRegular.callAsFunction(size: 9)!
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
        summaryTitleAnnotation.font = R.font.robotoCondensedBold.callAsFunction(size: 15)!
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
        summaryAnnotation.font = R.font.robotoCondensedRegular(size: 9)!
        summaryAnnotation.fontColor = .blackMain
        summaryAnnotation.backgroundColor = .clear
        summaryAnnotation.color = .clear
        page.addAnnotation(summaryAnnotation)
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 40,
                           y: cvBuilder.convertYCoordinate(
                            top: 280,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        workExperienceTitleAnnotation.contents = "Experience"
        workExperienceTitleAnnotation.font = R.font.robotoCondensedBold.callAsFunction(size: 15)!
        workExperienceTitleAnnotation.fontColor = .blackMain
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        let baseY: CGFloat = 134.0
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
            jobNameAnnotation.font = R.font.robotoCondensedBold.callAsFunction(size: 10)!
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
            jobTitleAnnotation.font = R.font.robotoCondensedRegular.callAsFunction(size: 9)!
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
            periodAnnotation.font = R.font.robotoCondensedRegular.callAsFunction(size: 8)!
            periodAnnotation.fontColor = .c595959
            periodAnnotation.backgroundColor = .clear
            periodAnnotation.color = .clear
            page.addAnnotation(periodAnnotation)
            
            
            let locationAnnotation = PDFAnnotation(
                bounds: CGRect(x: 300, y: yPosition - 40, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            locationAnnotation.contents = work.country
            locationAnnotation.font = R.font.robotoCondensedRegular.callAsFunction(size: 8)!
            locationAnnotation.fontColor = .c595959
            locationAnnotation.backgroundColor = .clear
            locationAnnotation.color = .clear
            page.addAnnotation(locationAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 40, y: yPosition - 130, width: 330, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.robotoCondensedRegular.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .blackMain
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
        educationTitleAnnotation.font = R.font.josefinSansBold.callAsFunction(size: 14)!
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
            educationNameAnnotation.font = R.font.robotoCondensedRegular.callAsFunction(size: 11)!
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
            descriptionAnnotation.font = R.font.ralewayLight(size: 10)!
            descriptionAnnotation.fontColor = .darkGray
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        
        
        return exportPDF(document: pdfDoc, cvConstructor: cvConstructor)
    }
    
    
    private func generate7(cvConstructor: CVConstructor) -> (doc: PDFDocument, fileData: Data, previewImage: Image)? {
        var inity = cvConstructor
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
            return nil
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return nil
        }
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 190,
                           y: cvBuilder.convertYCoordinate(
                            top: 51,
                            elementHeight: 200,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 400,
                           height: 200),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname + ",  " + inity.jobTitle
        nameAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 40)!
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
        contactsAnnotation.font = R.font.konstantGroteskBook(size: 15)!
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
        locationAnnotation.font = R.font.konstantGroteskBook(size: 9)!
        locationAnnotation.fontColor = .white
        locationAnnotation.backgroundColor = .clear
        locationAnnotation.color = .clear
        page.addAnnotation(locationAnnotation)
        
        
        let phoneAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 120,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 200,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneAnnotation.contents = inity.email
        phoneAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 9)!
        phoneAnnotation.fontColor = .white
        phoneAnnotation.backgroundColor = .clear
        phoneAnnotation.color = .clear
        page.addAnnotation(phoneAnnotation)
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 140,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = inity.phone
        emailAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 9 )!
        emailAnnotation.fontColor = .white
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 402,
                           y: cvBuilder.convertYCoordinate(top: 190.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = "Skills"
        skillsTitleAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 15)!
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
            bounds: CGRect(x: 420, y: cvBuilder.convertYCoordinate(top: 390, elementHeight: 150, pageHeight: cvBuilder.pageSize.height), width: 150, height: 300),
            forType: .freeText,
            withProperties: nil
        )
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 9)!
        skillsDescAnnotation.fontColor = .white
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 460,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 402, y: yllPosition, width: 200, height: 20),
            forType: .freeText,
            withProperties: nil
        )
        langTitleAnnotation.contents =  "Languages"
        langTitleAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 15)!
        langTitleAnnotation.fontColor = .white
        langTitleAnnotation.backgroundColor = .clear
        langTitleAnnotation.color = .clear
        page.addAnnotation(langTitleAnnotation)
        
        
        let ylllPosition = cvBuilder.convertYCoordinate(
            top: 640,
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
        langDescriptionAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 9)!
        langDescriptionAnnotation.fontColor = .white
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 190,
                           y: cvBuilder.convertYCoordinate(
                            top: 190,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        
        workExperienceTitleAnnotation.contents = "Experience"
        workExperienceTitleAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 14)!
        workExperienceTitleAnnotation.fontColor = .white
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        let baseY: CGFloat = 50.0
        let verticalSpacing: CGFloat = 120.0
        for (index, work) in inity.workExperience.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let jobNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition - 20, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobNameAnnotation.contents = work.companyName
            jobNameAnnotation.font = R.font.inter24ptMedium.callAsFunction(size: 12)!
            jobNameAnnotation.fontColor = .white
            jobNameAnnotation.backgroundColor = .clear
            jobNameAnnotation.color = .clear
            page.addAnnotation(jobNameAnnotation)
            
            
            let periodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: work.workStartedDate)
            let endDate = formatter.string(from: work.workEndedDate)
            periodAnnotation.contents = "\(startDate) - \(endDate)"
            periodAnnotation.font = R.font.inter24ptRegular.callAsFunction(size: 8)!
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
            locationAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 8)!
            locationAnnotation.fontColor = .white
            locationAnnotation.backgroundColor = .clear
            locationAnnotation.color = .clear
            page.addAnnotation(locationAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition - 110, width: 200, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.inter24ptRegular.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .white
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
        }
        
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 190,
                           y: cvBuilder.convertYCoordinate(top: 700, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 14)!
        educationTitleAnnotation.fontColor = .white
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 670
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
                bounds: CGRect(x: 190, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            dateAnnotation.contents = "\(startDate) - \(endDate)"
            dateAnnotation.font = R.font.inter24ptRegular.callAsFunction(size: 8)!
            dateAnnotation.fontColor = .white
            dateAnnotation.backgroundColor = .clear
            dateAnnotation.color = .clear
            page.addAnnotation(dateAnnotation)
            
            
            let educationNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition - 14, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationNameAnnotation.contents = edu.education
            educationNameAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 11)!
            educationNameAnnotation.fontColor = .white
            educationNameAnnotation.backgroundColor = .clear
            educationNameAnnotation.color = .clear
            page.addAnnotation(educationNameAnnotation)
            
            let descriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition - 42, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            descriptionAnnotation.contents = edu.description
            descriptionAnnotation.font = R.font.konstantGroteskBook(size: 10)!
            descriptionAnnotation.fontColor = .white
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        
        
        return exportPDF(document: pdfDoc, cvConstructor: cvConstructor)
    }
    
    
    
    
    private func generate8(cvConstructor: CVConstructor) -> (doc: PDFDocument, fileData: Data, previewImage: Image)? {
        var inity = cvConstructor
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
            return nil
        }
        
        guard let page = pdfDoc.page(at: 0) else {
            print("No pages found in PDF.")
            return nil
        }
        
        let nameAnnotation = PDFAnnotation(
            bounds: CGRect(x: 190,
                           y: cvBuilder.convertYCoordinate(
                            top: 51,
                            elementHeight: 200,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 400,
                           height: 200),
            forType: .freeText,
            withProperties: nil
        )
        nameAnnotation.contents = inity.firstname + " " + inity.lastname + ",  " + inity.jobTitle
        nameAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 40)!
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
        contactsAnnotation.font = R.font.konstantGroteskBook(size: 15)!
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
        locationAnnotation.font = R.font.konstantGroteskBook(size: 9)!
        locationAnnotation.fontColor = .blackMain
        locationAnnotation.backgroundColor = .clear
        locationAnnotation.color = .clear
        page.addAnnotation(locationAnnotation)
        
        
        let phoneAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 120,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 200,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        phoneAnnotation.contents = inity.email
        phoneAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 9)!
        phoneAnnotation.fontColor = .blackMain
        phoneAnnotation.backgroundColor = .clear
        phoneAnnotation.color = .clear
        page.addAnnotation(phoneAnnotation)
        
        let emailAnnotation = PDFAnnotation(
            bounds: CGRect(x: 24,
                           y: cvBuilder.convertYCoordinate(
                            top: 140,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 300,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        emailAnnotation.contents = inity.phone
        emailAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 9 )!
        emailAnnotation.fontColor = .blackMain
        emailAnnotation.backgroundColor = .clear
        emailAnnotation.color = .clear
        page.addAnnotation(emailAnnotation)
        
        
        
        let skillsTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 402,
                           y: cvBuilder.convertYCoordinate(top: 190.0, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        skillsTitleAnnotation.contents = "Skills"
        skillsTitleAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 15)!
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
            bounds: CGRect(x: 420, y: cvBuilder.convertYCoordinate(top: 390, elementHeight: 150, pageHeight: cvBuilder.pageSize.height), width: 150, height: 300),
            forType: .freeText,
            withProperties: nil
        )
        let combined = inity.skills
            .flatMap { $0.description.components(separatedBy: ",") }
            .map { SkillInput(description: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .map { $0.description }.joined(separator: ", ")
        skillsDescAnnotation.contents = combined
        skillsDescAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 9)!
        skillsDescAnnotation.fontColor = .blackMain
        skillsDescAnnotation.backgroundColor = .clear
        skillsDescAnnotation.color = .clear
        page.addAnnotation(skillsDescAnnotation)
        
        
        let yllPosition = cvBuilder.convertYCoordinate(
            top: 460,
            elementHeight: skillsBoxHeight,
            pageHeight: cvBuilder.pageSize.height
        )
        
        let langTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 402, y: yllPosition, width: 200, height: 20),
            forType: .freeText,
            withProperties: nil
        )
        langTitleAnnotation.contents = "Languages"
        langTitleAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 15)!
        langTitleAnnotation.fontColor = .blackMain
        langTitleAnnotation.backgroundColor = .clear
        langTitleAnnotation.color = .clear
        page.addAnnotation(langTitleAnnotation)
        
        
        let ylllPosition = cvBuilder.convertYCoordinate(
            top: 640,
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
        langDescriptionAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 9)!
        langDescriptionAnnotation.fontColor = .blackMain
        langDescriptionAnnotation.backgroundColor = .clear
        langDescriptionAnnotation.color = .clear
        page.addAnnotation(langDescriptionAnnotation)
        
        let workExperienceTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 190,
                           y: cvBuilder.convertYCoordinate(
                            top: 190,
                            elementHeight: 30,
                            pageHeight: cvBuilder.pageSize.height
                           ),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        
        workExperienceTitleAnnotation.contents = "Experience"
        workExperienceTitleAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 14)!
        workExperienceTitleAnnotation.fontColor = .blackMain
        workExperienceTitleAnnotation.backgroundColor = .clear
        workExperienceTitleAnnotation.color = .clear
        page.addAnnotation(workExperienceTitleAnnotation)
        
        let baseY: CGFloat = 50.0
        let verticalSpacing: CGFloat = 120.0
        for (index, work) in inity.workExperience.enumerated() {
            let yPosition = cvBuilder.convertYCoordinate(
                top: baseY + CGFloat(index) * verticalSpacing,
                elementHeight: 190,
                pageHeight: cvBuilder.pageSize.height
            )
            
            let jobNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition - 20, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            jobNameAnnotation.contents = work.companyName
            jobNameAnnotation.font = R.font.inter24ptMedium.callAsFunction(size: 12)!
            jobNameAnnotation.fontColor = .blackMain
            jobNameAnnotation.backgroundColor = .clear
            jobNameAnnotation.color = .clear
            page.addAnnotation(jobNameAnnotation)
            
            
            let periodAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let startDate = formatter.string(from: work.workStartedDate)
            let endDate = formatter.string(from: work.workEndedDate)
            periodAnnotation.contents = "\(startDate) - \(endDate)"
            periodAnnotation.font = R.font.inter24ptRegular.callAsFunction(size: 8)!
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
            locationAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 8)!
            locationAnnotation.fontColor = .blackMain
            locationAnnotation.backgroundColor = .clear
            locationAnnotation.color = .clear
            page.addAnnotation(locationAnnotation)
            
            
            let leftDutiesAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition - 110, width: 200, height: 90),
                forType: .freeText,
                withProperties: nil
            )
            leftDutiesAnnotation.contents = work.jobDescirption
            leftDutiesAnnotation.font = R.font.inter24ptRegular.callAsFunction(size: 9)!
            leftDutiesAnnotation.fontColor = .blackMain
            leftDutiesAnnotation.backgroundColor = .clear
            leftDutiesAnnotation.color = .clear
            page.addAnnotation(leftDutiesAnnotation)
        }
        
        
        let educationTitleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 190,
                           y: cvBuilder.convertYCoordinate(top: 700, elementHeight: 30, pageHeight: cvBuilder.pageSize.height),
                           width: 430,
                           height: 30),
            forType: .freeText,
            withProperties: nil
        )
        educationTitleAnnotation.contents = "Education"
        educationTitleAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 14)!
        educationTitleAnnotation.fontColor = .blackMain
        educationTitleAnnotation.backgroundColor = .clear
        educationTitleAnnotation.color = .clear
        page.addAnnotation(educationTitleAnnotation)
        
        let educationBaseY: CGFloat = 670
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
                bounds: CGRect(x: 190, y: yPosition, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            dateAnnotation.contents = "\(startDate) - \(endDate)"
            dateAnnotation.font = R.font.inter24ptRegular.callAsFunction(size: 8)!
            dateAnnotation.fontColor = .blackMain
            dateAnnotation.backgroundColor = .clear
            dateAnnotation.color = .clear
            page.addAnnotation(dateAnnotation)
            
            
            let educationNameAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition - 14, width: 200, height: 20),
                forType: .freeText,
                withProperties: nil
            )
            educationNameAnnotation.contents = edu.education
            educationNameAnnotation.font = R.font.konstantGroteskBook.callAsFunction(size: 11)!
            educationNameAnnotation.fontColor = .blackMain
            educationNameAnnotation.backgroundColor = .clear
            educationNameAnnotation.color = .clear
            page.addAnnotation(educationNameAnnotation)
            
            let descriptionAnnotation = PDFAnnotation(
                bounds: CGRect(x: 190, y: yPosition - 42, width: 350, height: 30),
                forType: .freeText,
                withProperties: nil
            )
            descriptionAnnotation.contents = edu.description
            descriptionAnnotation.font = R.font.konstantGroteskBook(size: 10)!
            descriptionAnnotation.fontColor = .blackMain
            descriptionAnnotation.backgroundColor = .clear
            descriptionAnnotation.color = .clear
            page.addAnnotation(descriptionAnnotation)
        }
        
        
        return exportPDF(document: pdfDoc, cvConstructor: cvConstructor)
    }
    
    
    private func exportPDF(document: PDFDocument, cvConstructor: CVConstructor) -> (doc: PDFDocument, fileData: Data, previewImage: Image)? {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("myCV.pdf")
        if document.write(to: tempURL) { 
            
            do {
                let fileData = try Data(contentsOf: tempURL)
                if let generatedPDF = PDFDocument(data: fileData),
                   let firstPageImage = generatedPDF.imageRepresenation {
                    
                    generatedPDF.documentAttributes = [
                        PDFDocumentAttribute.titleAttribute: cvConstructor.jobTitle
                    ]
                    
                    return (doc: generatedPDF, fileData: fileData, previewImage: Image(uiImage: firstPageImage))
                    
                }
                
                
            } catch {
                
                print("Error reading temp PDF back as Data: \(error)")
                return nil
            }
            
        } else {
            print("Failed to write PDF file.")
            return nil
        }
        
        return nil
    }
}
