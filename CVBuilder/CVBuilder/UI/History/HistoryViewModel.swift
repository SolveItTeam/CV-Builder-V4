import SwiftUI


final class HistoryViewModel: ObservableObject {
    
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
