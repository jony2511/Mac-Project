import Foundation

// MARK: - Domain Models

struct WeatherSnapshot: Identifiable {
    let id = UUID()
    let cityName: String
    let temperatureCelsius: Double
    let condition: WeatherCondition
    let humidity: Int
    let windSpeedKPH: Double
}

enum WeatherCondition: String {
    case sunny
    case cloudy
    case rainy
    case stormy
    case snowy

    var title: String {
        switch self {
        case .sunny:
            return "Sunny"
        case .cloudy:
            return "Cloudy"
        case .rainy:
            return "Rainy"
        case .stormy:
            return "Stormy"
        case .snowy:
            return "Snowy"
        }
    }

    var sfSymbol: String {
        switch self {
        case .sunny:
            return "sun.max.fill"
        case .cloudy:
            return "cloud.fill"
        case .rainy:
            return "cloud.rain.fill"
        case .stormy:
            return "cloud.bolt.rain.fill"
        case .snowy:
            return "snow"
        }
    }
}

struct MusicRecommendation: Identifiable {
    let id = UUID()
    let playlistTitle: String
    let mood: String
    let artistHighlight: String
    let reason: String
}
