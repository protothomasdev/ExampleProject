// Copyright © 2024 Thomas Meyer. All rights reserved.

import ProjectDescription

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
    public let xcodeVersion: Version = "15.0.0"
    public let swiftVersion: Version = "5.9"
    public var projectConfigs: [Configuration] { return [] }
    public var appTargetConfigs: [Configuration] { return [] }
    public let deploymentTargets: DeploymentTargets = .init(iOS: "17.0")
    
    public init() {}
    
    enum BuildConfiguration: String, CaseIterable {
        case debug
        case beta
        case release
        case mock
        
        private var name: String { self.rawValue.capitalized }
        
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
        
        var targetConfig: Configuration {
            switch self {
                case .debug:
                    return .debug(name: name,
                                  bundleID: "",
                                  signingIdentity: "",
                                  developmentTeam: "",
                                  profile: "",
                                  entitlements: "")
                case .beta:
                    return .release(name: name,
                                    bundleID: "",
                                    signingIdentity: "",
                                    developmentTeam: "",
                                    profile: "",
                                    entitlements: "")
                case .release:
                    return .release(name: name,
                                    bundleID: "",
                                    signingIdentity: "",
                                    developmentTeam: "",
                                    profile: "",
                                    entitlements: "")
                case .mock:
                    return .debug(name: name,
                                  bundleID: "",
                                  signingIdentity: "",
                                  developmentTeam: "",
                                  profile: "",
                                  entitlements: "")
            }
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
        return .debug(name: .configuration(name),
                      settings: [
                        "PRODUCT_BUNDLE_IDENTIFIER": "\(bundleID)",
                        "BUNDLE_VERSION": "$CI_PIPELINE_IID",
                        "CODE_SIGN_IDENTITY": "\(signingIdentity)",
                        "DEVELOPMENT_TEAM": "\(developmentTeam)",
                        "PROVISIONING_PROFILE_SPECIFIER": "\(profile)",
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "\(name.uppercased())",
                        "CODE_SIGN_ENTITLEMENTS": "\(entitlements)"
                      ])
    }
    
    public static func release(name: String,
                               bundleID: String,
                               signingIdentity: String,
                               developmentTeam: String,
                               profile: String,
                               entitlements: String) -> ProjectDescription.Configuration {
        return .release(name: .configuration(name),
                        settings: [
                            "PRODUCT_BUNDLE_IDENTIFIER": "\(bundleID)",
                            "BUNDLE_VERSION": "$CI_PIPELINE_IID",
                            "CODE_SIGN_IDENTITY": "\(signingIdentity)",
                            "DEVELOPMENT_TEAM": "\(developmentTeam)",
                            "PROVISIONING_PROFILE_SPECIFIER": "\(profile)",
                            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "\(name.uppercased())",
                            "CODE_SIGN_ENTITLEMENTS": "\(entitlements)"
                        ])
    }
    
}



