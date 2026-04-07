import Foundation

enum WeatherServiceError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailure
    case networkFailure

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OpenWeatherMap API key is missing."
        case .invalidURL:
            return "Failed to build weather request URL."
        case .invalidResponse:
            return "The weather server returned an invalid response."
        case .httpError(let statusCode):
            return "The weather server returned status code \(statusCode)."
        case .decodingFailure:
            return "Unable to parse weather data."
        case .networkFailure:
            return "Network request failed. Please check your connection."
        }
    }
}

final class WeatherService: WeatherServiceProtocol {
    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func fetchCurrentWeather(for city: String) async throws -> WeatherSnapshot {
        let sanitizedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !sanitizedKey.isEmpty else {
            throw WeatherServiceError.missingAPIKey
        }

        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: sanitizedKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw WeatherServiceError.networkFailure
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherServiceError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw WeatherServiceError.httpError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()

        let weatherModel: WeatherModel
        do {
            weatherModel = try decoder.decode(WeatherModel.self, from: data)
        } catch {
            throw WeatherServiceError.decodingFailure
        }

        return weatherModel.toWeatherSnapshot()
    }
}

private extension WeatherModel {
    func toWeatherSnapshot() -> WeatherSnapshot {
        let currentCondition = weather.first?.main.lowercased() ?? "clear"

        let mappedCondition: WeatherCondition
        if currentCondition.contains("thunder") {
            mappedCondition = .stormy
        } else if currentCondition.contains("rain") || currentCondition.contains("drizzle") {
            mappedCondition = .rainy
        } else if currentCondition.contains("snow") {
            mappedCondition = .snowy
        } else if currentCondition.contains("cloud") || currentCondition.contains("mist") || currentCondition.contains("fog") {
            mappedCondition = .cloudy
        } else {
            mappedCondition = .sunny
        }

        return WeatherSnapshot(
            cityName: name,
            temperatureCelsius: main.temp,
            condition: mappedCondition,
            humidity: main.humidity,
            windSpeedKPH: wind.speed * 3.6
        )
    }
}
