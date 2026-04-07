import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var weather: WeatherSnapshot?
    @Published private(set) var recommendation: MusicRecommendation?
    @Published private(set) var isLoading = false

    private let weatherService: WeatherServiceProtocol
    private let recommendationService: MusicRecommendationServiceProtocol

    init(
        weatherService: WeatherServiceProtocol,
        recommendationService: MusicRecommendationServiceProtocol
    ) {
        self.weatherService = weatherService
        self.recommendationService = recommendationService
    }

    func load(city: String = "New York") async {
        isLoading = true
        let weatherSnapshot = await weatherService.fetchCurrentWeather(for: city)
        weather = weatherSnapshot
        recommendation = recommendationService.recommendation(for: weatherSnapshot)
        isLoading = false
    }
}
