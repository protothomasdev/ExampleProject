// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription
import TuistXCBuildSettings

extension Project {
    
    public enum ModuleKind {
        case staticLibrary
        case dynamicLibrary
        case staticFramework
        case dynamicFramework
        
        var product: Product {
            switch self {
                case .staticLibrary:
                    return .staticLibrary
                case .dynamicLibrary:
                    return .dynamicLibrary
                case .staticFramework:
                    return .staticFramework
                case .dynamicFramework:
                    return .framework
            }
        }
        
        var isFramework: Bool {
            switch self {
                case .staticLibrary,
                        .dynamicLibrary:
                    return false
                case .staticFramework,
                        .dynamicFramework:
                    return true
            }
        }
    }
    
    public static func module(name: String,
                              kind: ModuleKind,
                              destinations: Destinations,
                              additionalTargets: Set<AdditionalModuleTarget>,
                              dependencies: [ProjectDescription.TargetDependency]? = nil,
                              infoProvider: ProjectInfoProviding) -> Project {
        let moduleName = "u\(name)"
        
        let projectSettings: Settings = .settings(configurations: infoProvider.projectConfigs)
        
        var targets: [Target] = []

        let configs: [Configuration] = BuildConfiguration.allCases.map { config in
            let name = config.name
            let baseSettings: SettingsDictionary = [
                .productBundleIdentifier("\(infoProvider.bundleID).u.\(name)"),
                .swiftActiveCompilationConditions([name.uppercased()])
            ]
            if config.isDistribution {
                return .release(name: .configuration(name), settings: baseSettings)
            } else {
                return .debug(name: .configuration(name), settings: baseSettings)
            }
        }
        let targetSettings = Settings.settings(configurations: configs)
        
        let module = Target(name: moduleName,
                            destinations: destinations,
                            product: kind.product,
                            bundleId: "\(infoProvider.bundleID).u.\(name)",
                            deploymentTargets: infoProvider.deploymentTargets,
                            infoPlist: .default,
                            sources: ["Sources/**/*.swift"],
                            resources: kind.isFramework ? ["Resources/**"] : nil,
//                            scripts: .runScripts(),
                            dependencies: dependencies ?? [],
                            settings: targetSettings)
        targets.append(module)
        
        let additionalTargets = Project.moduleTargets(name: name,
                                                      destinations: destinations,
                                                      targets: additionalTargets,
                                                      infoProvider: infoProvider)
        targets.append(contentsOf: additionalTargets)
        
        return Project(name: moduleName,
                       options: .options(developmentRegion: "de"),
                       settings: projectSettings,
                       targets: targets)
    }
    
}

