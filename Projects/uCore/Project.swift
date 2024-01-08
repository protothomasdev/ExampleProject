import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(name: "uCore",
                             kind: .dynamicFramework,
                             destinations: [.iPhone],
                             additionalTargets: [
                                .unitTests(),
                                .exampleApp()
                             ],
                             infoProvider: InfoProvider())
