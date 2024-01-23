// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription

extension TargetScript {

// TODO: Fix the Scripts with mise
    static var linting: TargetScript {
        return .pre(path: Path.relativeToRoot("Scripts/codelinting.sh"),
                    name: "Code Linting",
                    inputFileListPaths: [
                        Path.relativeToRoot(".tool-versions")
                    ],
                    basedOnDependencyAnalysis: false)
    }

    static var formatting: TargetScript {
        return .pre(path: Path.relativeToRoot("Scripts/codeformatting.sh"),
                    name: "Code Formatting",
                    inputFileListPaths: [
                        Path.relativeToRoot(".tool-versions")
                    ],
                    basedOnDependencyAnalysis: false)
    }

}

extension Collection where Element == TargetScript {

    public static var linting: [Element] {
        return [
            .linting
        ]
    }

    public static var formatting: [Element] {
        return [
            .formatting
        ]
    }

}
