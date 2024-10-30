//
//  ------------------------------------------------
//  Original project: ModelActorX
//  Created on 2024/10/30 by Fatbobman(东坡肘子)
//  X: @fatbobman
//  Mastodon: @fatbobman@mastodon.social
//  GitHub: @fatbobman
//  Blog: https://fatbobman.com
//  ------------------------------------------------
//  Copyright © 2024-present Fatbobman. All rights reserved.

import Foundation
import ModelActorX
import SwiftData

@Model
final class Item {
    var timestamp: Date
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

func createContainer(_ fileName: String = #file + #function, subDirectory: String = "TestTemp") -> ModelContainer {
    let tempURL = URL.temporaryDirectory
    if !FileManager.default.fileExists(atPath: tempURL.appendingPathComponent(subDirectory).path) {
        try? FileManager.default
            .createDirectory(at: tempURL.appendingPathComponent(subDirectory), withIntermediateDirectories: true)
    }
    let url = tempURL.appendingPathComponent(subDirectory).appendingPathComponent(
        fileName + ".sqlite"
    )
    if FileManager.default.fileExists(atPath: url.path) {
        try? FileManager.default.removeItem(at: url)
    }

    let scheme = Schema([Item.self])
    let configuration = ModelConfiguration(schema: scheme, url: url)
    let container = try! ModelContainer(for: Item.self, configurations: configuration)
    return container
}
