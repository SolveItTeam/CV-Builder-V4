import UIKit

struct Config: Decodable {
    let appId: String
    let privacy: String
    let terms: String
    let email: String
    let adapty: String
}

struct ConfigValues {
    static func getValue() -> Config {
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "plist") else {
            fatalError("Could not finde Congig.plist in your Bundle")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            return try decoder.decode(Config.self, from: data)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
