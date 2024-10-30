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
import SwiftData

/// A protocol for managing SwiftData model container on the main thread
/// Provides access to ModelContainer and ModelContext
@MainActor
public protocol MainModelActorX: AnyObject {
    /// The model container for SwiftData
    /// Used to manage data persistence and context creation
    var modelContainer: ModelContainer { get }
}

extension MainModelActorX {
    /// The main thread model context
    /// Used to perform data operations like querying, inserting, updating, and deleting on the main thread
    /// - Important: This context should only be used on the main thread
    public var modelContext: ModelContext {
        modelContainer.mainContext
    }

    /// Returns a model object of the specified type for the given persistent identifier
    /// - Parameters:
    ///   - id: The persistent identifier of the model object to find
    ///   - type: The type of model to return
    /// - Returns: An instance of the specified type if found, nil otherwise
    /// - Note: First attempts to find the object in registered models, then performs a database query if not found
    public subscript<T>(id: PersistentIdentifier, as type: T.Type) -> T? where T: PersistentModel {
        let predicate = #Predicate<T> {
            $0.persistentModelID == id
        }
        if let object: T = modelContext.registeredModel(for: id) {
            return object
        }
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate)
        let object: T? = try? modelContext.fetch(fetchDescriptor).first
        return object
    }
}
