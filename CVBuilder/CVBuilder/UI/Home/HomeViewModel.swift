import SwiftUI


final class HomeViewModel: ObservableObject {
    
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
