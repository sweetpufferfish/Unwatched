//
//  MyButtonStyle.swift
//  Unwatched
//

import SwiftUI
import UnwatchedShared

struct MyButtonStyle: ButtonStyle {
    @AppStorage(Const.themeColor) var theme = ThemeColor()

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .foregroundStyle(theme.contrastColor)
            .background(theme.color)
            .clipShape(.rect(cornerRadius: 5))
    }
}
