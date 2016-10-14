//
//  BeaconPeripheralResponseParser.h
//  Wibree
//
//  Created by 村上幸雄 on 2016/10/03.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BeaconPeripheralResponseParser;

#define kBeaconPeripheralResponseParserNoError        0
#define kBeaconPeripheralResponseParserGenericError   1

typedef enum _BeaconPeripheralState {
    kBeaconPeripheralStateUnknown = 0,
    kBeaconPeripheralStateAdvertising,
    kBeaconPeripheralStateError,
    kBeaconPeripheralStateCanceled
} BeaconPeripheralSate;

typedef void (^BeaconPeripheralResponseParserCompletionHandler)(BeaconPeripheralResponseParser * __nonnull parser);

@protocol BeaconPeripheralResponseParserDelegate <NSObject>
- (void)beaconPeripheralResponseParser:(BeaconPeripheralResponseParser *)parser didFailWithError:(NSError*)error;
- (void)beaconPeripheralResponseParserDidCancel:(BeaconPeripheralResponseParser *)parser;
@end

@interface BeaconPeripheralResponseParser : NSObject

@property (assign, readonly, nonatomic) BeaconPeripheralSate                state;
@property (strong, nonatomic) NSError                                       *error;
@property (weak, nonatomic) id<BeaconPeripheralResponseParserDelegate>      delegate;
@property (copy, nonatomic) BeaconPeripheralResponseParserCompletionHandler completionHandler;

- (void)parse;
- (void)cancel;

@end
