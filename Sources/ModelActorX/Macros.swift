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

@attached(member, names: named(modelExecutor), named(modelContainer), named(init))
@attached(extension, conformances: ModelActor)
public macro ModelActorX(disableGenerateInit: Bool = false) = #externalMacro(module: "ModelActorXMacros", type: "ModelActorXMacro")

@attached(member, names: named(modelExecutor), named(modelContainer), named(init))
@attached(extension, conformances: MainModelActorX)
public macro MainModelActorX(disableGenerateInit: Bool = false) = #externalMacro(module: "ModelActorXMacros", type: "MainModelActorXMacro")
