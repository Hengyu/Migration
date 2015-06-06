//
//  Migration.swift
//  Migration
//
//  Created by hengyu on 15/6/6.
//  Copyright (c) 2015年 hengyu. All rights reserved.
//

import Foundation

private enum MigrationKey: String {
    case LastVersion    = "Migration.lastVersion"
    case LastAppVersion = "Migration.lastAppVersion"
    case LastBuild      = "Migration.lastBuild"
    case LastAppBuild   = "Migration.lastAppBuild"
    case AppVersion     = "Migration.appVersion"
    case AppBuild       = "Migration.appBuild"
    
    func value() -> String {
        switch self {
        case .AppVersion:
            return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        case .AppBuild:
            return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
        default:
            let res = NSUserDefaults.standardUserDefaults().valueForKey(self.rawValue) as? String
            return res ?? ""
        }
    }
    
    func setValue(value: String) {
        switch self {
        case .AppVersion:
            break
        case .AppBuild:
            break
        default:
            NSUserDefaults.standardUserDefaults().setValue(value, forKey: self.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func reset() {
        NSUserDefaults.standardUserDefaults().setValue("", forKey: self.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func valueForKey(key: MigrationKey) -> String {
        return key.value()
    }
    
    static func setValue(value: String, forKey key: MigrationKey) {
        key.setValue(value)
    }
    
    static func reset() {
        LastVersion.reset()
        LastAppVersion.reset()
        LastBuild.reset()
        LastAppBuild.reset()
    }
}

/**
*  Migration lets app to execute a function when app's version or build increased.
*/
public class Migration {
    
    /**
    Executes a block of code for a specific version number and remembers this version as the latest migration done by Migration.
    
    :param: version   A string with a specific version number.
    :param: execution A closure to be executed when the application version matches the string 'version'.
    */
    public class func migrateToVersion(version: String, execution: (() -> Void)) {
        // version > lastMigrationVersion && version <= appVersion
        if version.compare(MigrationKey.valueForKey(.LastVersion), options: .NumericSearch) == .OrderedDescending && version.compare(MigrationKey.valueForKey(.AppVersion), options: .NumericSearch) != .OrderedDescending {
            execution()
            #if DEBUG
                println("Migration: Running migration for version \(version)")
            #endif
            MigrationKey.setValue(version, forKey: .LastVersion)
        }
    }
    
    /**
    Executes a block of code for a specific build number and remembers this build as the latest migration done by Migration.
    
    :param: build     A string with a specific build number.
    :param: execution A closure to be executed when the application build matches the string 'build'.
    */
    public class func migrateToBuild(build: String, execution: (() -> Void)) {
        // build > lastMigrationBuild && build <= appVersion
        if build.compare(MigrationKey.valueForKey(.LastBuild), options: .NumericSearch) == .OrderedDescending && build.compare(MigrationKey.valueForKey(.AppBuild), options: .NumericSearch) != .OrderedDescending {
            execution()
            #if DEBUG
                println("Migration: Running migration for build \(build)")
            #endif
            MigrationKey.setValue(build, forKey: .LastBuild)
        }
    }
    
    /**
    Executes a block of code for every time the application version changes.
    
    :param: execution A closure to be executed when the application version changes.
    */
    public class func applicationUpdateExecution(execution: (() -> Void)) {
        let appVersion = MigrationKey.valueForKey(.AppVersion)
        if MigrationKey.valueForKey(.LastAppVersion) !=  appVersion {
            execution()
            #if DEBUG
                println("Migration: Running update Block for version \(appVersion)")
            #endif
            MigrationKey.setValue(appVersion, forKey: .LastAppVersion)
        }
    }
    
    /**
    Executes a block of code for every time the application build number changes.
    
    :param: execution A closure to be executed when the application build number changes.
    */
    public class func buildNumberUpdateExecution(execution: (() -> Void)) {
        let appBuild = MigrationKey.valueForKey(.AppBuild)
        if MigrationKey.valueForKey(.LastAppBuild) !=  appBuild {
            execution()
            #if DEBUG
                println("Migration: Running update Block for version \(appVersion)")
            #endif
            MigrationKey.setValue(appBuild, forKey: .LastAppBuild)
        }
    }
    
    /**
    Clears the last migration remembered by Migration. Causes all migrations to run from the beginning.
    */
    public class func reset() {
        MigrationKey.reset()
    }
}
