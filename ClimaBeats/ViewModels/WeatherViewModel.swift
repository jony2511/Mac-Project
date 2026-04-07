import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published private(set) var weather: WeatherSnapshot?
    @Published private(set) var recommendation: MusicRecommendation?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let weatherService: WeatherServiceProtocol
    private let recommendationService: MusicRecommendationServiceProtocol

    init(
        weatherService: WeatherServiceProtocol,
        recommendationService: MusicRecommendationServiceProtocol
    ) {
        self.weatherService = weatherService
        self.recommendationService = recommendationService
    }

    func fetchWeather(for city: String = "Khulna") async {
        isLoading = true
        errorMessage = nil

        do {
            let weatherSnapshot = try await weatherService.fetchCurrentWeather(for: city)
            weather = weatherSnapshot
            recommendation = recommendationService.recommendation(for: weatherSnapshot)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
