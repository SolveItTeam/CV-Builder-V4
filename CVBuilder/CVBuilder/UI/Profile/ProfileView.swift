import SwiftUI

enum FocusableField: Hashable {
    case firstName, lastName, email, jobTitle, summary, phone, site, location, companyName, position, country, jobDescription, universityName, degree, skills, languages
    
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
            .onTapGesture {
                isKeyboardVisible = nil
            }
            
            ScrollViewReader { proxy in
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
                        .padding(.horizontal, 3)
                    }
                    .padding(.horizontal, 13)
                    
                    Spacer(minLength: 20)
                }
                .scrollDismissesKeyboard(.interactively)
                
                .onChange(of: isKeyboardVisible) { newField in
                    if let field = newField {
                        withAnimation {
                            proxy.scrollTo(field, anchor: .top)
                        }
                    }
                }
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
            .padding(.bottom, 8)
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
        .sheet(isPresented: $viewModel.showSkillsSheet) {
            SkillsInputView(skills: $viewModel.skills, maxSkillsCount: viewModel.maxSkills) {
                viewModel.showSkillsSheet = false
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
        .sheet(isPresented: $viewModel.showLanguagesSheet) {
            LanguagesInputView(languages: $viewModel.languages, maxLanguagesCount: viewModel.maxLanguages) {
                viewModel.showLanguagesSheet = false
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
        VStack {
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
            
            
            
            MainTextField(placeholder: R.string.localizable.firstName(), text: $viewModel.firstname, isFocused: $isKeyboardVisible, type: .firstName)
                .id(FocusableField.firstName)
                .focused($isKeyboardVisible, equals: .firstName)
            
            MainTextField(placeholder: R.string.localizable.lastName(), text: $viewModel.lastname,  isFocused: $isKeyboardVisible, type: .lastName)
                .id(FocusableField.lastName)
                .focused($isKeyboardVisible, equals: .lastName)
            
            MainTextField(placeholder: R.string.localizable.jobTitle(), text: $viewModel.jobTitle, isFocused: $isKeyboardVisible, type: .jobTitle)
                .id(FocusableField.jobTitle)
            
                .focused($isKeyboardVisible, equals: .jobTitle)
            
            MainTextField(placeholder: R.string.localizable.summary(), text: $viewModel.summary, isFocused: $isKeyboardVisible, type: .summary)
                .id(FocusableField.summary)
                .focused($isKeyboardVisible, equals: .summary)
        }
    }
    
    @ViewBuilder private func contactView() -> some View {
        VStack {
            MainTextField(placeholder: R.string.localizable.mail(), text: $viewModel.email,  isFocused: $isKeyboardVisible, type: .email)
                .id(FocusableField.email)
                .keyboardType(.emailAddress)
                .focused($isKeyboardVisible, equals: .email)
            
            MainTextField(placeholder: R.string.localizable.phoneNumber(), text: $viewModel.phone,  isFocused: $isKeyboardVisible, type: .phone)
                .id(FocusableField.phone)
                .keyboardType(.phonePad)
                .focused($isKeyboardVisible, equals: .phone)
            
            MainTextField(placeholder: R.string.localizable.site(), text: $viewModel.site,  isFocused: $isKeyboardVisible, type: .site)
                .id(FocusableField.site)
                .focused($isKeyboardVisible, equals: .site)
            
            MainTextField(placeholder: R.string.localizable.location(), text: $viewModel.location, isFocused: $isKeyboardVisible, type: .location)
                .id(FocusableField.location)
                .focused($isKeyboardVisible, equals: .location)
            
        }
        .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder private func workExperinceView() -> some View {
        VStack(spacing: 6) {
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
        }
        .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder private func studyView() -> some View {
        
        VStack(spacing: 6) {
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
            
            ForEach($viewModel.educationExperiences, id: \.id) { $education in
                SmallStudyView(study: $education, educationHistory: $viewModel.educationExperiences, showWorkSheet: $viewModel.showEducationSheet)
            }
            
            
        }
        .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder private func skillsView() -> some View {
        VStack {
            HStack {
                Text(R.string.localizable.addSkills())
                    .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                
                Spacer()
                
                if viewModel.skills.count < viewModel.maxSkills {
                        Button {
                            viewModel.showSkillsSheet = true
                        } label: {
                            Image(.plus)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                        }
                        .buttonStyle(CircularButton(opacity: 0.6))
                    }
                
            }
             
            ForEach(viewModel.skills.chunked(into: 2), id: \.self) { pair in
                HStack(spacing: 8) {
                    ForEach(pair) { skill in
                        HStack(spacing: 3) {
                            Text(skill.description)
                                .font(Font(R.font.figtreeRegular.callAsFunction(size: 16)!))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Button {
                                if let index = viewModel.skills.firstIndex(where: { $0.description == skill.description } ) {
                                    viewModel.skills.remove(at: index)
                                }
                            } label: {
                                Image(.crossWithFrame)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                            
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(.c686868)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                    }
                    
                    Spacer()
                    
                }
            }
            
            HStack {
                Text(R.string.localizable.addLanguages())
                    .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                
                Spacer()
                
                if viewModel.languages.count < viewModel.maxLanguages {
                        Button {
                            viewModel.showLanguagesSheet = true
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
                VStack {
                    MainTextField(placeholder: R.string.localizable.companyName(), text: $work.companyName, color: .c686868, isFocused: $isKeyboardVisible, type: .companyName)
                        .id(FocusableField.companyName)
                        .focused($isKeyboardVisible, equals: .companyName)
                    
                    MainTextField(placeholder: R.string.localizable.position(), text: $work.speciality, color: .c686868, isFocused: $isKeyboardVisible, type: .position)
                        .id(FocusableField.position)
                        .focused($isKeyboardVisible, equals: .position)
                    
                    MainTextField(placeholder: R.string.localizable.location(), text: $work.country, color: .c686868, isFocused: $isKeyboardVisible, type: .location)
                        .id(FocusableField.location)
                        .focused($isKeyboardVisible, equals: .location)
                    
                    MainTextField(placeholder: R.string.localizable.startOfEmployment(), text: $formattedDate, color: .c686868, isFocused: $isKeyboardVisible, type: nil)
                    
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
                    
                    MainTextField(placeholder: R.string.localizable.endOfEmployment(), text: $formattedEndDate, color: .c686868,isFocused: $isKeyboardVisible, type: nil)
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
                    
                    MainTextField(placeholder: R.string.localizable.stillWorkingHere(), text: $mockPlaceholder, color: .c686868, isFocused: $isKeyboardVisible, type: nil)
                        .disabled(true)
                        .overlay {
                            Toggle(isOn: $work.stillWorkingHere) {
                                
                            }
                            .toggleStyle(CustomColorToggleStyle())
                            .padding(.trailing, 30)
                        }
                    
                    MainTextEditor(placeholder: R.string.localizable.jobDescription(), text: $work.jobDescirption, color: .c686868, isFocused: $isKeyboardVisible, type: .jobDescription)
                        .id(FocusableField.jobDescription)
                        .focused($isKeyboardVisible, equals: .jobDescription)
                }
                .padding(.top, 2)
                
                Spacer(minLength: 50)
            }
            
            .scrollDismissesKeyboard(.interactively)
            .padding(.top, 10)
            .padding(.horizontal, 2)
            
            Button {
                onSave()
            } label: {
                Text(R.string.localizable.save())
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(couldSave ? .cE1FF41 : .c686868)
                    .foregroundStyle(couldSave ? .blackMain : .cA1A1A1)
                
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .contentShape(Rectangle())
            }

            .disabled(!couldSave)
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, 16)
        .background(.c393939)
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
                VStack {
                    MainTextField(placeholder: R.string.localizable.universityName(), text: $edu.education,  color: .c686868, isFocused: $isKeyboardVisible, type: .universityName)
                        .id(FocusableField.universityName)
                        .focused($isKeyboardVisible, equals: .universityName)
                    
                    MainTextField(placeholder: R.string.localizable.degree(), text: $edu.degree,  color: .c686868, isFocused: $isKeyboardVisible, type: .degree)
                        .id(FocusableField.degree)
                        .focused($isKeyboardVisible, equals: .degree)
                    
                    
                    MainTextField(placeholder: R.string.localizable.startOfEmployment(), text: $formattedStartedDate, color: .c686868, isFocused: $isKeyboardVisible, type: nil)
                        .disabled(true)
                        .overlay {
                            DatePicker("", selection: $edu.startedDate, displayedComponents: .date)
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .scaleEffect(4.0)
                                .colorMultiply(.clear)
                                .onChange(of: edu.startedDate) { newDate in
                                    formattedStartedDate = newDate.monthYearString
                                }
                        }
                        .clipped()
                        .contentShape(Rectangle())
                    
                    
                    MainTextField(placeholder: R.string.localizable.endOfEmployment(), text: $formattedEndDate, color: .c686868, isFocused: $isKeyboardVisible, type: nil)
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
                    
                    MainTextField(placeholder: R.string.localizable.stillStudyingHere(), text: $mockPlaceholder, color: .c686868, isFocused: $isKeyboardVisible, type: nil)
                        .disabled(true)
                        .overlay {
                            Toggle(isOn: $edu.stillStudyingHere) { }
                                .toggleStyle(CustomColorToggleStyle())
                                .padding(.trailing, 30)
                        }
                }
                .padding(.top, 2)
                
                Spacer(minLength: 50)
            }
            .scrollDismissesKeyboard(.interactively)
            .padding(.top, 10)
            .padding(.horizontal, 2)
            
            Button {
                onSave()
            } label: {
                Text(R.string.localizable.save())
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(couldSave ? .cE1FF41 : .c686868)
                    .foregroundStyle(couldSave ? .blackMain : .cA1A1A1)
                
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .contentShape(Rectangle())
            }

            .disabled(!couldSave)
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, 16)
        .background(.c393939)
    }
}

struct SkillsInputView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var skills: [SkillInput]
    @FocusState var isKeyboardVisible: FocusableField?
    @State var input: String =  ""
    let maxSkillsCount: Int
    var onSave: () -> Void

    var couldSave: Bool {
        return !skills.isEmpty
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
                VStack(alignment: .leading) {
                    MainTextFieldWithAction(placeholder: R.string.localizable.addSkills(), text: $input,  color: .c686868, isFocused: $isKeyboardVisible, type: .universityName) {
                        skills.append(SkillInput(description: input))
                        input.removeAll()
                    }
                    .id(FocusableField.universityName)
                    .focused($isKeyboardVisible, equals: .skills)
                    .disabled(skills.count == maxSkillsCount)
                    .opacity(skills.count == maxSkillsCount ? 0.4 : 1)
                    
                    ForEach(skills.chunked(into: 2), id: \.self) { pair in
                        HStack(spacing: 8) {
                            ForEach(pair) { skill in
                                HStack(spacing: 3) {
                                    Text(skill.description)
                                        .font(Font(R.font.figtreeRegular.callAsFunction(size: 16)!))
                                        .foregroundStyle(.white)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Button {
                                        if let index = skills.firstIndex(where: { $0.description == skill.description } ) {
                                            skills.remove(at: index)
                                        }
                                    } label: {
                                        Image(.crossWithFrame)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                    }
                                    
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(.c686868)
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                            }
                            
                            Spacer()

                        }

                    }
                }
                .padding(.top, 2)
                
                Spacer(minLength: 50)
            }
            .scrollDismissesKeyboard(.interactively)
            .padding(.top, 10)
            .padding(.horizontal, 2)
            
            Button {
                onSave()
            } label: {
                Text(R.string.localizable.save())
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(couldSave ? .cE1FF41 : .c686868)
                    .foregroundStyle(couldSave ? .blackMain : .cA1A1A1)
                
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .contentShape(Rectangle())
            }

            .disabled(!couldSave)
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, 16)
        .background(.c393939)
    }
}


struct LanguagesInputView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var languages: [Language]
    @FocusState var isKeyboardVisible: FocusableField?
    @State var input: String =  ""
    let maxLanguagesCount: Int
    var onSave: () -> Void
    
    
    var couldSave: Bool {
        return !languages.isEmpty
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
                VStack {
                    MainTextFieldWithAction(placeholder: R.string.localizable.addLanguages(), text: $input,  color: .c686868, isFocused: $isKeyboardVisible, type: .universityName) {
                        languages.append(Language(name: input))
                        input.removeAll()
                    }
                        .id(FocusableField.universityName)
                        .focused($isKeyboardVisible, equals: .skills)
                        .disabled(languages.count == maxLanguagesCount)
                        .opacity(languages.count == maxLanguagesCount ? 0.4 : 1)
                        
                    ForEach(languages.chunked(into: 2), id: \.self) { pair in
                        HStack(spacing: 8) {
                            ForEach(pair) { language in
                                HStack(spacing: 3) {
                                    Text(language.name)
                                        .font(Font(R.font.figtreeRegular.callAsFunction(size: 16)!))
                                        .foregroundStyle(.white)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Button {
                                        if let index = languages.firstIndex(where: { $0.name == language.name } ) {
                                            languages.remove(at: index)
                                        }
                                    } label: {
                                        Image(.crossWithFrame)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                    }
                                    
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(.c686868)
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                            }
                            
                            Spacer()

                        }
                    }
                }
                .padding(.top, 2)
                
                Spacer(minLength: 50)
            }
            .scrollDismissesKeyboard(.interactively)
            .padding(.top, 10)
            .padding(.horizontal, 2)
            
            Button {
                onSave()
            } label: {
                Text(R.string.localizable.save())
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(couldSave ? .cE1FF41 : .c686868)
                    .foregroundStyle(couldSave ? .blackMain : .cA1A1A1)
                
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .contentShape(Rectangle())
            }

            .disabled(!couldSave)
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, 16)
        .background(.c393939)
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


