//
//  VideoListItemActions.swift
//  Unwatched
//

import SwiftUI
import UnwatchedShared

struct VideoListItemActions: View {
    var setWatched: (Bool) -> Void
    var addVideoToTopQueue: () -> Void
    var addVideoToBottomQueue: () -> Void
    var clearVideoEverywhere: () -> Void
    var canBeCleared: Bool

    var body: some View {
        Button("markWatched", systemImage: "checkmark", action: { setWatched(true) })

        Button("queueNext",
               systemImage: Const.queueNextSF,
               action: addVideoToTopQueue
        )

        Button("queueLast",
               systemImage: Const.queueLastSF,
               action: addVideoToBottomQueue
        )
        Button(
            "clearVideo",
            systemImage: Const.clearNoFillSF,
            action: clearVideoEverywhere
        )
        .disabled(!canBeCleared)
    }
}
