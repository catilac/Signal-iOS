//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

#import "TSYapDatabaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstalledStickerPack : TSYapDatabaseObject

@property (nonatomic, readonly) NSData *packId;
@property (nonatomic, readonly) NSData *packKey;
@property (nonatomic, readonly) NSData *manifestData;

- (instancetype)initWithPackId:(NSData *)packId packKey:(NSData *)packKey manifestData:(NSData *)manifestData;

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run
// `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithUniqueId:(NSString *)uniqueId
                    manifestData:(NSData *)manifestData
                          packId:(NSData *)packId
                         packKey:(NSData *)packKey
NS_SWIFT_NAME(init(uniqueId:manifestData:packId:packKey:));

// clang-format on

// --- CODE GENERATION MARKER

+ (NSString *)uniqueIdForPackId:(NSData *)packId;

@end

NS_ASSUME_NONNULL_END
