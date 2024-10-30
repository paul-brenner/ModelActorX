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
@testable import ModelActorX
import Testing

@MainActor
struct MainModelActorXTests {
    @Test
    func test1() async throws {
        let container = createContainer()
        let handler = MainDataHandler(modelContainer: container)
        let now = Date.now
        let id = try handler.newItem(date: now)
        let date = handler.getTimestampFromItemID(id)
        #expect(date == now)
    }

    @Test
    func test2() async throws {
        let container = createContainer()
        let now = Date.now
        let handler = MainDataHandler1(container: container, date: now)
        let id = try handler.newItem()
        let date = handler.getTimestampFromItemID(id)
        #expect(date == now)
    }
}

@MainActor
@MainModelActorX
final class MainDataHandler {
    func newItem(date: Date) throws -> PersistentIdentifier {
        let item = Item(timestamp: date)
        modelContext.insert(item)
        try modelContext.save()
        return item.persistentModelID
    }

    func getTimestampFromItemID(_ itemID: PersistentIdentifier) -> Date? {
        return self[itemID, as: Item.self]?.timestamp
    }
}

@MainActor
@MainModelActorX(disableGenerateInit: true)
final class MainDataHandler1 {
    let date: Date

    func newItem() throws -> PersistentIdentifier {
        let item = Item(timestamp: date)
        modelContext.insert(item)
        try modelContext.save()
        return item.persistentModelID
    }

    func getTimestampFromItemID(_ itemID: PersistentIdentifier) -> Date? {
        return self[itemID, as: Item.self]?.timestamp
    }

    init(container: ModelContainer, date: Date) {
        self.date = date
        modelContainer = container
    }
}
