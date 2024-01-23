// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription

public enum AdditionalModuleTarget: Hashable {
    case unitTests(withTestData: Bool = false)
    case exampleApp(withExampleData: Bool = false)
}

extension Project {
    
    public static func moduleTargets(name: String,
                                     destinations: Destinations,
                                     targets: Set<AdditionalModuleTarget>,
                                     infoProvider: ProjectInfoProviding) -> [Target] {
        let moduleName = "u\(name)"
        return targets.map { target in
            switch target {
                case .unitTests(let withTestData):
                    return Target(
                        name: "\(moduleName)Tests",
                        destinations: destinations,
                        product: .unitTests,
                        bundleId: "\(infoProvider.bundleID).u.\(name).tests",
                        deploymentTargets: infoProvider.deploymentTargets,
                        sources: ["Tests/**/*.swift"],
                        resources: withTestData ? ["Tests/TestData/**"] : nil,
                        scripts: .formatting,
                        dependencies: [.target(name: moduleName)]
                    )
                    
                case .exampleApp(let withExampleData):
                    let infoPlist: [String: Plist.Value] = [
                        "CFBundleName": "\(moduleName)",
                        "CFBundleShortVersionString": "1.0.0",
                        "CFBundleVersion": "1",
                        "NSLocationWhenInUseUsageDescription": "Current location",
                        "UILaunchStoryboardName": "",
                        "UIApplicationSceneManifest": [
                            "UIApplicationSupportsMultipleScenes": false,
                            "UISceneConfigurations": [:]
                        ]
                    ]
                    return Target(name: "\(moduleName)ExampleApp",
                                  destinations: destinations,
                                  product: .app,
                                  bundleId: "\(infoProvider.bundleID).u.\(name).exampleApp",
                                  deploymentTargets: infoProvider.deploymentTargets,
                                  infoPlist: .extendingDefault(with: infoPlist),
                                  sources: ["ExampleApp/**/*.swift"],
                                  resources: withExampleData ? ["ExampleApp/Resources/**"] : nil,
                                  dependencies: [.target(name: moduleName)]
                    )
            }
        }
    }
    
}
