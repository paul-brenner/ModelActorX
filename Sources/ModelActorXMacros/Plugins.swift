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

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct ModelActorXMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ModelActorXMacro.self,
        MainModelActorXMacro.self,
    ]
}
