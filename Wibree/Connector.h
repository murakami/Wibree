//
//  Connector.h
//  Wibree
//
//  Created by 村上幸雄 on 2016/10/03.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WibreeCentralResponseParser.h"
#import "WibreePeripheralResponseParser.h"
#import "BeaconCentralResponseParser.h"
#import "BeaconPeripheralResponseParser.h"

extern NSString *ConnectorDidBeginWibreeCentral;
extern NSString *ConnectorDidDiscoverUUID;
extern NSString *ConnectorDidFinishWibreeCentral;
extern NSString *ConnectorDidBeginWibreePeripheral;
extern NSString *ConnectorDidFinishWibreePeripheral;
extern NSString *ConnectorDidBeginBeaconCentral;
extern NSString *ConnectorDidEnterRegion;
extern NSString *ConnectorDidExitRegion;
extern NSString *ConnectorDidRangeBeaconsInRegion;
extern NSString *ConnectorDidFinishBeaconCentral;
extern NSString *ConnectorDidBeginBeaconPeripheral;
extern NSString *ConnectorDidFinishBeaconPeripheral;
extern NSString *ConnectorDidFinishAll;

@interface Connector : NSObject

@property (assign, readonly, nonatomic, getter=isNetworkAccessing) BOOL networkAccessing;

+ (Connector *)sharedConnector;
- (void)scanForPeripheralsWithCompletionHandler:(WibreeCentralResponseParserCompletionHandler)completionHandler;
- (void)cancelScan;
- (void)startAdvertisingWithCompletionHandler:(WibreePeripheralResponseParserCompletionHandler)completionHandler;
- (void)cancelAdvertising;
- (void)scanForBeaconsWithCompletionHandler:(BeaconCentralResponseParserCompletionHandler)completionHandler
                            scanningHandler:(BeaconCentralResponseParserScanningHandler)scanningHandler;
- (void)cancelScanForBeacons;
- (void)startBeaconAdvertisingWithCompletionHandler:(BeaconPeripheralResponseParserCompletionHandler)completionHandler;
- (void)cancelBeaconAdvertising;
- (void)cancelAll;

@end
