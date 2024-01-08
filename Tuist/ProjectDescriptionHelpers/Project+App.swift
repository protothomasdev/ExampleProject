// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription

extension Project {

    // MARK: - Public

    public static func app(name: String,
                           destinations: Destinations,
                           withTestData: Bool = false,
                           dependencies: [TargetDependency] = [],
                           infoProvider: ProjectInfoProviding) -> Project {
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": "\(infoProvider.appVersionNumber)",
            "CFBundleVersion": "$(BUNDLE_VERSION)",
            "ITSAppUsesNonExemptEncryption": "NO",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "UIUserInterfaceStyle": "Light",
            "UISupportedInterfaceOrientations": [
                "UIInterfaceOrientationPortrait"
            ],
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [:]
            ]
        ]

        let baseSettings: SettingsDictionary = [
            "CFBundleDisplayName": .string(name),
            "CODE_SIGNING_STYLE": "Manual"
        ]

        let targetSettings: Settings = .settings(base: baseSettings,
                                                 configurations: infoProvider.appTargetConfigs)
        let projectSettings: Settings = .settings(configurations: infoProvider.projectConfigs)

        let targets = [
            Target(name: name,
                   destinations: destinations,
                   product: .app,
                   bundleId: "\(infoProvider.bundleID)",
                   deploymentTargets: infoProvider.deploymentTargets,
                   infoPlist: .extendingDefault(with: infoPlist),
                   sources: ["Sources/**"],
                   resources: ["Resources/**"],
                   scripts: [],
                   dependencies: dependencies,
                   settings: targetSettings
                  ),
            Target(name: "\(name)Tests",
                   destinations: destinations,
                   product: .unitTests,
                   bundleId: "\(infoProvider.bundleID).tests",
                   infoPlist: .default,
                   sources: ["Tests/**"],
                   resources: withTestData ? ["Tests/TestData/**"] : nil,
                   scripts: [],
                   dependencies: [
                    .target(name: "\(name)")
                   ])
        ]

        return Project(name: name,
                       options: .options(developmentRegion: "de"),
                       settings: projectSettings,
                       targets: targets)
    }

}
