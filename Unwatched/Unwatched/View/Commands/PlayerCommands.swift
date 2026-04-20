//
//  PlayerCommands.swift
//  Unwatched
//

import UnwatchedShared
import SwiftUI

struct PlayerCommands: Commands {
    var body: some Commands {
        CommandMenu("playback") {
            Section {
                PlayerShortcut.playPause.render()
                PlayerShortcut.playPause.render(isAlt: true)

                PlayerShortcut.seekBackward5.render()
                PlayerShortcut.seekForward5.render()

                PlayerShortcut.seekBackward10.render()
                PlayerShortcut.seekForward10.render()

                PlayerShortcut.previousChapter.render(isAlt: true)
                PlayerShortcut.nextChapter.render(isAlt: true)

                PlayerShortcut.previousChapter.render()
                PlayerShortcut.nextChapter.render()
            }

            Section("playbackSpeed") {
                PlayerShortcut.speedUp.render()
                PlayerShortcut.slowDown.render()

                PlayerShortcut.speedUp.render(isAlt: true)
                PlayerShortcut.slowDown.render(isAlt: true)

                PlayerShortcut.temporarySlowDown.render()
                PlayerShortcut.temporarySpeedUp.render()
            }
        }

        CommandMenu("video") {
            PlayerShortcut.markWatched.render()
            PlayerShortcut.nextVideo.render()

            Section {
                PlayerShortcut.openInAppBrowser.render()
                PlayerShortcut.openInExternalBrowser.render()
            }
        }
    }
}
