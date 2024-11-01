//
//  ------------------------------------------------
//  Original project: ModelActorX
//  Created on 2024/11/1 by Fatbobman(东坡肘子)
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
struct ModelActorXMainTests {
    @Test func example1() async throws {
        let container = createContainer()

        let handler = DataHandlerMain(mainContext: container.mainContext)

        let now = Date.now
        let id = try await handler.newItem(date: now)
        let date = await handler.getTimestampFromItemID(id)
        #expect(date == now)
    }
}

@ModelActorX
actor DataHandlerMain {
    func newItem(date: Date) throws -> PersistentIdentifier {
        let item = Item(timestamp: date)
        modelContext.insert(item)
        try modelContext.save()
        return item.persistentModelID
    }

    func getTimestampFromItemID(_ itemID: PersistentIdentifier) -> Date? {
        return self[itemID, as: Item.self]?.timestamp
    }

    func updateItem(id: PersistentIdentifier, date: Date) {
        guard let item = self[id, as: Item.self] else { return }
        item.timestamp = date
        try? modelContext.save()
    }
}
