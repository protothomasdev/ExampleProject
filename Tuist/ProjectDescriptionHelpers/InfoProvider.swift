// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription
import TuistXCBuildSettings

public protocol ProjectInfoProviding {
    var appVersionNumber: String { get }
    var bundleID: String { get }
    var developerName: String { get }
    var developmentTeamID: String { get }
    var developmentSigningIdentity: String { get }
    var distributionTeamID: String { get }
    var distributionSigningIdentity: String { get }
    var xcodeVersion: Version { get }
    var swiftVersion: Version { get }
    var projectConfigs: [Configuration] { get }
    var appTargetConfigs: [Configuration] { get }
    var deploymentTargets: DeploymentTargets { get }
    var interfaceOrientations: Plist.Value { get }
    var appProjectOptions: Project.Options { get }
}

public struct InfoProvider: ProjectInfoProviding {
    public let appVersionNumber: String = "1.0.0"
    public let bundleID: String = "com.protothomas.example"
    public let developerName: String = "Thomas Meyer"
    public let developmentTeamID: String = "DEV123456"
    public let developmentSigningIdentity: String = "Protothomas Development"
    public let distributionTeamID: String = "DIS123456"
    public let distributionSigningIdentity: String = "Protothomas Distribution"
    public let xcodeVersion: Version = "15.2.0"
    public let swiftVersion: Version = "5.9"
    public var projectConfigs: [Configuration] {
        return BuildConfiguration.allCases.map(\.projectConfig)
    }
    public var appTargetConfigs: [Configuration] {
        return BuildConfiguration.allCases.map{ $0.targetConfig(info: self) }
    }
    public let deploymentTargets: DeploymentTargets = .init(iOS: "17.0")
    public let interfaceOrientations: Plist.Value = ["UIInterfaceOrientationPortrait"]
    public let appProjectOptions: Project.Options = .options(developmentRegion: "de")
    
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
                              signingIdentity: "",
                              developmentTeam: "",
                              profile: "",
                              entitlements: Path.relativeToManifest("Resources/Entitlements/Mock.entitlements"))
            case .debug:
                return .debug(name: name,
                              bundleID: "\(info.bundleID).app.development",
                              signingIdentity: info.developmentSigningIdentity,
                              developmentTeam: info.developmentTeamID,
                              profile: "match Development \(info.bundleID).app.development",
                              entitlements: Path.relativeToManifest("Resources/Entitlements/Debug.entitlements"))
            case .beta:
                return .release(name: name,
                                bundleID: "\(info.bundleID).app.beta",
                                signingIdentity: info.distributionSigningIdentity,
                                developmentTeam: info.distributionTeamID,
                                profile: "match AdHoc \(info.bundleID).app.beta", // Or "match AppStore/Enterprise ..."
                                entitlements: Path.relativeToManifest("Resources/Entitlements/Beta.entitlements"))
            case .release:
                return .release(name: name,
                                bundleID: "\(info.bundleID).app",
                                signingIdentity: info.distributionSigningIdentity,
                                developmentTeam: info.distributionTeamID,
                                profile: "match AppStore \(info.bundleID).app", // Or "match AppStore/Enterprise ..."
                                entitlements: Path.relativeToManifest("Resources/Entitlements/Release.entitlements"))
        }
    }
    
}

extension Configuration {
    
    public static func debug(name: String,
                             bundleID: String,
                             signingIdentity: String,
                             developmentTeam: String,
                             profile: String,
                             entitlements: ProjectDescription.Path) -> ProjectDescription.Configuration {
        let settings: SettingsDictionary = [
            .codeSignIdentity(signingIdentity),
            .codeSignEntitlements(entitlements.pathString),
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
                               entitlements: ProjectDescription.Path) -> ProjectDescription.Configuration {
        let settings: SettingsDictionary = [
            .codeSignIdentity(signingIdentity),
            .codeSignEntitlements(entitlements.pathString),
            .productBundleIdentifier(bundleID),
            .provisioningProfileSpecifier(profile),
            .developmentTeam(developmentTeam),
            .swiftActiveCompilationConditions([name.uppercased()])
        ]
        return .release(name: .configuration(name),
                        settings: settings)
    }
    
}



