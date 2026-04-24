//
//  SheetOverlayMinimumSize.swift
//  Unwatched
//

import SwiftUI

struct SheetOverlayMinimumSize: View {
    @Environment(PlayerManager.self) var player
    @Environment(SheetPositionReader.self) var sheetPos

    var body: some View {
        NavigationStack {
            Color.backgroundColor
                .ignoresSafeArea(.all)
                .myNavigationTitle("showMenu")
                .toolbar {
                    RefreshToolbarContent()
                }
                .disabled(true)
        }
        .overlay(Color.black.opacity(0.15))
        .background(Color.backgroundColor)
        .onTapGesture {
            if player.limitHeight {
                sheetPos.setDetentMiniPlayer()
            } else {
                sheetPos.setDetentVideoPlayer()
            }
        }
        .transparentNavBarWorkaround()
        .opacity(show ? 1 : 0)
        .presentationDragIndicator(.visible)
        .animation(.bouncy(duration: 0.3), value: sheetPos.isMinimumSheet)
    }

    var show: Bool {
        sheetPos.isMinimumSheet && player.video != nil
    }
}

#Preview {
    SheetOverlayMinimumSize()
        .environment(RefreshManager())
        .environment(SheetPositionReader())
}
