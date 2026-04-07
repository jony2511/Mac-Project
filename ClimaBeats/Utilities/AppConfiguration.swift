import Foundation

enum AppConfiguration {
    // Prefer environment variable, then fallback for local development.
    static var openWeatherAPIKey: String {
        let fromEnvironment = ProcessInfo.processInfo.environment["OPENWEATHER_API_KEY"] ?? ""
        if !fromEnvironment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return fromEnvironment
        }

        return "8215026a6bfc34d7860e9a5bf67f137f"
    }
}
