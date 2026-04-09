import Foundation
import LocalAuthentication

/// Manages optional Face ID / Touch ID authentication for the privacy lock.
/// Authentication is opt-in. If disabled or unavailable, the app opens normally.
@Observable
final class AuthService {

    private(set) var isAuthenticated: Bool = false
    private(set) var isAuthenticationRequired: Bool = false

    private let context = LAContext()

    // MARK: - Setup

    func configure(requireAuthentication: Bool) {
        isAuthenticationRequired = requireAuthentication
        if !requireAuthentication {
            isAuthenticated = true
        }
    }

    // MARK: - Authentication

    var isBiometricAvailable: Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    var biometricType: LABiometryType {
        context.biometryType
    }

    func authenticate() async throws {
        guard isAuthenticationRequired else {
            isAuthenticated = true
            return
        }

        let reason = "Unlock Personal Progress to access your reflections."
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            isAuthenticated = success
        } catch {
            isAuthenticated = false
            throw error
        }
    }

    func lock() {
        if isAuthenticationRequired {
            isAuthenticated = false
        }
    }
}
