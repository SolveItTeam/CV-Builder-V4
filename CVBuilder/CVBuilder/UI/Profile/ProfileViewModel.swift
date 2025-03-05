import SwiftUI


final class ProfileViewModel: ObservableObject {
    
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
