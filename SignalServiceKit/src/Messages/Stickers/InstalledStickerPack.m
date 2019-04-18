//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

#import "InstalledStickerPack.h"
#import <SignalCoreKit/NSData+OWS.h>

NS_ASSUME_NONNULL_BEGIN

@implementation InstalledStickerPack

- (instancetype)initWithPackId:(NSData *)packId packKey:(NSData *)packKey manifestData:(NSData *)manifestData
{
    OWSAssertDebug(packId.length > 0);
    OWSAssertDebug(packKey.length > 0);
    OWSAssertDebug(manifestData.length > 0);

    self = [super initWithUniqueId:[InstalledStickerPack uniqueIdForPackId:packId]];

    if (!self) {
        return self;
    }

    _packId = packId;
    _packKey = packKey;
    _manifestData = manifestData;

    return self;
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run
// `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithUniqueId:(NSString *)uniqueId
                    manifestData:(NSData *)manifestData
                          packId:(NSData *)packId
                         packKey:(NSData *)packKey
{
    self = [super initWithUniqueId:uniqueId];

    if (!self) {
        return self;
    }

    _manifestData = manifestData;
    _packId = packId;
    _packKey = packKey;

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

+ (NSString *)uniqueIdForPackId:(NSData *)packId
{
    return packId.hexadecimalString;
}

@end

NS_ASSUME_NONNULL_END
