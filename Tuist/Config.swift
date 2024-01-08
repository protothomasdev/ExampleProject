// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription

let config = Config(compatibleXcodeVersions: [.upToNextMajor("14.2")],
                    swiftVersion: "5.7.2",
                    generationOptions: .options(enforceExplicitDependencies: true))
