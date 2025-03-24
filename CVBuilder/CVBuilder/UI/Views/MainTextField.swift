import SwiftUI

struct MainTextField: View {
    let placeholder: String
    @Binding var text: String
    @FocusState.Binding var isFocused: FocusableField?
    let type: FocusableField?
    let color: Color
    
    init(placeholder: String, text: Binding<String>, color: Color = .c393939, isFocused: FocusState<FocusableField?>.Binding, type: FocusableField?) {
        self.placeholder = placeholder
        _isFocused = isFocused
        self.type = type
        self.color = color
        _text = text
    }
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder)
            .foregroundColor(.cA1A1A1))
        .padding(.horizontal, 24)
        .padding(.vertical, 26)
        .font(Font(R.font.figtreeRegular.callAsFunction(size: 16)!))
        .textFieldStyle(.plain)
        .multilineTextAlignment(.leading)
        .foregroundStyle(.white)
        .lineLimit(1)
        .submitLabel(.return)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .onChange(of: text) { newValue in
            if newValue.count > 100 {
                text = String(newValue.prefix(100))
            }
        }
        .overlay {
            if type == isFocused && type != nil {
                RoundedRectangle(cornerRadius: 40)
                    .stroke(.cE1FF41, lineWidth: 1)
            }
        }
    }
}

struct MainTextFieldWithAction: View {
    let placeholder: String
    @Binding var text: String
    @FocusState.Binding var isFocused: FocusableField?
    let type: FocusableField?
    let color: Color
    let action: () -> Void
    
    init(placeholder: String, text: Binding<String>, color: Color = .c393939, isFocused: FocusState<FocusableField?>.Binding, type: FocusableField?, action: @escaping () -> Void) {
        self.placeholder = placeholder
        _isFocused = isFocused
        self.type = type
        self.color = color
        _text = text
        self.action = action
    }
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder)
            .foregroundColor(.cA1A1A1))
        .padding(.horizontal, 24)
        .padding(.vertical, 26)
        .font(Font(R.font.figtreeRegular.callAsFunction(size: 16)!))
        .textFieldStyle(.plain)
        .multilineTextAlignment(.leading)
        .foregroundStyle(.white)
        .lineLimit(1)
        .submitLabel(.return)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .onChange(of: text) { newValue in
            if newValue.count > 100 {
                text = String(newValue.prefix(100))
            }
        }
        .overlay {
            if type == isFocused && type != nil {
                RoundedRectangle(cornerRadius: 40)
                    .stroke(.cE1FF41, lineWidth: 1)
            }
        }
        .overlay(alignment: .trailing) {
            Button {
                action()
            } label: {
                Circle()
                    .fill(text.isEmpty ? .cA1A1A1 : .cE1FF41)
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(.plus)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(text.isEmpty ? .c686868 : .blackMain)
                            .frame(width: 12, height: 12)
                    }
                    .padding(.trailing, 4)
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
}


struct MainTextEditor: View {
    let placeholder: String
    @Binding var text: String
    let color: Color
    @FocusState.Binding var isFocused: FocusableField?
    let type: FocusableField?
    init(placeholder: String, text: Binding<String>, color: Color = .c393939, isFocused: FocusState<FocusableField?>.Binding, type: FocusableField?) {
        self.placeholder = placeholder
        _isFocused = isFocused
        self.type = type
        self.color = color
        _text = text
    }
    
    var body: some View {
        TextEditor( text: $text)
        .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .autocapitalization(.sentences)
        .font(Font(R.font.figtreeRegular.callAsFunction(size: 16)!))
        .textFieldStyle(.plain)
        .multilineTextAlignment(.leading)
        .foregroundStyle(.white)
        .submitLabel(.return)
        .background(color)
        .frame(height: 196)
        .overlay(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(Font(R.font.figtreeRegular.callAsFunction(size: 16)!))
                    .foregroundStyle(.cA1A1A1)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 18)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 48))
        .onChange(of: text) { newValue in
            if newValue.count > 300 {
                text = String(newValue.prefix(300))
            }
        }
        .overlay {
            if type == isFocused {
                RoundedRectangle(cornerRadius: 48)
                    .stroke(.cE1FF41, lineWidth: 1)
            }
        }
    }
}



enum ProfileDataType: CaseIterable {
    case profile
    case contact
    case workExperience
    case education
    case skills
    
    var icon: ImageResource {
        switch self {
        case .profile:
            return .profile2
        case .contact:
            return .mail
        case .workExperience:
            return .job
        case .education:
            return .study
        case .skills:
            return .light
        }
    }
    
    var localizedTitle: String {
        switch self {
        case .profile:
            return R.string.localizable.profile()
        case .contact:
            return R.string.localizable.contact()
        case .workExperience:
            return R.string.localizable.workExperiance()
        case .education:
            return R.string.localizable.education()
        case .skills:
            return R.string.localizable.skills()
        }
    }
    
    var index: Int {
        switch self {
        case .profile:
            return 0
        case .contact:
            return 1
        case .workExperience:
            return 2
        case .education:
            return 3
        case .skills:
            return 4
        }
    }
}
