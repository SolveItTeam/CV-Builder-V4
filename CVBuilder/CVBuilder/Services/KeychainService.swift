import Foundation
import KeychainAccess

final class KeychainService {
    private enum Models: String, CodingKey {
        case user
    }
    
    @KeychainService.Value(
        key: Models.user,
        encoder: .basic,
        decoder: .basic
    )
    
    var user: User?
    
    func clear() {
        _user.clear()
    }
}

extension KeychainService {
    @propertyWrapper
    struct Value<Element: Codable, Key: CodingKey> {
        private let key: Key
        private let keychain: Keychain
        private let decoder: JSONDecoder
        private let encoder: JSONEncoder
        
        public var wrappedValue: Element? {
            get { readAndDecode(for: key) }
            set {
                guard let object = newValue else {
                    try? keychain.remove(key.stringValue)
                    return
                }
                encodeAndSave(object, for: key)
            }
        }
        
        //MARK: - Initialization
        init(
            key: Key,
            encoder: JSONEncoder,
            decoder: JSONDecoder
        ) {
            let service = Bundle.main.bundleIdentifier ?? "KeychainService"
            self.keychain = .init(service: service).synchronizable(true)
            self.key = key
            self.encoder = encoder
            self.decoder = decoder
        }
        
        //MARK: - Save/Read data
        private func readAndDecode(for key: Key) -> Element? {
            do {
                guard let data = try keychain.getData(key.stringValue) else {
                    return nil
                }
                return try decoder.decode(Element.self, from: data)
            } catch let error {
                print("KeychainService.Value of type: \(Element.self) decode error: \(error.localizedDescription)")
                return nil
            }
        }
    
        private func encodeAndSave(
            _ value: Element,
            for key: Key
        ) {
            do {
                let data = try encoder.encode(value)
                try keychain.set(
                    data,
                    key: key.stringValue
                )
            } catch let error {
                print("KeychainService.Value of type: \(Element.self) encode/save error: \(error.localizedDescription)")
            }
        }
        
        func clear() {
            try? keychain.remove(key.stringValue)
        }
    }
}
