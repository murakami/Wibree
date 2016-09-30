//
//  Document.swift
//  Wibree
//
//  Created by 村上幸雄 on 2016/09/27.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

import Foundation

class Document {
    let WIBREE_SERVICE_UUID = "EAD5D6C9-BFCF-44EE-91D4-45C2501456E2"
    let WIBREE_CHARACTERISTIC_UUID = "22AD9740-FBED-44E8-9B7B-5F9A12974D2F"
    let BEACON_SERVICE_UUID = "0AE4A21D-6096-4D71-8831-56A6FC7ACAB9"

    var version: String
    
    private var _uniqueIdentifier: String
    var uniqueIdentifier: String {
        return _uniqueIdentifier
    }
    
    static let sharedInstance: Document = {
        let instance = Document()
        return instance
    }()

    private init() {
        let infoDictionary = Bundle.main.infoDictionary! as Dictionary
        self.version = infoDictionary["CFBundleShortVersionString"]! as! String
        
        self._uniqueIdentifier = ""
    }
    
    func load() {
        loadDefaults()
    }
    
    func save() {
        updateDefaults()
    }
    
    private func clearDefaults() {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "version") != nil {
            userDefaults.removeObject(forKey: "version")
        }
        if userDefaults.object(forKey: "uniqueIdentifier") != nil {
            userDefaults.removeObject(forKey: "uniqueIdentifier")
        }
    }
    
    private func updateDefaults() {
        let userDefaults = UserDefaults.standard
        
        var versionString: String = ""
        if userDefaults.object(forKey: "version") != nil {
            versionString = userDefaults.object(forKey: "version") as! String
        }
        if versionString.compare(self.version) != .orderedSame {
            userDefaults.setValue(self.version, forKey: "version")
            userDefaults.synchronize()
        }
        
        var uniqueIdentifier: String = ""
        if userDefaults.object(forKey: "uniqueIdentifier") != nil {
            uniqueIdentifier = userDefaults.object(forKey: "uniqueIdentifier") as! String
        }
        if uniqueIdentifier.compare(self.uniqueIdentifier) != .orderedSame {
            userDefaults.setValue(self.uniqueIdentifier, forKey: "uniqueIdentifier")
            userDefaults.synchronize()
        }
    }
    
    private func loadDefaults() {
        let userDefaults = UserDefaults.standard
        
        var versionString: String = ""
        if userDefaults.object(forKey: "version") != nil {
            versionString = userDefaults.object(forKey: "version") as! String
        }
        if versionString.compare(self.version) != .orderedSame {
            /* バージョン不一致対応 */
            clearDefaults()
            _uniqueIdentifier = UUID.init().uuidString
        }
        else {
            /* 読み出し */
            if userDefaults.object(forKey: "uniqueIdentifier") != nil {
                _uniqueIdentifier = userDefaults.object(forKey: "uniqueIdentifier") as! String
            }
        }
    }
    
    private func modelDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if paths.count < 1 {
            return ""
        }
        var path = paths[0]
        
        path = path.appending(".model")
        return path
    }
    
    private func modelPath() -> String {
        let path = modelDir().appending("/model.dat")
        return path;
    }
}
