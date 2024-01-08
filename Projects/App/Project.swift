import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: "App",
                          destinations: [.iPhone],
                          infoProvider: InfoProvider())
