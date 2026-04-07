import SwiftUI

struct InfoCard<Content: View>: View {
    let title: String


    @ViewBuilder let content: Content
//view of the card that shows the weather info, error message, and recommendation
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(title)
                .font(AppTypography.subtitle)
                .foregroundColor(AppColors.secondaryText)

            content
        }
        .padding(AppSpacing.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .shadow(color: AppColors.cardShadow, radius: AppShadow.cardRadius, x: 0, y: AppShadow.cardY)
    }
}
