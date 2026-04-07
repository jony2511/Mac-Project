import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = HomeViewModel(
        weatherService: MockWeatherService(),
        recommendationService: MockMusicRecommendationService()
    )

    var body: some View {
        NavigationStack {
            HomeView(viewModel: viewModel)
                .navigationTitle("ClimaBeats")
        }
    }
}

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var isContentVisible = false

    var body: some View {
        ZStack {
            backgroundLayer

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    headerView

                    if let weather = viewModel.weather {
                        weatherCard(weather)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    if let recommendation = viewModel.recommendation {
                        recommendationCard(recommendation)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    if viewModel.isLoading {
                        ProgressView("Refreshing...")
                            .tint(AppColors.primaryText)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, AppSpacing.small)
                    }
                }
                .opacity(isContentVisible ? 1.0 : 0.0)
                .offset(y: isContentVisible ? 0 : 10)
                .padding(AppSpacing.large)
            }
        }
        .animation(AppAnimation.smoothSpring, value: viewModel.weather?.id)
        .animation(AppAnimation.smoothSpring, value: viewModel.recommendation?.id)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Refresh") {
                    Task {
                        await viewModel.load(city: "New York")
                    }
                }
            }
        }
        .task {
            if viewModel.weather == nil {
                await viewModel.load(city: "New York")
            }

            withAnimation(AppAnimation.smoothSpring) {
                isContentVisible = true
            }
        }
    }

    private var backgroundLayer: some View {
        LinearGradient(
            colors: [
                AppColors.pageTopGlow,
                AppColors.pageBase,
                AppColors.pageBottomGlow
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(AppColors.accent.opacity(0.28))
                .frame(width: 240, height: 240)
                .blur(radius: 40)
                .offset(x: 90, y: -50)
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Weather Soundtrack")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryText)

            Text("Find the perfect mood for today")
                .font(AppTypography.hero)
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppCorners.hero, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [AppColors.accent.opacity(0.35), AppColors.accentSecondary.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppCorners.hero, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: AppColors.cardShadow, radius: AppShadow.cardRadius, x: 0, y: AppShadow.cardY)
    }

    private func weatherCard(_ weather: WeatherSnapshot) -> some View {
        InfoCard(title: "Current Weather") {
            HStack(spacing: AppSpacing.medium) {
                Image(systemName: weather.condition.sfSymbol)
                    .foregroundColor(AppColors.accent)
                    .font(.system(size: 32, weight: .semibold))

                VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                    Text("\(weather.cityName)")
                        .font(AppTypography.title)
                        .foregroundColor(AppColors.primaryText)

                    Text("\(weather.condition.title) / \(Int(weather.temperatureCelsius)) C")
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.secondaryText)
                }
            }

            HStack {
                statChip(title: "Humidity", value: "\(weather.humidity)%")
                Spacer()
                statChip(title: "Wind", value: "\(Int(weather.windSpeedKPH)) km/h")
            }
        }
    }

    private func recommendationCard(_ recommendation: MusicRecommendation) -> some View {
        InfoCard(title: "Music Suggestion") {
            Text(recommendation.playlistTitle)
                .font(AppTypography.title)
                .foregroundColor(AppColors.primaryText)

            Text("Mood: \(recommendation.mood)")
                .font(AppTypography.body)
                .foregroundColor(AppColors.secondaryText)

            Text("Artist Focus: \(recommendation.artistHighlight)")
                .font(AppTypography.body)
                .foregroundColor(AppColors.secondaryText)

            Text(recommendation.reason)
                .font(AppTypography.body)
                .foregroundColor(AppColors.primaryText)
                .padding(.top, AppSpacing.xSmall)
        }
    }

    private func statChip(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryText)

            Text(value)
                .font(AppTypography.body)
                .foregroundColor(AppColors.primaryText)
        }
        .padding(.vertical, AppSpacing.small)
        .padding(.horizontal, AppSpacing.medium)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
