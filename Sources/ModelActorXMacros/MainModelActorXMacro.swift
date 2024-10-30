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

/// The SwiftData version corresponding to NSMainModelActorX of CoreDataEvolution
/// Helps declare a class that runs in MainActor and provides access to ModelContainer
///
///     @MainModelActorX
///     @MainActor
///     public final class DataHandler {}
///
///  will expand to
///
///     @MainModelActorX
///     @MainActor
///     public final class DataHandler{}
///       public let modelContainer: SwiftData.ModelContainer
///
///       public init(modelContainer: SwiftData.ModelContainer) {
///           self.modelContainer = modelContainer
///       }
///    extension DataHandler: ModelActorX.MainModelActorX {
///    }
public enum MainModelActorXMacro {}

extension MainModelActorXMacro: ExtensionMacro {
    public static func expansion(
        of _: SwiftSyntax.AttributeSyntax,
        attachedTo _: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo _: [SwiftSyntax.TypeSyntax],
        in _: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let decl: DeclSyntax =
            """
            extension \(type.trimmed): ModelActorX.MainModelActorX {}
            """

        guard let extensionDecl = decl.as(ExtensionDeclSyntax.self) else {
            return []
        }

        return [extensionDecl]
    }
}

extension MainModelActorXMacro: MemberMacro {
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
            \(raw: accessModifier)let modelContainer: SwiftData.ModelContainer
            """

        let initializer: DeclSyntax? = generateInitializer ?
            """
            \(raw: accessModifier)init(modelContainer: SwiftData.ModelContainer) {
                self.modelContainer = modelContainer
            }
            """ : nil
        return [decl] + (initializer.map { [$0] } ?? [])
    }
}
