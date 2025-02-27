import FirebaseCore
import Foundation
import FirebaseRemoteConfig

final class AppRemoteConfigService: ObservableObject {
    static let shared = AppRemoteConfigService()
    
    @Published var config: AppRemoteConfig
    @Published var firebaseConfig: RemoteConfig
    
    private let decoder: JSONDecoder
    
    private init() {
        self.config = .default
        self.firebaseConfig = RemoteConfig.remoteConfig()
        self.decoder = .basic
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = .zero
        self.firebaseConfig.configSettings = settings
    }
    
    func startFetching() async throws {
        do {
            let config = try await firebaseConfig.fetchAndActivate()
            switch config {
            case .successFetchedFromRemote, .successUsingPreFetchedData:
                let jsonData = self.firebaseConfig.configValue(forKey: "RemoteConfig").dataValue
                
                do {
                    let decodedConfig = try JSONDecoder().decode (AppRemoteConfig.self, from: jsonData)
                    await MainActor.run { [weak self] in
                        self?.config = decodedConfig
                    }
                    
                } catch {
                    print("Error decoding: \(error.localizedDescription)")
                    await MainActor.run { [weak self] in
                        self?.config = .default
                    }
                    return
                }
            default:
                await MainActor.run { [weak self] in
                    self?.config = .default
                }
                print("Error activating")
                return
            }
        } catch let error {
            await MainActor.run { [weak self] in
                self?.config = .default
            }
            print ("Error fetching: \(error.localizedDescription)")
        }
    }
}
