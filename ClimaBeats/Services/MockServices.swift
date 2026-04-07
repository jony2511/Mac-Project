import Foundation

// MARK: - Weather Service

protocol WeatherServiceProtocol {
    func fetchCurrentWeather(for city: String) async throws -> WeatherSnapshot
}

struct MockWeatherService: WeatherServiceProtocol {
    func fetchCurrentWeather(for city: String) async throws -> WeatherSnapshot {
        let samples: [WeatherSnapshot] = [
            WeatherSnapshot(cityName: city, temperatureCelsius: 29, condition: .sunny, humidity: 42, windSpeedKPH: 8.5),
            WeatherSnapshot(cityName: city, temperatureCelsius: 21, condition: .cloudy, humidity: 58, windSpeedKPH: 11.0),
            WeatherSnapshot(cityName: city, temperatureCelsius: 17, condition: .rainy, humidity: 79, windSpeedKPH: 14.2),
            WeatherSnapshot(cityName: city, temperatureCelsius: 11, condition: .stormy, humidity: 86, windSpeedKPH: 25.0),
            WeatherSnapshot(cityName: city, temperatureCelsius: -1, condition: .snowy, humidity: 75, windSpeedKPH: 9.8)
        ]

        try? await Task.sleep(nanoseconds: 300_000_000)
        return samples.randomElement() ?? samples[0]
    }
}

// MARK: - Recommendation Service

protocol MusicRecommendationServiceProtocol {
    func recommendation(for weather: WeatherSnapshot) -> MusicRecommendation
}

struct MockMusicRecommendationService: MusicRecommendationServiceProtocol {
    func recommendation(for weather: WeatherSnapshot) -> MusicRecommendation {
        switch weather.condition {
        case .sunny:
            return MusicRecommendation(
                playlistTitle: "Golden Hour Drive",
                mood: "Uplifting",
                artistHighlight: "Dua Lipa",
                reason: "Bright weather pairs well with energetic pop and feel-good beats."
            )
        case .cloudy:
            return MusicRecommendation(
                playlistTitle: "City Cloud Lo-Fi",
                mood: "Calm",
                artistHighlight: "Nujabes",
                reason: "Soft, steady rhythms match overcast and reflective moments."
            )
        case .rainy:
            return MusicRecommendation(
                playlistTitle: "Rain Window Sessions",
                mood: "Cozy",
                artistHighlight: "Billie Eilish",
                reason: "Rainy ambience works well with intimate vocals and mellow textures."
            )
        case .stormy:
            return MusicRecommendation(
                playlistTitle: "Electric Skies",
                mood: "Intense",
                artistHighlight: "The Weeknd",
                reason: "Storm energy calls for bold synth lines and dramatic tempo."
            )
        case .snowy:
            return MusicRecommendation(
                playlistTitle: "Winter Echoes",
                mood: "Ambient",
                artistHighlight: "Sigur Ros",
                reason: "Snowy scenes feel immersive with atmospheric and spacious soundscapes."
            )
        }
    }
}
