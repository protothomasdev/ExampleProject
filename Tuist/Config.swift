// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription

let config = Config(compatibleXcodeVersions: [.upToNextMajor("15.2")],
                    swiftVersion: "5.9",
                    plugins: [.git(url: "https://github.com/protothomasdev/tuist-plugin-xcbuildsettings.git", tag: "xcode-15.2")]
                    )
