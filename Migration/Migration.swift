//
//  Migration.swift
//  WriteBot
//
//  Created by hengyu on 15/5/11.
//  Copyright (c) 2015年 hengyu. All rights reserved.
//

import Foundation

private enum MigrationKey: String {
    case lastVersion    = "Migration.lastVersion"
    case lastAppVersion = "Migration.lastAppVersion"
    case lastBuild      = "Migration.lastBuild"
    case lastAppBuild   = "Migration.lastAppBuild"
    case appVersion     = "Migration.appVersion"
    case appBuild       = "Migration.appBuild"
    
    func value() -> String {
        switch self {
        case .appVersion:
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        case .appBuild:
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        default:
            let res = UserDefaults.standard.value(forKey: self.rawValue) as? String
            return res ?? ""
        }
    }
    
    func setValue(_ value: String) {
        switch self {
        case .appVersion:
            break
        case .appBuild:
            break
        default:
            UserDefaults.standard.setValue(value, forKey: self.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    func reset() {
        UserDefaults.standard.setValue("", forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func valueForKey(_ key: MigrationKey) -> String {
        return key.value()
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

/**
 *  Migration lets app to execute a function when app's version or build increased.
 */
open class Migration {
    
    /**
     Executes a block of code for a specific version number and remembers this version as the latest migration done by Migration.
     
     - parameter version:   A string with a specific version number.
     - parameter execution: A closure to be executed when the application version matches the string 'version'.
     */
    open class func migrate(toVersion version: String, execution: (() -> Void)) {
        // version > lastMigrationVersion && version <= appVersion
        if version.compare(MigrationKey.valueForKey(.lastVersion), options: .numeric) == .orderedDescending && version.compare(MigrationKey.valueForKey(.appVersion), options: .numeric) != .orderedDescending {
            execution()
            debugPrint("Migration: Running migration for version \(version)")
            MigrationKey.setValue(version, forKey: .lastVersion)
        }
    }
    
    /**
     Executes a block of code for a specific build number and remembers this build as the latest migration done by Migration.
     
     - parameter build:     A string with a specific build number.
     - parameter execution: A closure to be executed when the application build matches the string 'build'.
     */
    open class func migrate(toBuild build: String, execution: (() -> Void)) {
        // build > lastMigrationBuild && build <= appVersion
        if build.compare(MigrationKey.valueForKey(.lastBuild), options: .numeric) == .orderedDescending && build.compare(MigrationKey.valueForKey(.appBuild), options: .numeric) != .orderedDescending {
            execution()
            debugPrint("Migration: Running migration for build \(build)")
            MigrationKey.setValue(build, forKey: .lastBuild)
        }
    }
    
    /**
     Executes a block of code for every time the application version changes.
     
     - parameter execution: A closure to be executed when the application version changes.
     */
    open class func applicationUpdate(execution: @escaping (Void) -> Void) {
        let appVersion = MigrationKey.valueForKey(.appVersion)
        if MigrationKey.valueForKey(.lastAppVersion) !=  appVersion {
            execution()
            debugPrint("Migration: Running update Block for version \(appVersion)")
            MigrationKey.setValue(appVersion, forKey: .lastAppVersion)
        }
    }
    
    /**
     Executes a block of code for every time the application build number changes.
     
     - parameter execution: A closure to be executed when the application build number changes.
     */
    open class func buildNumberUpdate(execution: @escaping (Void) -> Void) {
        let appBuild = MigrationKey.valueForKey(.appBuild)
        if MigrationKey.valueForKey(.lastAppBuild) !=  appBuild {
            execution()
            debugPrint("Migration: Running update Block for build \(appBuild)")
            MigrationKey.setValue(appBuild, forKey: .lastAppBuild)
        }
    }
    
    /**
     Clears the last migration remembered by Migration. Causes all migrations to run from the beginning.
     */
    open class func reset() {
        MigrationKey.reset()
    }
}



