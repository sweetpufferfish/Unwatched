//
//  OPMLParser.swift
//  Unwatched
//

import Foundation
import UnwatchedShared

class OPMLParser: NSObject, XMLParserDelegate {
    private let data: Data
    private var result = [SendableSubscription]()

    init(data: Data) {
        self.data = data
    }

    func parse() -> [SendableSubscription] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return result
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName: String?,
                attributes: [String: String] = [:]) {
        guard elementName == "outline",
              let xmlUrl = attributes["xmlUrl"],
              let url = URLComponents(string: xmlUrl),
              let channelId = url.queryItems?.first(where: { $0.name == "channel_id" })?.value else {
            return
        }
        let title = attributes["title"] ?? attributes["text"] ?? channelId
        result.append(SendableSubscription(title: title, youtubeChannelId: channelId))
    }
}
