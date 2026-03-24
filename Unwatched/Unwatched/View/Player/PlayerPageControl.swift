//
//  PlayerPageControl.swift
//  Unwatched
//

import SwiftUI
import UnwatchedShared

struct PlayerPageControl: View {
    @Environment(NavigationManager.self) var navManager

    var body: some View {
        @Bindable var navManager = navManager

        PageControl(
            currentPage: Binding(
                get: { navManager.playerTab.rawValue },
                set: { newValue in
                    if let newValue, let newTab = ControlNavigationTab(rawValue: newValue) {
                        navManager.playerTab = newTab
                    }
                }
            ),
            numberOfPages: 2
        )
        .clipShape(Capsule())
    }
}
