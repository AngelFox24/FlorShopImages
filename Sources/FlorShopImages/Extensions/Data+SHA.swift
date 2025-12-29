import Foundation
import Crypto

extension Data {
    func sha256String() -> String {
        let digest = SHA256.hash(data: self)
        return digest.hex
    }
}
