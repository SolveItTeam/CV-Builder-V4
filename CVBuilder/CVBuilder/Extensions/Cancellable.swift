import Foundation
import Combine

final class Cancellable {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()
    
    @resultBuilder
    struct Builder {
        public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
    
    deinit {
        cancel()
    }
    
    func cancel() {
        subscriptions.removeAll()
    }
    
    func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancellables())
    }
}

extension AnyCancellable {
    func store(in cancelBag: Cancellable) {
        cancelBag.subscriptions.insert(self)
    }
}

extension Publisher {
    func toResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self.map(Result.success)
            .catch({ Just(.failure($0)) })
            .eraseToAnyPublisher()
    }
}
