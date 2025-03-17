import SwiftUI

enum FocusableField: Hashable {
    case firstName, lastName, email, jobTitle, summary, phone, site, location, companyName, position, country, jobDescription, universityName, degree
    
}

struct ProfileView: View {
    @FocusState private var isKeyboardVisible: FocusableField?
    @StateObject var viewModel: ProfileViewModel
    
    
    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(.cross)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                }
                .buttonStyle(CircularButton(opacity: 0.6))
            }
            .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text(viewModel.profileData.localizedTitle)
                            .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                        
                        Spacer()
                    }
                    
                    HStack {
                        ForEach(ProfileDataType.allCases, id: \.self) { dataType in
                            Spacer()
                            Button {
                                viewModel.profileData = dataType
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(viewModel.profileData == dataType ? .cE1FF41 : viewModel.profileData.index > dataType.index ? .clear : .c393939.opacity(0.3))
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Circle()
                                                .stroke(viewModel.profileData.index <= dataType.index ? .clear : Color.cE1FF41, lineWidth: 1)
                                        )
                                    Image(dataType.icon)
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(viewModel.profileData == dataType ? .c0A0A0A : viewModel.profileData.index >= dataType.index ? .white : .c686868)
                                }
                            }
                            .buttonStyle(ScaleButtonStyle())
                            Spacer()
                        }
                    }
                    .padding(.vertical, 20)
                    
                    VStack(spacing: 0) {
                        switch viewModel.profileData {
                        case .profile:
                            profileInfoView()
                        case .contact:
                            contactView()
                        case .workExperience:
                            workExperinceView()
                        case .education:
                            studyView()
                        case .skills:
                            skillsView()
                        }
                    }
                    .padding(.horizontal, 2)
                }
                .padding(.horizontal, 16)
            }
            
            HStack(spacing: 14) {
                Button {
                    viewModel.popView()
                } label: {
                    Image(.left)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                }
                .buttonStyle(CircularButton(opacity: 0.6))
                
                .frame(width: 60, height: 60)
                .overlay {
                    Circle()
                        .stroke(.cE1FF41, lineWidth: 1)
                }
                
                Button {
                    switch viewModel.profileData {
                    case .profile:
                        viewModel.profileData = .contact
                    case .contact:
                        viewModel.profileData = .workExperience
                    case .workExperience:
                        viewModel.profileData = .education
                    case .education:
                        viewModel.profileData = .skills
                    case .skills:
                        break
                    }
                } label: {
                    HStack(spacing: 14) {
                        Text(R.string.localizable.next())
                            .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                        Image(.right)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(.c393939)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .buttonStyle(ScaleButtonStyle())
            }
            .padding(.horizontal, 16)
        }
        .animation(.default, value: viewModel.profileData)
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.selectedImage)
        }
        .sheet(isPresented: $viewModel.showWorkSheet) {
            WorkInputView(work: $viewModel.newWorkExperience) {
                viewModel.workExperiences.append(viewModel.newWorkExperience)
                viewModel.newWorkExperience = WorkExperienceInput(duties: [""])
                viewModel.showWorkSheet = false
            }
            .presentationDetents([.fraction(0.985)])
            .presentationDragIndicator(.visible)
            .if(true) { view in
                Group {
                    if #available(iOS 16.4, *) {
                        view.presentationCornerRadius(32)
                    } else {
                        view
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showEducationSheet) {
            EducationInputView(edu: $viewModel.newEducationExperience) {
                viewModel.educationExperiences.append(viewModel.newEducationExperience)
                viewModel.newEducationExperience = EducationInput()
                viewModel.showEducationSheet = false
            }
            .presentationDetents([.fraction(0.985)])
            .presentationDragIndicator(.visible)
            .if(true) { view in
                Group {
                    if #available(iOS 16.4, *) {
                        view.presentationCornerRadius(32)
                    } else {
                        view
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func profileInfoView() -> some View {
        // MARK: Personal Information
        ScrollView {
            
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .overlay(alignment: .bottomTrailing) {
                        Button  {
                            viewModel.showImagePicker = true
                        } label: {
                            Circle()
                                .fill(.cE1FF41)
                                .frame(width: 24, height: 24)
                                .overlay {
                                    Image(.plus)
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 14, height: 14)
                                        .foregroundStyle(.c0A0A0A)
                                    
                                }
                        }
                        .padding(.bottom, 11)
                        .padding(.trailing, -4)
                    }
            } else {
                Circle()
                    .fill(.c393939)
                    .frame(width: 90, height: 90)
                    .overlay {
                        Image(.profile1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Button  {
                            viewModel.showImagePicker = true
                        } label: {
                            Circle()
                                .fill(.cE1FF41)
                                .frame(width: 24, height: 24)
                                .overlay {
                                    Image(.plus)
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 14, height: 14)
                                        .foregroundStyle(.c0A0A0A)
                                }
                        }
                        .padding(.bottom, 11)
                        .padding(.trailing, -4)
                    }
            }
            
            
            
            MainTextField(placeholder: R.string.localizable.firstName(), text: $viewModel.firstname)
                .onSubmit(focusNextField)
                .focused($isKeyboardVisible, equals: .firstName)
            
            MainTextField(placeholder: R.string.localizable.lastName(), text: $viewModel.lastname)
                .onSubmit(focusNextField)
                .focused($isKeyboardVisible, equals: .firstName)
            
            MainTextField(placeholder: R.string.localizable.jobTitle(), text: $viewModel.jobTitle)
                .onSubmit(focusNextField)
                .focused($isKeyboardVisible, equals: .jobTitle)
            
            MainTextField(placeholder: R.string.localizable.summary(), text: $viewModel.summary)
                .onSubmit(focusNextField)
                .focused($isKeyboardVisible, equals: .summary)
        }
    }
    
    @ViewBuilder private func contactView() -> some View {
        VStack {
            MainTextField(placeholder: R.string.localizable.mail(), text: $viewModel.email)
                .onSubmit(focusNextField)
                .keyboardType(.emailAddress)
                .focused($isKeyboardVisible, equals: .email)
            
            MainTextField(placeholder: R.string.localizable.phoneNumber(), text: $viewModel.phone)
                .onSubmit(focusNextField)
                .keyboardType(.phonePad)
                .focused($isKeyboardVisible, equals: .email)
            
            MainTextField(placeholder: R.string.localizable.site(), text: $viewModel.site)
                .onSubmit(focusNextField)
                .focused($isKeyboardVisible, equals: .site)
            
            MainTextField(placeholder: R.string.localizable.location(), text: $viewModel.location)
                .onSubmit(focusNextField)
                .focused($isKeyboardVisible, equals: .location)
            
        }
        .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder private func workExperinceView() -> some View {
        VStack {
            HStack {
                Text(R.string.localizable.addWork)
                    .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                
                Spacer()
                
                if viewModel.workExperiences.count < viewModel.maxWorkExperience {
                    Button {
                        viewModel.showWorkSheet = true
                    } label: {
                        Image(.plus)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                    }
                    .buttonStyle(CircularButton(opacity: 0.6))
                }
            }
            
            ForEach($viewModel.workExperiences, id: \.id) { $work in
                SmallWorkView(work: $work, workExperiences: $viewModel.workExperiences, showWorkSheet: $viewModel.showWorkSheet)
            }
            .padding(.top, 20)
        }
        .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder private func studyView() -> some View {

        VStack {
            HStack {
                Text(R.string.localizable.addEducation())
                    .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                
                Spacer()
                
                if viewModel.educationExperiences.count < viewModel.maxEducation {
                    Button {
                        viewModel.showEducationSheet = true
                    } label: {
                        Image(.plus)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                    }
                    .buttonStyle(CircularButton(opacity: 0.6))
                }
            }
            
            
        }
        .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder private func skillsView() -> some View {
        VStack {
            HStack {
                Text(R.string.localizable.skills())
                    .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                
                Spacer()
                
                if viewModel.skills.count < viewModel.maxSkills {
                    Button {
                        viewModel.skills.append(SkillInput())
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                }
            }
            
            ForEach($viewModel.skills) { $skill in
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
        .transition(.move(edge: .trailing))
    }
    
    private func focusNextField() {
        switch isKeyboardVisible {
        case .firstName:
            isKeyboardVisible = .lastName
        case .lastName:
            isKeyboardVisible = .jobTitle
        case .email:
            isKeyboardVisible = .phone
        case .jobTitle:
            isKeyboardVisible = .summary
        case .summary:
            isKeyboardVisible = nil
        case .phone:
            isKeyboardVisible = .site
        case .site:
            isKeyboardVisible = .location
        case .location:
            isKeyboardVisible = .jobDescription
        case .companyName:
            isKeyboardVisible = .position
        case .position:
            isKeyboardVisible = .location
        case .country:
            isKeyboardVisible = .country
        case .jobDescription:
            isKeyboardVisible = nil
        case .universityName:
            isKeyboardVisible = .degree
        case .degree:
            isKeyboardVisible = nil
        case nil:
            break
        }
    }
      
}

#Preview {
    ProfileView(viewModel: .init(coordinator: .init()))
}

struct WorkInputView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var work: WorkExperienceInput
    @State var formattedDate: String = ""
    @State var formattedEndDate: String = ""
    @State var mockPlaceholder: String = ""

    @FocusState private var isKeyboardVisible: FocusableField?
    var onSave: () -> Void
    
    var couldSave: Bool {
        return !work.companyName.isEmpty && !work.country.isEmpty && !work.jobDescirption.isEmpty && !work.speciality.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                dismiss()
            } label: {
                Image(.cross)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
            }
            .buttonStyle(CircularButton(opacity: 0.3, color: .c686868))
            .padding(.top, 20)
            
            ScrollView(showsIndicators: false) {
                MainTextField(placeholder: R.string.localizable.companyName(), text: $work.companyName, color: .c686868 )
                    .onSubmit(focusNextField)
                    .focused($isKeyboardVisible, equals: .companyName)
                
                MainTextField(placeholder: R.string.localizable.position(), text: $work.speciality, color: .c686868)
                    .onSubmit(focusNextField)
                    .focused($isKeyboardVisible, equals: .position)
                
                MainTextField(placeholder: R.string.localizable.location(), text: $work.country, color: .c686868)
                    .onSubmit(focusNextField)
                    .focused($isKeyboardVisible, equals: .country)
                
                
                MainTextField(placeholder: R.string.localizable.startOfEmployment(), text: $formattedDate, color: .c686868)
                
                    .disabled(true)
                    .overlay {
                        DatePicker("", selection: $work.workStartedDate, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .scaleEffect(4.0)
                            .colorMultiply(.clear)
                            .onChange(of: work.workStartedDate) { newDate in
                                formattedDate = newDate.monthYearString
                            }
                            .clipped()
                    }
                    .contentShape(Rectangle())
                
                MainTextField(placeholder: R.string.localizable.endOfEmployment(), text: $formattedEndDate, color: .c686868)
                    .disabled(true)
                    .overlay {
                        DatePicker("", selection: $work.workEndedDate, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .scaleEffect(4.0)
                            .colorMultiply(.clear)
                            .onChange(of: work.workEndedDate) { newDate in
                                formattedEndDate = newDate.monthYearString
                            }
                            .onChange(of: work.stillWorkingHere) {  newValue in
                                if newValue {
                                    formattedEndDate = Date().monthYearString
                                }
                            }
                        
                    }
                    .clipped()
                    .contentShape(Rectangle())
                
                MainTextField(placeholder: R.string.localizable.stillWorkingHere(), text: $mockPlaceholder, color: .c686868)
                    .disabled(true)
                    .overlay {
                        Toggle(isOn: $work.stillWorkingHere) {
                            
                        }
                        .toggleStyle(CustomColorToggleStyle())
                        .padding(.trailing, 30)
                    }
                
                MainTextEditor(placeholder: R.string.localizable.jobDescription(), text: $work.jobDescirption, color: .c686868)
                    .onSubmit(focusNextField)
                    .focused($isKeyboardVisible, equals: .jobDescription)
                
                
                Spacer(minLength: 50)
            }
            .padding(.top, 10)
            
            Button {
                onSave()
            } label: {
                Text(R.string.localizable.save())
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(couldSave ? .cE1FF41 : .c686868)
            .foregroundStyle(couldSave ? .blackMain : .cA1A1A1)
            .disabled(!couldSave)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, 16)
        .background(.c393939)
    }
    
    private func focusNextField() {
        switch isKeyboardVisible {
        case .firstName:
            isKeyboardVisible = .lastName
        case .lastName:
            isKeyboardVisible = .jobTitle
        case .email:
            isKeyboardVisible = .phone
        case .jobTitle:
            isKeyboardVisible = .summary
        case .summary:
            isKeyboardVisible = nil
        case .phone:
            isKeyboardVisible = .site
        case .site:
            isKeyboardVisible = .location
        case .location:
            isKeyboardVisible = nil
        case .companyName:
            isKeyboardVisible = .position
        case .position:
            isKeyboardVisible = .location
        case .country:
            isKeyboardVisible = .country
        case .jobDescription:
            isKeyboardVisible = nil
        case .universityName:
            isKeyboardVisible = .degree
        case .degree:
            isKeyboardVisible = nil
        case nil:
            break
        }
    }
}


struct EducationInputView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var edu: EducationInput
    @State var formattedStartedDate: String = ""
    @State var formattedEndDate: String = ""
    @State var mockPlaceholder: String = ""
    @FocusState var isKeyboardVisible: FocusableField?
    
    var onSave: () -> Void
    
    
    var couldSave: Bool {
        return !edu.education.isEmpty && !edu.degree.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                dismiss()
            } label: {
                Image(.cross)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
            }
            .buttonStyle(CircularButton(opacity: 0.3, color: .c686868))
            .padding(.top, 20)
            
            ScrollView(showsIndicators: false) {
                
                MainTextField(placeholder: R.string.localizable.universityName(), text: $edu.education,  color: .c686868)
                    .onSubmit(focusNextField)
                    .focused($isKeyboardVisible, equals: .universityName)
                
                MainTextField(placeholder: R.string.localizable.degree(), text: $edu.degree,  color: .c686868)
                    .onSubmit(focusNextField)
                    .focused($isKeyboardVisible, equals: .degree)
                
                
                MainTextField(placeholder: R.string.localizable.endOfEmployment(), text: $formattedStartedDate, color: .c686868)
                    .disabled(true)
                    .overlay {
                        DatePicker("", selection: $edu.startedDate, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .scaleEffect(4.0)
                            .colorMultiply(.clear)
                            .onChange(of: edu.startedDate) { newDate in
                                formattedEndDate = newDate.monthYearString
                            }
                    }
                    .clipped()
                    .contentShape(Rectangle())
                
                
                MainTextField(placeholder: R.string.localizable.endOfEmployment(), text: $formattedEndDate, color: .c686868)
                    .disabled(true)
                    .overlay {
                        DatePicker("", selection: $edu.endedDate, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .scaleEffect(4.0)
                            .colorMultiply(.clear)
                            .onChange(of: edu.endedDate) { newDate in
                                formattedEndDate = newDate.monthYearString
                            }
                            .onChange(of: edu.stillStudyingHere) {  newValue in
                                if newValue {
                                    formattedEndDate = Date().monthYearString
                                }
                            }
                        
                    }
                    .clipped()
                    .contentShape(Rectangle())
                
                MainTextField(placeholder: R.string.localizable.stillStudyingHere(), text: $formattedEndDate, color: .c686868)
                    .disabled(true)
                    .overlay {
                        Toggle(isOn: $edu.stillStudyingHere) { }
                        .toggleStyle(CustomColorToggleStyle())
                        .padding(.trailing, 30)
                    }
                
                
                Spacer(minLength: 50)
            }
            .padding(.top, 10)
            
            Button {
                onSave()
            } label: {
                Text(R.string.localizable.save())
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(couldSave ? .cE1FF41 : .c686868)
            .foregroundStyle(couldSave ? .blackMain : .cA1A1A1)
            .disabled(!couldSave)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, 16)
        .background(.c393939)
    }
    
    private func focusNextField() {
        switch isKeyboardVisible {
        case .firstName:
            isKeyboardVisible = .lastName
        case .lastName:
            isKeyboardVisible = .jobTitle
        case .email:
            isKeyboardVisible = .phone
        case .jobTitle:
            isKeyboardVisible = .summary
        case .summary:
            isKeyboardVisible = nil
        case .phone:
            isKeyboardVisible = .site
        case .site:
            isKeyboardVisible = .location
        case .location:
            isKeyboardVisible = nil
        case .companyName:
            isKeyboardVisible = .position
        case .position:
            isKeyboardVisible = .location
        case .country:
            isKeyboardVisible = .country
        case .jobDescription:
            isKeyboardVisible = nil
        case .universityName:
            isKeyboardVisible = .degree
        case .degree:
            isKeyboardVisible = nil
        case nil:
            break
        }
    }
}


struct SmallWorkView: View {
    @Binding var work: WorkExperienceInput
    @Binding var workExperiences: [WorkExperienceInput]
    @Binding var showWorkSheet: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(work.companyName)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 16)!))
                
                Text(work.speciality)
                    .lineLimit(1)
                    .foregroundStyle(.cA1A1A1)
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 16)!))
                
            }
            .padding(.leading, 32)
            
            Spacer()
            
            HStack(spacing: 6) {
                Button {
                    
                } label: {
                    Image(.edit)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(CircularButton(opacity: 0.6, color: .c686868))
                
                Button {
                    
                } label: {
                    Image(.trash)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(CircularButton(opacity: 0.6, color: .c686868))
            }
            .padding(.trailing, 3)
            
        }
        .padding(2)
        .frame(height: 72)
        .background(.c393939)
        .clipShape(RoundedRectangle(cornerRadius: 40))
    }
}



struct SmallStudyView: View {
    @Binding var study: EducationInput
    @Binding var educationHistory: [EducationInput]
    @Binding var showWorkSheet: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(study.education)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 16)!))
                
                Text(study.startedDate.monthYearString + " - " + study.endedDate.monthYearString)
                    .lineLimit(1)
                    .foregroundStyle(.cA1A1A1)
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 16)!))
                
            }
            .padding(.leading, 32)
            
            Spacer()
            
            HStack(spacing: 6) {
                Button {
                    
                } label: {
                    Image(.edit)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(CircularButton(opacity: 0.6, color: .c686868))
                
                Button {
                    
                } label: {
                    Image(.trash)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(CircularButton(opacity: 0.6, color: .c686868))
            }
            .padding(.trailing, 3)
            
        }
        .padding(2)
        .frame(height: 72)
        .background(.c393939)
        .clipShape(RoundedRectangle(cornerRadius: 40))
    }
}


