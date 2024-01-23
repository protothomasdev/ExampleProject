// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription
import TuistXCBuildSettings

extension Project {
    
    // MARK: - Public
    
    public static func app(name: String,
                           destinations: Destinations,
                           withTestData: Bool = false,
                           dependencies: [TargetDependency] = [],
                           infoProvider: ProjectInfoProviding) -> Project {
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": "\(infoProvider.appVersionNumber)",
            "CFBundleVersion": "1", // Will be overwritten by CI/CD pipeline
            "ITSAppUsesNonExemptEncryption": "NO",
            "UILaunchStoryboardName": "LaunchScreen",
            "UISupportedInterfaceOrientations": infoProvider.interfaceOrientations,
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [:]
            ]
        ]
        
        let baseSettings = SettingsDictionary(buildSettings: [
            .infoPlistKeyCFBundleDisplayName(name),
            .codeSignStyle(.manual)
        ])
        
        let targetSettings: Settings = .settings(base: baseSettings,
                                                 configurations: infoProvider.appTargetConfigs)
        let testTargetSettings: Settings = .settings(base: baseSettings, configurations: [])
        let projectSettings: Settings = .settings(configurations: infoProvider.projectConfigs)
        
        let targets = [
            Target(name: name,
                   destinations: destinations,
                   product: .app,
                   bundleId: "\(infoProvider.bundleID).app",
                   deploymentTargets: infoProvider.deploymentTargets,
                   infoPlist: .extendingDefault(with: infoPlist),
                   sources: ["Sources/**"],
                   resources: ["Resources/**"],
                   scripts: .linting,
                   dependencies: dependencies,
                   settings: targetSettings
                  ),
            Target(name: "\(name)Tests",
                   destinations: destinations,
                   product: .unitTests,
                   bundleId: "\(infoProvider.bundleID).app.tests",
                   infoPlist: .default,
                   sources: ["Tests/**"],
                   resources: withTestData ? ["Tests/TestData/**"] : nil,
                   scripts: .formatting,
                   dependencies: [
                    .target(name: "\(name)")
                   ],
                   settings: testTargetSettings)
        ]
        
        return Project(name: name,
                       options: infoProvider.appProjectOptions,
                       settings: projectSettings,
                       targets: targets)
    }
    
}
