// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription

extension TargetScript {

    static var swiftLint: TargetScript {
        return .pre(path: Path.relativeToRoot("swiftlint"),
                    arguments: ["--config ../../.swiftlint.yml"],
                    name: "SwiftLint Linting",
                    basedOnDependencyAnalysis: false)
    }

    static func swiftFormat(linting: Bool = false) -> TargetScript {
        var arguments = ["--config ../../.swiftformat ."]
        if linting {
            arguments.insert("--lint --lenient", at: 0)
        }
        let name = linting ? "SwiftFormat Linting" : "SwiftFormat"
        return .pre(path: Path.relativeToRoot("swiftformat"),
                    arguments: arguments,
                    name: name,
                    basedOnDependencyAnalysis: false)
    }

}

extension Collection where Element == TargetScript {

    public static func runScripts() -> [Element] {
        return [
            .swiftLint,
            .swiftFormat(linting: true)
        ]
    }

    public static func formatScripts() -> [Element] {
        return [
            .swiftFormat()
        ]
    }

}
