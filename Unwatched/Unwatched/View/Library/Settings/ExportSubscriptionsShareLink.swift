//
//  ExportSubscriptionsShareLink.swift
//  Unwatched
//

import SwiftUI

struct ExportSubscriptionsShareLink<Content: View>: View {
    let content: () -> Content

    @State var isExporting = false
    @State var showEmptyAlert = false
    #if os(iOS) || os(visionOS)
    @State var shareURL: IdentifiableURL?
    #endif

    var body: some View {
        Button(action: startExport) {
            if isExporting {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                content()
            }
        }
        .disabled(isExporting)
        .alert("noSubscriptionsToExport", isPresented: $showEmptyAlert) {
            Button("ok", role: .cancel) {}
        }
        #if os(iOS) || os(visionOS)
        .sheet(item: $shareURL) { identifiable in
            ActivityView(url: identifiable.url)
                .ignoresSafeArea()
        }
        #endif
    }

    func startExport() {
        Task {
            await MainActor.run { isExporting = true }
            let urls = (try? await SubscriptionService.getAllFeedUrls()) ?? []
            guard !urls.isEmpty else {
                await MainActor.run { isExporting = false; showEmptyAlert = true }
                return
            }
            let task = Task.detached(priority: .userInitiated) { try Self.generateOPMLFile(from: urls) }
            if let fileURL = try? await task.value {
                await MainActor.run { presentShare(url: fileURL) }
            }
            await MainActor.run { isExporting = false }
        }
    }

    static func generateOPMLFile(from urls: [(title: String, link: URL?)]) throws -> URL {
        let outlines = urls
            .compactMap { sub -> String? in
                guard let xmlUrl = sub.link?.absoluteString else { return nil }
                let title = sub.title
                    .replacingOccurrences(of: "&", with: "&amp;")
                    .replacingOccurrences(of: "\"", with: "&quot;")
                return "    <outline text=\"\(title)\" title=\"\(title)\" type=\"rss\" xmlUrl=\"\(xmlUrl)\"/>"
            }
            .joined(separator: "\n")
        let opml = """
            <?xml version="1.0" encoding="UTF-8"?>
            <opml version="1.1">
              <head><title>Subscriptions</title></head>
              <body>
            \(outlines)
              </body>
            </opml>
            """
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("unwatched.opml")
        try opml.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    @MainActor
    func presentShare(url: URL) {
        #if os(iOS) || os(visionOS)
        shareURL = IdentifiableURL(url: url)
        #elseif os(macOS)
        let picker = NSSharingServicePicker(items: [url])
        let view = NSApp.keyWindow?.contentView ?? NSApp.mainWindow?.contentView
        if let view {
            picker.show(relativeTo: .zero, of: view, preferredEdge: .minY)
        }
        #endif
    }
}
