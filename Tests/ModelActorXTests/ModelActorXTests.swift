import Foundation
@testable import ModelActorX
import Testing

struct ModelActorXTests {
    @Test func example1() async throws {
        let container = createContainer()
        let handler = DataHandler(modelContainer: container)
        let now = Date.now
        let id = try await handler.newItem(date: now)
        let date = await handler.getTimestampFromItemID(id)
        #expect(date == now)
    }

    @Test func example2() async throws {
        let container = createContainer()
        let now = Date.now
        let handler = DataHandler1(container: container, date: now)

        let id = try await handler.newItem()
        let date = await handler.getTimestampFromItemID(id)
        #expect(date == now)
    }
}

@ModelActorX
actor DataHandler {
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

@ModelActorX(disableGenerateInit: true)
actor DataHandler1 {
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
        let modelContext = ModelContext(modelContainer)
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
    }
}
