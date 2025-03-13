import SwiftUI

struct MainTextField: View {
    let placeholder: String
    @Binding var text: String
    @FocusState.Binding var isKeyboadVisible: Bool
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder)
            .foregroundColor(.cA1A1A1))
        .padding(.horizontal, 24)
        .padding(.vertical, 26)
        .focused($isKeyboadVisible)
        .autocapitalization(.sentences)
        .font(Font(R.font.figtreeRegular.callAsFunction(size: 16)!))
        .textFieldStyle(.plain)
        .multilineTextAlignment(.leading)
        .foregroundStyle(.white)
        .lineLimit(1)
        .submitLabel(.return)
        .background(.c393939)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .onChange(of: text) { newValue in
            if newValue.count > 100 {
                text = String(newValue.prefix(100))
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
