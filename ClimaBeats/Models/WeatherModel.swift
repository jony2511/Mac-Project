import Foundation

// MARK: - OpenWeatherMap Response Models

struct WeatherModel: Codable {
    let name: String
    let weather: [WeatherInfo]
    let main: MainInfo
    let wind: WindInfo

    struct WeatherInfo: Codable {
        let main: String
        let description: String
    }

    struct MainInfo: Codable {
        let temp: Double
        let humidity: Int
    }

    struct WindInfo: Codable {
        let speed: Double
    }
}
