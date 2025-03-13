import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @FocusState var isKeyboardVisible: Bool
    
    
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
                    
                    // TabView(selection: $viewModel.profileData) {
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
                    
                    //profileInfoView()
                    //  .tag(ProfileDataType.profile)
                    //   contactView()
                    //  .tag(ProfileDataType.contact)
                    //    workExperinceView()
                    //   .tag(ProfileDataType.workExperience)
                    //   studyView()
                    //   .tag(ProfileDataType.education)
                    //   skillsView()
                    //     .tag(ProfileDataType.skills)
                    //                }
                    //                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    //                .indexViewStyle(.page(backgroundDisplayMode: .never))
                }
                .padding(.horizontal, 16)
            }
            
            HStack(spacing: 14) {
                Button {
                    
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
            DutiesInputView(duties: $viewModel.newDuties) {
//                viewModel.workExperiences.append(WorkExperienceInput(duties: viewModel.newDuties))
//                viewModel.newDuties = [""]
//                viewModel.showWorkSheet = false
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
            
            
            
            MainTextField(placeholder: R.string.localizable.firstName(), text: $viewModel.firstname, isKeyboadVisible: $isKeyboardVisible)
            
            MainTextField(placeholder: R.string.localizable.lastName(), text: $viewModel.lastname, isKeyboadVisible: $isKeyboardVisible)
            
            MainTextField(placeholder: R.string.localizable.jobTitle(), text: $viewModel.jobTitle, isKeyboadVisible: $isKeyboardVisible)
            
            MainTextField(placeholder: R.string.localizable.summary(), text: $viewModel.summary, isKeyboadVisible: $isKeyboardVisible)
            
            
        }
        
        
    }
    
    @ViewBuilder private func contactView() -> some View {
        VStack {
            MainTextField(placeholder: R.string.localizable.mail(), text: $viewModel.email, isKeyboadVisible: $isKeyboardVisible)
            
            MainTextField(placeholder: R.string.localizable.phoneNumber(), text: $viewModel.phone, isKeyboadVisible: $isKeyboardVisible)
            
            MainTextField(placeholder: R.string.localizable.site(), text: $viewModel.site, isKeyboadVisible: $isKeyboardVisible)
            
            MainTextField(placeholder: R.string.localizable.location(), text: $viewModel.location, isKeyboadVisible: $isKeyboardVisible)
        }
        .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder private func workExperinceView() -> some View {
        // MARK: Work Experience Section
//        VStack {
//            HStack {
//                Text(R.string.localizable.addWork)
//                    .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
//                Spacer()
//                if viewModel.workExperiences.count < viewModel.maxWorkExperience {
//                    Button {
//                        viewModel.showWorkSheet = true
//                    } label: {
//                        Image(.plus)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 14, height: 14)
//                    }
//                    .buttonStyle(CircularButton(opacity: 0.6))
//                }
//            }
//            
//            ForEach($viewModel.workExperiences) { $work in
//                VStack(alignment: .leading, spacing: 8) {
//                    TextField("Speciality", text: $work.speciality)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    TextField("Company Name", text: $work.companyName)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    TextField("Country", text: $work.country)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    DatePicker("Start Date", selection: $work.workStartedDate, displayedComponents: .date)
//                    DatePicker("End Date", selection: $work.workEndedDate, displayedComponents: .date)
//                        .background(.clear)
//                    
//                    SmallWorkView(duties: $work.duties)
//                }
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
//            }
//        }
//        .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder private func studyView() -> some View {
        VStack {
            HStack {
                Text("Education")
                    .font(.headline)
                Spacer()
                if viewModel.educationExperiences.count < viewModel.maxEducation {
                    Button {
                        viewModel.educationExperiences.append(EducationInput())
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                }
            }
            ForEach($viewModel.educationExperiences) { $edu in
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
        .transition(.move(edge: .trailing))
    }
    
    @ViewBuilder private func skillsView() -> some View {
        VStack {
            HStack {
                Text("Skills")
                    .font(.headline)
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
}

#Preview {
    ProfileView(viewModel: .init(coordinator: .init()))
}

struct DutiesInputView: View {
    @Binding var duties: [String]
    var onSave: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(duties.indices, id: \.self) { index in
                HStack {
                    TextField("Duty \(index + 1)", text: $duties[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if duties.count > 1 {
                        Button(action: {
                            duties.remove(at: index)
                        }) {
                            Image(systemName: "minus.circle")
                        }
                    }
                }
            }
            
            if duties.count < 4 {
                Button(action: {
                    duties.append("")
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add Duty")
                    }
                }
            } else {
                Text("Maximum 10 duties reached")
                    .foregroundColor(.red)
            }
            
            Button {
                onSave()
            } label: {
                Text(R.string.localizable.save())
                
            }
        }
    }
}


struct SmallWorkView: View {
    @Binding var duties: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(duties.indices, id: \.self) { index in
                HStack {
                    TextField("Duty \(index + 1)", text: $duties[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if duties.count > 1 {
                        Button(action: {
                            duties.remove(at: index)
                        }) {
                            Image(systemName: "minus.circle")
                        }
                    }
                }
            }
            
        
        }
    }
}


