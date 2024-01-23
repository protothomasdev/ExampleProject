// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription
import TuistXCBuildSettings

public protocol ProjectInfoProviding {
    var appVersionNumber: String { get }
    var bundleID: String { get }
    var developerName: String { get }
    var xcodeVersion: Version { get }
    var swiftVersion: Version { get }
    var projectConfigs: [Configuration] { get }
    var appTargetConfigs: [Configuration] { get }
    var deploymentTargets: DeploymentTargets { get }
}

public struct InfoProvider: ProjectInfoProviding {
    public let appVersionNumber: String = "1.0.0"
    public let bundleID: String = "com.protothomas.example"
    public let developerName: String = "Thomas Meyer"
    public let xcodeVersion: Version = "15.2.0"
    public let swiftVersion: Version = "5.9"
    public var projectConfigs: [Configuration] {
        return BuildConfiguration.allCases.map(\.projectConfig)
    }
    public var appTargetConfigs: [Configuration] {
        return BuildConfiguration.allCases.map{ $0.targetConfig(info: self) }
    }
    public let deploymentTargets: DeploymentTargets = .init(iOS: "17.0")
    
    public init() {}
}

public enum BuildConfiguration: String, CaseIterable {
    case mock
    case debug
    case beta
    case release
    
    var name: String { self.rawValue.capitalized }
    
    var isDistribution: Bool {
        switch self {
            case .mock,
                    .debug:
                return false
            case .beta,
                    .release:
                return true
        }
    }
    
    var projectConfig: Configuration {
        let configName = ConfigurationName.configuration(name)
        switch self {
            case .debug:
                return .debug(name: configName)
            case .beta:
                return .release(name: configName)
            case .release:
                return .release(name: configName)
            case .mock:
                return .debug(name: configName)
        }
    }
    
    func targetConfig(info: ProjectInfoProviding) -> Configuration {
        switch self {
            case .mock:
                return .debug(name: name,
                              bundleID: "\(info.bundleID).app.mock",
                              signingIdentity: "", // TODO: Set default Signing Identity based on the bundleID schemes
                              developmentTeam: "", // TODO: Get the development Team from the Info Provider
                              profile: "",
                              entitlements: "") // TODO: Set default Entitlements
            case .debug:
                return .debug(name: name,
                              bundleID: "\(info.bundleID).app.development",
                              signingIdentity: "Protothomas Development",
                              developmentTeam: "Protothomas Dev",
                              profile: "match Development \(info.bundleID).app.development",
                              entitlements: "nil")
            case .beta:
                return .release(name: name,
                                bundleID: "\(info.bundleID).app.beta",
                                signingIdentity: "Protothomas Distribution",
                                developmentTeam: "Protothomas Live",
                                profile: "match AdHoc \(info.bundleID).app.beta", // Or "match AppStore/Enterprise ..."
                                entitlements: "nil")
            case .release:
                return .release(name: name,
                                bundleID: "\(info.bundleID).app",
                                signingIdentity: "Protothomas Distribution",
                                developmentTeam: "Protothomas Live",
                                profile: "match AppStore \(info.bundleID).app", // Or "match AppStore/Enterprise ..."
                                entitlements: "nil")
        }
    }
    
}

extension Configuration {
    
    public static func debug(name: String,
                             bundleID: String,
                             signingIdentity: String,
                             developmentTeam: String,
                             profile: String,
                             entitlements: String) -> ProjectDescription.Configuration {
        let settings: SettingsDictionary = [
            .codeSignIdentity(signingIdentity),
//            .codeSignEntitlements(entitlements),
            .productBundleIdentifier(bundleID),
            .provisioningProfileSpecifier(profile),
            .developmentTeam(developmentTeam),
            .swiftActiveCompilationConditions([name.uppercased()])
        ]
        return .debug(name: .configuration(name),
                      settings: settings)
    }
    
    public static func release(name: String,
                               bundleID: String,
                               signingIdentity: String,
                               developmentTeam: String,
                               profile: String,
                               entitlements: String) -> ProjectDescription.Configuration {
        let settings: SettingsDictionary = [
            .codeSignIdentity(signingIdentity),
//            .codeSignEntitlements(entitlements),
            .productBundleIdentifier(bundleID),
            .provisioningProfileSpecifier(profile),
            .developmentTeam(developmentTeam),
            .swiftActiveCompilationConditions([name.uppercased()])
        ]
        return .release(name: .configuration(name),
                        settings: settings)
    }
    
}



