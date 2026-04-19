//
//  StatsService.swift
//  Unwatched
//

import Foundation
import SwiftData
import UnwatchedShared
import OSLog

@MainActor
final class StatsService {
    static let shared = StatsService()

    private var currentVideoId: String?
    private var lastVideoTime: Double?
    private var lastWallClockTime: Date?

    private init() {}

    func handleVideoTimeUpdate(videoId: String, time: Double) {
        let now = Date()
        defer {
            if currentVideoId != videoId { currentVideoId = videoId }
            lastVideoTime = time
            lastWallClockTime = now
        }

        guard videoId == currentVideoId,
              let last = lastVideoTime,
              let lastClock = lastWallClockTime else { return }

        // Video must have actually advanced (guards against buffering and backward seeks)
        guard time > last else { return }

        let wallClockDelta = now.timeIntervalSince(lastClock)
        // Cap to prevent runaway accumulation if the timer fires late
        let duration = min(wallClockDelta, Double(Const.updateDbTimeSeconds) + 5)
        guard duration > 0 else { return }

        Log.info("StatsService: +\(duration)s for \(videoId)")

        let context = DataProvider.mainContext
        let predicate = #Predicate<Video> { $0.youtubeId == videoId }
        guard let video = try? context.fetch(FetchDescriptor(predicate: predicate)).first,
              let channelId = video.subscription?.youtubeChannelId ?? video.youtubeChannelId else { return }

        saveStat(channelId: channelId, duration: duration, context: context)
    }

    private func saveStat(channelId: String, duration: TimeInterval, context: ModelContext) {
        guard let today = getNormalizedDate(.now) else { return }

        let predicate = #Predicate<WatchTimeEntry> { $0.channelId == channelId && $0.date == today }
        let descriptor = FetchDescriptor(predicate: predicate)

        do {
            let stats = try context.fetch(descriptor)
            if let stat = stats.max(by: { $0.watchTime < $1.watchTime }) {
                stat.watchTime += duration
            } else {
                let stat = WatchTimeEntry(date: today, channelId: channelId, watchTime: duration)
                context.insert(stat)
            }
            try context.save()
        } catch {
            Log.error("StatsService: Failed to save stat: \(error)")
        }
    }

    func getNormalizedDate(_ date: Date) -> Date? {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        return calendar.date(from: components)
    }
}
