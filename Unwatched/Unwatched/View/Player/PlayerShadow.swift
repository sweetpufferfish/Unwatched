//
//  PlayerShadow.swift
//  Unwatched
//

import SwiftUI
import UnwatchedShared

struct PlayerTopShadow: View {
    var body: some View {
        VStack(spacing: 0) {
            Color.black
                .allowsHitTesting(false)
                .frame(height: 35)
                .mask(LinearGradient(gradient: Gradient(
                    stops: [
                        .init(color: .black.opacity(0.9), location: 0),
                        .init(color: .black.opacity(0.3), location: 0.55),
                        .init(color: .clear, location: 1)
                    ]
                ), startPoint: .top, endPoint: .bottom))

            Spacer()
        }
    }
}

struct PlayerBottomShadow: View {
    var height: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Color.black
                .allowsHitTesting(false)
                .frame(height: height)
                .mask(LinearGradient(gradient: Gradient(
                    stops: [
                        .init(color: .black.opacity(0.9), location: 0),
                        .init(color: .black.opacity(0.5), location: 0.8),
                        .init(color: .clear, location: 1)
                    ]
                ), startPoint: .bottom, endPoint: .top))
        }
    }
}
