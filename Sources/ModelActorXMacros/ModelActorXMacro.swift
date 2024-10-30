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
import SwiftSyntax
import SwiftSyntaxMacros

/// An alternative to SwiftData's @ModelActor, with the only difference being the provision of the `disableGenerateInit` parameter, allowing for the non-generation of the constructor method
///
///     @ModelActorX
///     actor DataHandler {}
///
///  will expand to
///
///     @NSModelActor
///     actor DataHandler{}
///       nonisolated let modelExecutor: any SwiftData.ModelExecutor
///       nonisolated let modelContainer: SwiftData.ModelContainer
///
///       init(container: CoreData.NSPersistentContainer, mode: ActorContextMode = .newBackground) {
///         let modelContext = ModelContext(modelContainer)
///         self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
///         self.modelContainer = modelContainer
///       }
///     extension DataHandler: SwiftData.ModelActor {
///     }
public enum ModelActorXMacro {}

extension ModelActorXMacro: ExtensionMacro {
    public static func expansion(
        of _: SwiftSyntax.AttributeSyntax,
        attachedTo _: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo _: [SwiftSyntax.TypeSyntax],
        in _: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let decl: DeclSyntax =
            """
            extension \(type.trimmed): SwiftData.ModelActor {}
            """

        guard let extensionDecl = decl.as(ExtensionDeclSyntax.self) else {
            return []
        }

        return [extensionDecl]
    }
}

extension ModelActorXMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let generateInitializer = shouldGenerateInitializer(from: node)
        let accessModifier = isPublic(from: declaration) ? "public " : ""

        let decl: DeclSyntax =
            """
            \(raw: accessModifier)nonisolated let modelExecutor: any SwiftData.ModelExecutor
            \(raw: accessModifier)nonisolated let modelContainer: SwiftData.ModelContainer

            """
        let initializer: DeclSyntax? = generateInitializer ?
            """
            \(raw: accessModifier)init(modelContainer: SwiftData.ModelContainer) {
                let modelContext = ModelContext(modelContainer)
                self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
                self.modelContainer = modelContainer
            }
            """ : nil
        return [decl] + (initializer.map { [$0] } ?? [])
    }
}
