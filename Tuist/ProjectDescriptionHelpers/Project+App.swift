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
        // TODO: Move the Info.plist information into the Project.swift file
        // TODO: Write Plugin zu simplify generation of info.plist files
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": "\(infoProvider.appVersionNumber)",
            "CFBundleVersion": "1",
            "ITSAppUsesNonExemptEncryption": "NO",
            "UILaunchStoryboardName": "LaunchScreen",
            "UISupportedInterfaceOrientations": [
                "UIInterfaceOrientationPortrait"
            ],
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
                   ],
                   settings: testTargetSettings)
        ]
        
        // TODO: Pass the development Region as a parameter
        return Project(name: name,
                       options: .options(developmentRegion: "de"),
                       settings: projectSettings,
                       targets: targets)
    }
    
}
