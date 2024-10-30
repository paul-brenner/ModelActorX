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

/// Get the status of generating the initializer
func shouldGenerateInitializer(from node: AttributeSyntax) -> Bool {
    guard let argumentList = node.arguments?.as(LabeledExprListSyntax.self) else {
        return true
    }

    for argument in argumentList {
        if argument.label?.text == "disableGenerateInit",
           let booleanLiteral = argument.expression.as(BooleanLiteralExprSyntax.self)
        {
            return booleanLiteral.literal.text != "true"
        }
    }
    return true
}

/// Get the access level of the declared type, whether it is public
func isPublic(from declaration: some DeclGroupSyntax) -> Bool {
    return declaration.modifiers.contains { modifier in
        modifier.name.text == "public"
    }
}
