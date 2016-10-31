//
//  BeaconPeripheralResponseParser.m
//  Wibree
//
//  Created by 村上幸雄 on 2016/10/03.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Wibree-Swift.h"
#import "BeaconPeripheralResponseParser.h"

@interface BeaconPeripheralResponseParser () <CBPeripheralManagerDelegate>
@property (assign, readwrite, nonatomic) BeaconPeripheralSate   state;
@property (strong, nonatomic) CBPeripheralManager               *peripheralManager;
@property (strong, nonatomic) CLBeaconRegion                    *beaconRegion;
- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription;
@end

@implementation BeaconPeripheralResponseParser

#pragma mark - Lifecycle

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        _state = kBeaconPeripheralStateUnknown;
        _error = nil;
        _delegate = nil;
        _completionHandler = NULL;
        _peripheralManager = nil;
        _beaconRegion = nil;
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    if (self.peripheralManager) {
        [self.peripheralManager stopAdvertising];
    }
    
    self.state = kBeaconPeripheralStateUnknown;
    self.error = nil;
    self.delegate = nil;
    self.completionHandler = NULL;
    self.peripheralManager = nil;
    self.beaconRegion = nil;
}

#pragma mark - ResponseParser

- (void)parse
{
    DBGMSG(@"%s", __func__);
    
    self.state = kBeaconPeripheralStateAdvertising;
    
    /* CBPeripheralManagerを生成 */
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    if (! self.peripheralManager) {
        /* CBPeripheralManagerの初期化失敗 */
        self.state = kBeaconPeripheralStateError;
        self.error = [self _errorWithCode:kBeaconPeripheralResponseParserGenericError
                     localizedDescription:@"CBPeripheralManagerの初期化に失敗しました。"];
        return;
    }
    
    /* ビーコン領域を生成 */
    NSUUID  *uuid = [[NSUUID alloc] initWithUUIDString:Document.BEACON_SERVICE_UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:12
                                                                minor:34
                                                           identifier:@"demo.Wibree.BeaconCentralResponseParser"];
    if (! self.beaconRegion) {
        /* ビーコン領域の初期化失敗 */
        self.state = kBeaconPeripheralStateError;
        self.error = [self _errorWithCode:kBeaconPeripheralResponseParserGenericError
                     localizedDescription:@"ビーコン領域の初期化に失敗しました。"];
        self.peripheralManager = nil;
        return;
    }
    DBGMSG(@"%s beaconRegion:%@", __func__, self.beaconRegion);
}

- (void)cancel
{
    DBGMSG(@"%s", __func__);
    
    if (self.peripheralManager) {
        [self.peripheralManager stopAdvertising];
        self.peripheralManager = nil;
        self.self.beaconRegion = nil;
    }
    self.state = kBeaconPeripheralStateCanceled;
    
    if ([self.delegate respondsToSelector:@selector(beaconPeripheralResponseParserDidCancel:)]) {
        [self.delegate beaconPeripheralResponseParserDidCancel:self];
    }
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    DBGMSG( @"%s [Main=%@] state(%d)", __FUNCTION__, [NSThread isMainThread] ? @"YES" : @"NO ", (int)peripheral.state);
    
    // Opt out from any other state
    if (peripheral.state != CBManagerStatePoweredOn) {
        DBGMSG(@"%s state(%d) not power on", __func__, (int)peripheral.state);
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    DBGMSG(@"%s self.peripheralManager powered on.", __func__);
    
    /* 告知開始 */
    NSDictionary    *dictionary = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:dictionary];
}

#pragma mark - etc

- (NSError *)_errorWithCode:(NSInteger)code localizedDescription:(NSString *)localizedDescription
{
    NSDictionary    *userInfo = [NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey];
    NSError         *error = [NSError errorWithDomain:@"Wibree" code:code userInfo:userInfo];
    return error;
}

@end
