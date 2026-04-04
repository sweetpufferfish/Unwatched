//
//  DebouncedText.swift
//  Unwatched
//

import Foundation

@Observable
class DebouncedText {
    @ObservationIgnored var task: Task<String?, Never>?
    @ObservationIgnored let delay: UInt64

    init(_ delay: Double = 0.5) {
        self.delay = UInt64(delay * 1_000_000_000)
    }

    var debounced = ""

    @MainActor
    var val = "" {
        didSet {
            handleDidSet()
        }
    }

    @MainActor
    func handleDidSet() {
        let value = val
        let delay = self.delay
        Task {
            task?.cancel()
            let newTask = Task.detached { () -> String? in
                do {
                    try await Task.sleep(nanoseconds: delay)
                    return value
                } catch {
                    return nil
                }
            }
            task = newTask
            if let newValue = await newTask.value {
                self.debounced = newValue
            }
        }
    }
}
