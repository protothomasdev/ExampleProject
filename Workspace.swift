// Copyright © 2024 Thomas Meyer. All rights reserved.

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

private var currentYear: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: Date())
}

let workspace = Workspace(name: "ExampleProject",
                          projects: ["Projects/**"],
                          fileHeaderTemplate: "Copyright © \(currentYear) \(InfoProvider().developerName). All rights reserved.",
                          generationOptions: .options(lastXcodeUpgradeCheck: "\(InfoProvider().xcodeVersion)"))
