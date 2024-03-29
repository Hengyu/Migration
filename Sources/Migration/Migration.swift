//
//  Migration.swift
//  Migration
//
//  Created by hengyu on 15/5/11.
//  Copyright (c) 2015 hengyu. All rights reserved.
//

import Foundation

private struct MigrationKey: Equatable, Hashable, ExpressibleByStringLiteral {
    private let underlying: String
    private let userDefaults: UserDefaults = .standard

    static let lastVersion: MigrationKey = "Migration.lastVersion"
    static let lastAppVersion: MigrationKey = "Migration.lastAppVersion"
    static let lastBuild: MigrationKey = "Migration.lastBuild"
    static let lastAppBuild: MigrationKey = "Migration.lastAppBuild"
    static let appVersion: MigrationKey = "Migration.appVersion"
    static let appBuild: MigrationKey = "Migration.appBuild"

    init(stringLiteral value: StringLiteralType) {
        underlying = value
    }

    func value() -> String? {
        switch self {
        case .appVersion:
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        case .appBuild:
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        case .lastVersion, .lastAppVersion, .lastBuild, .lastAppBuild:
            return userDefaults.string(forKey: underlying)
        default:
            return nil
        }
    }

    func setValue(_ value: String) {
        switch self {
        case .appVersion, .appBuild:
            break
        case .lastVersion, .lastAppVersion, .lastBuild, .lastAppBuild:
            userDefaults.set(value, forKey: underlying)
            userDefaults.synchronize()
        default:
            break
        }
    }

    func reset() {
        userDefaults.set(nil, forKey: underlying)
        userDefaults.synchronize()
    }

    static func value(forKey key: MigrationKey) -> String? {
        key.value()
    }

    static func emptyableValue(forKey key: MigrationKey) -> String {
        key.value() ?? ""
    }

    static func setValue(_ value: String, forKey key: MigrationKey) {
        key.setValue(value)
    }

    static func reset() {
        lastVersion.reset()
        lastAppVersion.reset()
        lastBuild.reset()
        lastAppBuild.reset()
    }
}

/// Migration lets app to execute a function when app's version or build increased.
public final class Migration {

    /// Executes a block of code for a specific version number and remembers this version as the latest migration.
    /// - Parameters:
    ///   - version: A string with a specific version number.
    ///   - execution: A closure to be executed when the application version matches the string 'version'.
    public class func migrate(toVersion version: String, execution: (() -> Void)) {
        // version > lastMigrationVersion && version <= appVersion
        if
            version.compare(
                MigrationKey.emptyableValue(forKey: .lastVersion),
                options: .numeric
            ) == .orderedDescending &&
            version.compare(
                MigrationKey.emptyableValue(forKey: .appVersion),
                options: .numeric
            ) != .orderedDescending
        {
            execution()
            debugPrint("Migration: Running migration for version \(version)")
            MigrationKey.setValue(version, forKey: .lastVersion)
        }
    }

    /// Executes a block of code for a specific build number and remembers this build as the latest migration.
    /// - Parameters:
    ///   - build: A string with a specific build number.
    ///   - execution: A closure to be executed when the application build matches the string 'build'.
    public class func migrate(toBuild build: String, execution: (() -> Void)) {
        // build > lastMigrationBuild && build <= appVersion
        if
            build.compare(MigrationKey.emptyableValue(forKey: .lastBuild), options: .numeric) == .orderedDescending &&
            build.compare(MigrationKey.emptyableValue(forKey: .appBuild), options: .numeric) != .orderedDescending
        {
            execution()
            debugPrint("Migration: Running migration for build \(build)")
            MigrationKey.setValue(build, forKey: .lastBuild)
        }
    }

    /// Executes a block of code for every time the application version changes.
    /// - Parameter execution: A closure to be executed when the application version changes.
    public class func applicationUpdate(execution: @escaping () -> Void) {
        if
            let appVersion = MigrationKey.value(forKey: .appVersion),
            MigrationKey.value(forKey: .lastAppVersion) !=  appVersion
        {
            execution()
            debugPrint("Migration: Running update Block for version \(appVersion)")
            MigrationKey.setValue(appVersion, forKey: .lastAppVersion)
        }
    }

    /// Executes a block of code for every time the application build number changes.
    /// - Parameter execution: A closure to be executed when the application build number changes.
    public class func buildNumberUpdate(execution: @escaping () -> Void) {
        if
            let appBuild = MigrationKey.value(forKey: .appBuild),
            MigrationKey.value(forKey: .lastAppBuild) !=  appBuild
        {
            execution()
            debugPrint("Migration: Running update Block for build \(appBuild)")
            MigrationKey.setValue(appBuild, forKey: .lastAppBuild)
        }
    }

    /// Clears the last migration remembered by Migration. Causes all migrations to run from the beginning.
    public class func reset() {
        MigrationKey.reset()
    }
}
