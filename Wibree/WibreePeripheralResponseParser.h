//
//  WibreePeripheralResponseParser.h
//  Wibree
//
//  Created by 村上幸雄 on 2016/10/03.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WibreePeripheralResponseParser;

#define kWibreePeripheralResponseParserNoError        0
#define kWibreePeripheralResponseParserGenericError   1

typedef enum _WibreePeripheralState {
    kWibreePeripheralStateUnknown = 0,
    kWibreePeripheralStateAdvertising,
    kWibreePeripheralStateError,
    kWibreePeripheralStateCanceled
} WibreePeripheralSate;

typedef void (^WibreePeripheralResponseParserCompletionHandler)(WibreePeripheralResponseParser * __nonnull parser);

@protocol WibreePeripheralResponseParserDelegate <NSObject>
- (void)wibreePeripheralResponseParser:(WibreePeripheralResponseParser *)parser didFailWithError:(NSError*)error;
- (void)wibreePeripheralResponseParserDidCancel:(WibreePeripheralResponseParser *)parser;
@end

@interface WibreePeripheralResponseParser : NSObject

@property (assign, readonly, nonatomic) WibreePeripheralSate                state;
@property (strong, nonatomic) NSError                                       *error;
@property (weak, nonatomic) id<WibreePeripheralResponseParserDelegate>      delegate;
@property (copy, nonatomic) WibreePeripheralResponseParserCompletionHandler completionHandler;

- (void)parse;
- (void)cancel;

@end
