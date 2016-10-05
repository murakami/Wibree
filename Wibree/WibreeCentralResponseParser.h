//
//  WibreeCentralResponseParser.h
//  Wibree
//
//  Created by 村上幸雄 on 2016/10/03.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WibreeCentralResponseParser;

#define kWibreeCentralResponseParserNoError        0
#define kWibreeCentralResponseParserGenericError   1

typedef enum _WibreeCentralState {
    kWibreeCentralStateUnknown = 0,
    kWibreeCentralStateScanning,
    kWibreeCentralStateError,
    kWibreeCentralStateCanceled
} WibreeCentralSate;

typedef void (^WibreeCentralResponseParserCompletionHandler)(WibreeCentralResponseParser *parser, NSString *uniqueIdentifier);

@protocol WibreeCentralResponseParserDelegate <NSObject>
- (void)wibreeCentralResponseParser:(WibreeCentralResponseParser *)parser didDiscoverUUID:(NSString *)uniqueIdentifier;
- (void)wibreeCentralResponseParserDidCancel:(WibreeCentralResponseParser *)parser;
@end

@interface WibreeCentralResponseParser : NSObject

@property (assign, readonly, nonatomic) WibreeCentralSate                   state;
@property (strong, nonatomic) NSError                                       *error;
@property (weak, nonatomic) id<WibreeCentralResponseParserDelegate>         delegate;
@property (copy, nonatomic) WibreeCentralResponseParserCompletionHandler    completionHandler;

- (void)parse;
- (void)cancel;

@end
