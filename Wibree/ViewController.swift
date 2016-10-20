//
//  ViewController.swift
//  Wibree
//
//  Created by 村上幸雄 on 2016/09/27.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var myUniqueIdentifierLabel: UILabel!
    @IBOutlet weak var yourUniqueIdentifierLabel: UILabel!
    @IBOutlet weak var wibreeCentralSwitch: UISwitch!
    @IBOutlet weak var wibreePeripheralSwitch: UISwitch!
    @IBOutlet weak var beaconCentralSwitch: UISwitch!
    @IBOutlet weak var beaconPeripheralSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myUniqueIdentifierLabel.text = Document.sharedInstance.uniqueIdentifier
        yourUniqueIdentifierLabel.text = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        wibreeCentralSwitch.isOn = false
        wibreePeripheralSwitch.isOn = false
        beaconCentralSwitch.isOn = false
        beaconPeripheralSwitch.isOn = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Connector.shared().cancelScan()
        Connector.shared().cancelAdvertising()
        Connector.shared().cancelScanForBeacons()
        Connector.shared().cancelBeaconAdvertising()
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleWibreeCentral(sender: AnyObject) {
        print(#function + "on(\(wibreeCentralSwitch.isOn))")
        if wibreeCentralSwitch.isOn {
            Connector.shared().scanForPeripherals(completionHandler: {
                [unowned self] (parser: WibreeCentralResponseParser, uniqueIdentifier: String) in
                print(#function + " UUID(" + uniqueIdentifier + ")")
                self.yourUniqueIdentifierLabel.text = uniqueIdentifier
                
                // Local Notification
                if #available(iOS 10.0, *) {
                    let content = UNMutableNotificationContent()
                    content.title = "Wibree"
                    content.body = uniqueIdentifier
                    content.sound = UNNotificationSound.default()
                    let request = UNNotificationRequest(identifier: "Wibree",
                                                        content: content,
                                                        trigger: nil)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            })
        }
        else {
            Connector.shared().cancelScan()
        }
    }
    
    @IBAction func toggleWibreePeripheral(sender: AnyObject) {
        print(#function + "on(\(wibreePeripheralSwitch.isOn))")
        if wibreePeripheralSwitch.isOn {
            Connector.shared().startAdvertising(completionHandler: {
                (parser) in
                print(#function)
            })
        }
        else {
            Connector.shared().cancelAdvertising()
        }
    }
    
    @IBAction func toggleBeaconCentral(sender: AnyObject) {
        print(#function + "on(\(beaconCentralSwitch.isOn))")
        if beaconCentralSwitch.isOn {
            Connector.shared().scanForBeacons(completionHandler: {
                (parser) in
                print(#function)
            }, scanningHandler: {
                (parser: BeaconCentralResponseParser, state: BeaconLocationState, beacons, region: CLRegion) in
                
                print(#function + "state(\(state))")
                print(#function + "beacons(\(beacons))")
                print(#function + "region(\(region))")
                for beacon in beacons {
                    print(#function + "\tbeacon(\(beacon))")
                }
            })
        }
        else {
            Connector.shared().cancelScanForBeacons()
        }
    }
    
    @IBAction func toggleBeaconPeripheral(sender: AnyObject) {
        print(#function + "on(\(beaconPeripheralSwitch.isOn))")
        if beaconPeripheralSwitch.isOn {
            Connector.shared().startBeaconAdvertising(completionHandler: {
                (parser) in
                print(#function)
            })
        }
        else {
            Connector.shared().cancelBeaconAdvertising()
        }
    }
}

