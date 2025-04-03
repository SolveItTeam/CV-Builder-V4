import SwiftUI

struct CoverLetterView: View {
    @ObservedObject var viewModel: CoverLetterViewModel
    @State private var iscvHistoryPresented: Bool = false
    @State private var isFillCoverLetterPresented: Bool = false
    @FocusState private var isKeyboardVisible: FocusableField?
    
    var body: some View {
        VStack {
            NavBar(showProIcon: $viewModel.showProIcon) {
                viewModel.showPaywall()
            }
            .padding(.horizontal, 16)
            
            ScrollView {
                HStack {
                    Text(R.string.localizable.myCoverLetters())
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)
                
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.coverLetterItems.enumerated()), id: \.element.id) { index, item in
                        coverCard(item: item, index: index)
                    }
                    
                    Spacer(minLength: 50)
                    
                }
                .padding(.horizontal, 16)
            }
            .overlay {
                if viewModel.coverLetterItems.isEmpty {
                    VStack(spacing: 16) {
                        emptyStateView
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .sheet(isPresented: $iscvHistoryPresented) {
            VStack {
                HStack {
                    Button {
                        iscvHistoryPresented = false
                    } label: {
                        Image(.cross)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                    }
                    .buttonStyle(CircularButton(opacity: 0.3, color: .c686868))
                    .padding(.top, 20)
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
                
                ScrollView {
                    HStack {
                        Text(R.string.localizable.selectYourResume)
                            .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 16)
                    
                    VStack(spacing: 24) {
                        ForEach(Array(viewModel.historyItems.enumerated()), id: \.element.id) { index, item in
                            cvCard(item: item, index: index)
                        }
                    }
                }
                
                VStack(spacing: 16) {
                    Button {
                        iscvHistoryPresented = false
                    } label: {
                        Text(R.string.localizable.notNow())
                            .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                        
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .overlay {
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(.cE1FF41, lineWidth: 1)
                            }
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    
                    Button {
                        isFillCoverLetterPresented = true
                    } label: {
                        Text(R.string.localizable.select())
                            .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                            .foregroundStyle(viewModel.selectedCV != nil ? .blackMain : .cA1A1A1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(viewModel.selectedCV != nil ? .cE1FF41 : .c686868)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .contentShape(Rectangle())
                            .disabled(viewModel.selectedCV == nil)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                .padding(.bottom, 8)
                .padding(.horizontal, 16)
            }
            .presentationDetents([.fraction(0.985)])
            .presentationDragIndicator(.visible)
            .background(.c393939)
            .if(true) { view in
                Group {
                    if #available(iOS 16.4, *) {
                        view.presentationCornerRadius(32)
                    } else {
                        view
                    }
                }
            }
            .sheet(isPresented: $isFillCoverLetterPresented) {
                VStack {
                    HStack {
                        Button {
                            viewModel.isCloseResumeAlert = true
                        } label: {
                            Image(.cross)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                        }
                        .buttonStyle(CircularButton(opacity: 0.3, color: .c686868))
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                        
                        Spacer()
                    }
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            MainTextField(placeholder: R.string.localizable.firstName(),  text: $viewModel.firstname,  color: .c686868, isFocused: $isKeyboardVisible, type: .firstName)
                                .id(FocusableField.firstName)
                                .focused($isKeyboardVisible, equals: .firstName)
                            
                            MainTextField(placeholder: R.string.localizable.lastName(), text: $viewModel.lastname,  color: .c686868, isFocused: $isKeyboardVisible, type: .lastName)
                                .id(FocusableField.lastName)
                                .focused($isKeyboardVisible, equals: .lastName)
                            
                            MainTextField(placeholder: R.string.localizable.jobTitle(), text: $viewModel.jobTitle, color: .c686868, isFocused: $isKeyboardVisible, type: .jobTitle)
                                .id(FocusableField.jobTitle)
                                .focused($isKeyboardVisible, equals: .jobTitle)
                            
                            MainTextField(placeholder: R.string.localizable.mail(), text: $viewModel.email, color: .c686868, isFocused: $isKeyboardVisible, type: .email)
                                .id(FocusableField.email)
                                .focused($isKeyboardVisible, equals: .email)
                            
                            MainTextField(placeholder: R.string.localizable.phoneNumber(), text: $viewModel.phone, color: .c686868, isFocused: $isKeyboardVisible, type: .phone)
                                .id(FocusableField.phone)
                                .focused($isKeyboardVisible, equals: .phone)
                            
                            MainTextField(placeholder: R.string.localizable.site(), text: $viewModel.site, color: .c686868, isFocused: $isKeyboardVisible, type: .site)
                                .id(FocusableField.site)
                                .focused($isKeyboardVisible, equals: .site)
                            
                            MainTextEditor(placeholder: R.string.localizable.summary(), text: $viewModel.summary, color: .c686868, isFocused: $isKeyboardVisible, type: .summary)
                                .id(FocusableField.summary)
                                .focused($isKeyboardVisible, equals: .summary)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Button {
                        //createcvCoverz
                    } label: {
                        Text(R.string.localizable.finish())
                            .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                            .foregroundStyle(viewModel.selectedCV != nil ? .blackMain : .cA1A1A1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(viewModel.selectedCV != nil ? .cE1FF41 : .c686868)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .contentShape(Rectangle())
                            .disabled(viewModel.selectedCV == nil)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.horizontal, 16)
                }
                .onAppear {
                    viewModel.prefill()
                }
                .presentationDetents([.fraction(0.985)])
                .presentationDragIndicator(.visible)
                .background(.c393939)
                .if(true) { view in
                    Group {
                        if #available(iOS 16.4, *) {
                            view.presentationCornerRadius(32)
                        } else {
                            view
                        }
                    }
                }
                .alert(R.string.localizable.clr(), isPresented: $viewModel.isCloseResumeAlert, actions:  {
                    Button(R.string.localizable.saveTemplate(), action: {
                        viewModel.saveCoverLetterChanges()
                        isFillCoverLetterPresented = false
                        
                        iscvHistoryPresented = false
                    })
                    Button(R.string.localizable.exitWithoutSaving(), action: {
                        isFillCoverLetterPresented = false
                        iscvHistoryPresented = false
                    })
                    Button(R.string.localizable.cancel(), role: .cancel, action: {
                        
                    })
                }, message: {
                    Text(R.string.localizable.areyousurecl())
                })
            }
        }
        
    }
    
    @ViewBuilder
    private func coverCard(item: CoverLetterItem, index: Int) -> some View {
        Button {
            // viewModel.openResultView(historyItem: item)
        } label: {
            ZStack {
                AngledNotchCardShape(
                    cornerRadius: 32,
                    topAngleInset: 24,
                    topAngleHeight: 14,
                    centerWidth: 60
                )
                .fill(fillColor(for: index))
                .frame(height: 120)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.jobTitle ?? R.string.localizable.untitled())
                            .font(Font(R.font.figtreeSemiBold(size: 20)!))
                            .foregroundColor(textColor(for: index))
                        
                        HStack {
                            Text(item.fullName ?? R.string.localizable.unnamed())
                                .font(Font(R.font.figtreeRegular(size: 16)!))
                                .foregroundColor(textColor(for: index))
                            
                            
                            Text(" |  " + formattedDate(item.creationDate ?? Date()))
                                .font(Font(R.font.figtreeRegular(size: 16)!))
                                .foregroundColor(textColor(for: index))
                        }
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button {
                        } label: {
                            Text(R.string.localizable.edit)
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                            Image(systemName: "square.and.pencil")
                        }
                        
                        Button {
                            // Rename action here.
                        } label: {
                            Text(R.string.localizable.rename)
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                            Image(systemName: "square.and.arrow.up")
                        }
                        
                        Button(role: .destructive) {
                            viewModel.deleteItem(item)
                        } label: {
                            Text(R.string.localizable.delete())
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                            Image(systemName: "trash")
                        }
                        
                    } label: {
                        Circle()
                            .fill(menuColor(for: index))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(.moreV)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 14, height: 14)
                                    .foregroundStyle(.blackMain)
                            )
                    }
                    .frame(alignment: .trailing)
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    @ViewBuilder
    private func cvCard(item: HistoryItem, index: Int) -> some View {
        Button {
            viewModel.selectedCV = item
        } label: {
            ZStack {
                HStack(alignment: .top, spacing: 6) {
                    
                    if viewModel.selectedCV == item {
                        Image(.radio)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    } else {
                        Image(.radioUnchecled)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.jobTitle ?? R.string.localizable.untitled())
                            .font(Font(R.font.figtreeSemiBold(size: 20)!))
                            .foregroundColor(textColor(for: index))
                        
                        HStack {
                            Text(item.fullName ?? R.string.localizable.unnamed())
                                .font(Font(R.font.figtreeRegular(size: 16)!))
                                .foregroundColor(textColor(for: index))
                            
                            
                            Text(" |  " + formattedDate(item.creationDate ?? Date()))
                                .font(Font(R.font.figtreeRegular(size: 16)!))
                                .foregroundColor(textColor(for: index))
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 16)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private func fillColor(for index: Int) -> Color {
        return Color(.c393939)
    }
    
    private func textColor(for index: Int) -> Color {
        return Color(.white)
    }
    
    private func menuColor(for index: Int) -> Color {
        return Color(.c686868).opacity(0.3)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: date)
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Circle().fill(.c393939.opacity(0.6))
                .frame(width: 120, height: 120)
                .overlay {
                    Image(.noHistory)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 78.33)
                }
            
            Text(R.string.localizable.itSEmptyHereYet)
                .font(Font(R.font.figtreeRegular.callAsFunction(size: 20)!))
                .padding(.top, 16)
            
            Text(R.string.localizable.crewesert)
                .font(Font(R.font.figtreeRegular.callAsFunction(size: 16)!))
                .foregroundStyle(.cA1A1A1)
                .padding(.top, 8)
            
            
            Button {
                iscvHistoryPresented = true
            } label: {
                Text(R.string.localizable.create())
                    .font(Font(R.font.figtreeSemiBold(size: 20)!))
                    .foregroundColor(.blackMain)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.cE1FF41)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .contentShape(Rectangle())
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.top, 20)
        }
    }
}

