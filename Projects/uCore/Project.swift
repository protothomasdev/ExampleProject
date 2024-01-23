import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(name: "Core",
                             kind: .dynamicFramework,
                             destinations: [.iPhone],
                             additionalTargets: [
                                 .unitTests(),
                                 .exampleApp()
                             ],
                             infoProvider: InfoProvider())
