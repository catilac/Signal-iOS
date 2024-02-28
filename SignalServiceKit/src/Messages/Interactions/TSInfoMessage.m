//
// Copyright 2017 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

#import "TSInfoMessage.h"
#import "ContactsManagerProtocol.h"
#import <SignalCoreKit/NSDate+OWS.h>
#import <SignalServiceKit/SignalServiceKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

const InfoMessageUserInfoKey InfoMessageUserInfoKeyLegacyGroupUpdateItems = @"InfoMessageUserInfoKeyUpdateMessages";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyGroupUpdateItems = @"InfoMessageUserInfoKeyUpdateMessagesV2";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyOldGroupModel = @"InfoMessageUserInfoKeyOldGroupModel";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyNewGroupModel = @"InfoMessageUserInfoKeyNewGroupModel";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyOldDisappearingMessageToken
    = @"InfoMessageUserInfoKeyOldDisappearingMessageToken";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyNewDisappearingMessageToken
    = @"InfoMessageUserInfoKeyNewDisappearingMessageToken";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyGroupUpdateSourceLegacyAddress
    = @"InfoMessageUserInfoKeyGroupUpdateSourceAddress";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyLegacyUpdaterKnownToBeLocalUser
    = @"InfoMessageUserInfoKeyUpdaterWasLocalUser";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyProfileChanges = @"InfoMessageUserInfoKeyProfileChanges";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyChangePhoneNumberAciString
    = @"InfoMessageUserInfoKeyChangePhoneNumberUuid";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyChangePhoneNumberOld = @"InfoMessageUserInfoKeyChangePhoneNumberOld";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyChangePhoneNumberNew = @"InfoMessageUserInfoKeyChangePhoneNumberNew";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyPaymentActivationRequestSenderAci
    = @"InfoMessageUserInfoKeyPaymentActivationRequestSenderAci";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyPaymentActivatedAci = @"InfoMessageUserInfoKeyPaymentActivatedAci";
const InfoMessageUserInfoKey InfoMessageUserInfoKeyThreadMergePhoneNumber
    = @"InfoMessageUserInfoKeyThreadMergePhoneNumber";
const InfoMessageUserInfoKey InfoMessageUserInfoKeySessionSwitchoverPhoneNumber
    = @"InfoMessageUserInfoKeySessionSwitchoverPhoneNumber";

NSUInteger TSInfoMessageSchemaVersion = 2;

@interface TSInfoMessage ()

@property (nonatomic, getter=wasRead) BOOL read;

@property (nonatomic, readonly) NSUInteger infoMessageSchemaVersion;

@end

#pragma mark -

@implementation TSInfoMessage

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self) {
        return self;
    }

    if (self.infoMessageSchemaVersion < 1) {
        _read = YES;
    }

    if (self.infoMessageSchemaVersion < 2) {
        NSString *_Nullable phoneNumber = [coder decodeObjectForKey:@"unregisteredRecipientId"];
        if (phoneNumber) {
            _unregisteredAddress = [SignalServiceAddress legacyAddressWithServiceIdString:nil phoneNumber:phoneNumber];
        }
    }

    _infoMessageSchemaVersion = TSInfoMessageSchemaVersion;

    if (self.isDynamicInteraction) {
        self.read = YES;
    }

    return self;
}

- (instancetype)initWithThread:(TSThread *)thread messageType:(TSInfoMessageType)infoMessage
{
    self = [self initWithThread:thread timestamp:0 messageType:infoMessage];
    return self;
}

- (instancetype)initWithThread:(TSThread *)thread
                     timestamp:(uint64_t)timestamp
                   messageType:(TSInfoMessageType)infoMessage
{
    TSMessageBuilder *builder;
    if (timestamp > 0) {
        builder = [TSMessageBuilder messageBuilderWithThread:thread timestamp:timestamp messageBody:nil];
    } else {
        builder = [TSMessageBuilder messageBuilderWithThread:thread messageBody:nil];
    }
    self = [super initMessageWithBuilder:builder];
    if (!self) {
        return self;
    }

    _messageType = infoMessage;
    _infoMessageSchemaVersion = TSInfoMessageSchemaVersion;

    if (self.isDynamicInteraction) {
        self.read = YES;
    }

    if (_messageType == TSInfoMessageTypeGroupQuit) {
        self.read = YES;
    }

    return self;
}

- (instancetype)initWithThread:(TSThread *)thread
                   messageType:(TSInfoMessageType)infoMessage
                 customMessage:(NSString *)customMessage
{
    self = [self initWithThread:thread messageType:infoMessage];
    if (self) {
        _customMessage = customMessage;
    }
    return self;
}

- (instancetype)initWithThread:(TSThread *)thread
                   messageType:(TSInfoMessageType)infoMessageType
           infoMessageUserInfo:(NSDictionary<InfoMessageUserInfoKey, id> *)infoMessageUserInfo
{
    self = [self initWithThread:thread timestamp:0 messageType:infoMessageType infoMessageUserInfo:infoMessageUserInfo];
    return self;
}

- (instancetype)initWithThread:(TSThread *)thread
                     timestamp:(uint64_t)timestamp
                   messageType:(TSInfoMessageType)infoMessageType
           infoMessageUserInfo:(NSDictionary<InfoMessageUserInfoKey, id> *)infoMessageUserInfo
{
    self = [self initWithThread:thread timestamp:timestamp messageType:infoMessageType];
    if (!self) {
        return self;
    }

    _infoMessageUserInfo = infoMessageUserInfo;

    return self;
}

- (instancetype)initWithThread:(TSThread *)thread
                   messageType:(TSInfoMessageType)infoMessage
           unregisteredAddress:(SignalServiceAddress *)unregisteredAddress
{
    self = [self initWithThread:thread messageType:infoMessage];
    if (self) {
        _unregisteredAddress = unregisteredAddress;
    }
    return self;
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
             receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                          sortId:(uint64_t)sortId
                       timestamp:(uint64_t)timestamp
                  uniqueThreadId:(NSString *)uniqueThreadId
                   attachmentIds:(NSArray<NSString *> *)attachmentIds
                            body:(nullable NSString *)body
                      bodyRanges:(nullable MessageBodyRanges *)bodyRanges
                    contactShare:(nullable OWSContact *)contactShare
                       editState:(TSEditState)editState
                 expireStartedAt:(uint64_t)expireStartedAt
                       expiresAt:(uint64_t)expiresAt
                expiresInSeconds:(unsigned int)expiresInSeconds
                       giftBadge:(nullable OWSGiftBadge *)giftBadge
               isGroupStoryReply:(BOOL)isGroupStoryReply
              isViewOnceComplete:(BOOL)isViewOnceComplete
               isViewOnceMessage:(BOOL)isViewOnceMessage
                     linkPreview:(nullable OWSLinkPreview *)linkPreview
                  messageSticker:(nullable MessageSticker *)messageSticker
                   quotedMessage:(nullable TSQuotedMessage *)quotedMessage
    storedShouldStartExpireTimer:(BOOL)storedShouldStartExpireTimer
           storyAuthorUuidString:(nullable NSString *)storyAuthorUuidString
              storyReactionEmoji:(nullable NSString *)storyReactionEmoji
                  storyTimestamp:(nullable NSNumber *)storyTimestamp
              wasRemotelyDeleted:(BOOL)wasRemotelyDeleted
                   customMessage:(nullable NSString *)customMessage
             infoMessageUserInfo:(nullable NSDictionary<InfoMessageUserInfoKey, id> *)infoMessageUserInfo
                     messageType:(TSInfoMessageType)messageType
                            read:(BOOL)read
             unregisteredAddress:(nullable SignalServiceAddress *)unregisteredAddress
{
    self = [super initWithGrdbId:grdbId
                        uniqueId:uniqueId
               receivedAtTimestamp:receivedAtTimestamp
                            sortId:sortId
                         timestamp:timestamp
                    uniqueThreadId:uniqueThreadId
                     attachmentIds:attachmentIds
                              body:body
                        bodyRanges:bodyRanges
                      contactShare:contactShare
                         editState:editState
                   expireStartedAt:expireStartedAt
                         expiresAt:expiresAt
                  expiresInSeconds:expiresInSeconds
                         giftBadge:giftBadge
                 isGroupStoryReply:isGroupStoryReply
                isViewOnceComplete:isViewOnceComplete
                 isViewOnceMessage:isViewOnceMessage
                       linkPreview:linkPreview
                    messageSticker:messageSticker
                     quotedMessage:quotedMessage
      storedShouldStartExpireTimer:storedShouldStartExpireTimer
             storyAuthorUuidString:storyAuthorUuidString
                storyReactionEmoji:storyReactionEmoji
                    storyTimestamp:storyTimestamp
                wasRemotelyDeleted:wasRemotelyDeleted];

    if (!self) {
        return self;
    }

    _customMessage = customMessage;
    _infoMessageUserInfo = infoMessageUserInfo;
    _messageType = messageType;
    _read = read;
    _unregisteredAddress = unregisteredAddress;

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

+ (instancetype)userNotRegisteredMessageInThread:(TSThread *)thread address:(SignalServiceAddress *)address
{
    OWSAssertDebug(thread);
    OWSAssertDebug(address.isValid);

    return [[self alloc] initWithThread:thread messageType:TSInfoMessageUserNotRegistered unregisteredAddress:address];
}

- (OWSInteractionType)interactionType
{
    return OWSInteractionType_Info;
}

- (NSString *)conversationSystemMessageComponentTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    switch (self.messageType) {
        case TSInfoMessageSyncedThread:
            // This particular string is here, and not in `infoMessagePreviewTextWithTransaction`,
            // because we want it to be excluded from everywhere except chat list rendering.
            // e.g. not in the conversation list preview.
            return OWSLocalizedString(@"INFO_MESSAGE_SYNCED_THREAD",
                                     @"Shown in inbox and conversation after syncing as a placeholder indicating why your message history "
                                     @"is missing.");
        default:
            return [self infoMessagePreviewTextWithTransaction:transaction];
    }
}

- (NSString *)infoMessagePreviewTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    switch (_messageType) {
        case TSInfoMessageTypeSessionDidEnd:
            return OWSLocalizedString(@"SECURE_SESSION_RESET", nil);
        case TSInfoMessageTypeUnsupportedMessage:
            return OWSLocalizedString(@"UNSUPPORTED_ATTACHMENT", nil);
        case TSInfoMessageUserNotRegistered:
            if (self.unregisteredAddress.isValid) {
                NSString *recipientName = [self.contactManagerObjC displayNameStringForAddress:self.unregisteredAddress
                                                                                   transaction:transaction];
                return [NSString stringWithFormat:OWSLocalizedString(@"ERROR_UNREGISTERED_USER_FORMAT",
                                                      @"Format string for 'unregistered user' error. Embeds {{the "
                                                      @"unregistered user's name or signal id}}."),
                                 recipientName];
            } else {
                return OWSLocalizedString(@"CONTACT_DETAIL_COMM_TYPE_INSECURE", nil);
            }
        case TSInfoMessageTypeGroupQuit:
            return OWSLocalizedString(@"GROUP_YOU_LEFT", nil);
        case TSInfoMessageTypeGroupUpdate:
            return [self groupUpdateDescriptionWithTransaction:transaction].string;
        case TSInfoMessageAddToContactsOffer:
            return OWSLocalizedString(@"ADD_TO_CONTACTS_OFFER",
                @"Message shown in conversation view that offers to add an unknown user to your phone's contacts.");
        case TSInfoMessageVerificationStateChange:
            return OWSLocalizedString(@"VERIFICATION_STATE_CHANGE_GENERIC",
                @"Generic message indicating that verification state changed for a given user.");
        case TSInfoMessageAddUserToProfileWhitelistOffer:
            return OWSLocalizedString(@"ADD_USER_TO_PROFILE_WHITELIST_OFFER",
                @"Message shown in conversation view that offers to share your profile with a user.");
        case TSInfoMessageAddGroupToProfileWhitelistOffer:
            return OWSLocalizedString(@"ADD_GROUP_TO_PROFILE_WHITELIST_OFFER",
                @"Message shown in conversation view that offers to share your profile with a group.");
        case TSInfoMessageTypeDisappearingMessagesUpdate:
            break;
        case TSInfoMessageUnknownProtocolVersion:
            break;
        case TSInfoMessageUserJoinedSignal: {
            SignalServiceAddress *address = [TSContactThread contactAddressFromThreadId:self.uniqueThreadId
                                                                            transaction:transaction];
            NSString *recipientName = [self.contactManagerObjC displayNameStringForAddress:address
                                                                               transaction:transaction];
            NSString *format = OWSLocalizedString(@"INFO_MESSAGE_USER_JOINED_SIGNAL_BODY_FORMAT",
                @"Shown in inbox and conversation when a user joins Signal, embeds the new user's {{contact "
                @"name}}");
            return [NSString stringWithFormat:format, recipientName];
        }
        case TSInfoMessageSyncedThread:
            return @"";
        case TSInfoMessageProfileUpdate:
            return [self profileChangeDescriptionWithTransaction:transaction];
        case TSInfoMessagePhoneNumberChange: {
            NSString *_Nullable aciString = self.infoMessageUserInfo[InfoMessageUserInfoKeyChangePhoneNumberAciString];
            if (aciString == nil) {
                OWSFailDebug(@"Invalid info message");
                return @"";
            }
            AciObjC *aci = [[AciObjC alloc] initWithAciString:aciString];
            if (aci == nil) {
                OWSFailDebug(@"Invalid info message");
                return @"";
            }
            SignalServiceAddress *address = [[SignalServiceAddress alloc] initWithServiceIdObjC:aci];
            NSString *userName = [self.contactManagerObjC displayNameStringForAddress:address transaction:transaction];

            NSString *format = OWSLocalizedString(@"INFO_MESSAGE_USER_CHANGED_PHONE_NUMBER_FORMAT",
                @"Indicates that another user has changed their phone number. Embeds: {{ the user's name}}".);
            return [NSString stringWithFormat:format, userName];
        }
        case TSInfoMessageRecipientHidden: {
            /// This does not control whether to show the info message in the chat
            /// preview. To control that, see ``TSInteraction.shouldAppearInInbox``.
            SignalServiceAddress *address = [TSContactThread contactAddressFromThreadId:self.uniqueThreadId
                                                                            transaction:transaction];
            if ([RecipientHidingManagerObjcBridge isHiddenAddress:address tx:transaction]) {
                return OWSLocalizedString(@"INFO_MESSAGE_CONTACT_REMOVED",
                    @"Indicates that the recipient has been removed from the current user's contacts and that "
                    @"messaging them will re-add them.");
            } else {
                return OWSLocalizedString(@"INFO_MESSAGE_CONTACT_REINSTATED",
                    @"Indicates that a previously-removed recipient has been added back to the current user's "
                    @"contacts.");
            }
        }
        case TSInfoMessagePaymentsActivationRequest:
            return [self paymentsActivationRequestDescriptionWithTransaction:transaction];
        case TSInfoMessagePaymentsActivated:
            return [self paymentsActivatedDescriptionWithTransaction:transaction];
        case TSInfoMessageThreadMerge:
            return [self threadMergeDescriptionWithTx:transaction];
        case TSInfoMessageSessionSwitchover:
            return [self sessionSwitchoverDescriptionWithTx:transaction];
        case TSInfoMessageReportedSpam:
            return OWSLocalizedString(
                @"INFO_MESSAGE_REPORTED_SPAM", @"Shown when a user reports a conversation as spam.");
    }

    OWSFailDebug(@"Unknown info message type");
    return @"";
}

#pragma mark - OWSReadTracking

- (BOOL)shouldAffectUnreadCounts
{
    switch (self.messageType) {
        case TSInfoMessageTypeSessionDidEnd:
        case TSInfoMessageUserNotRegistered:
        case TSInfoMessageTypeUnsupportedMessage:
        case TSInfoMessageTypeGroupUpdate:
        case TSInfoMessageTypeGroupQuit:
        case TSInfoMessageTypeDisappearingMessagesUpdate:
        case TSInfoMessageAddToContactsOffer:
        case TSInfoMessageVerificationStateChange:
        case TSInfoMessageAddUserToProfileWhitelistOffer:
        case TSInfoMessageAddGroupToProfileWhitelistOffer:
        case TSInfoMessageUnknownProtocolVersion:
        case TSInfoMessageSyncedThread:
        case TSInfoMessageProfileUpdate:
        case TSInfoMessagePhoneNumberChange:
        case TSInfoMessageRecipientHidden:
        case TSInfoMessagePaymentsActivationRequest:
        case TSInfoMessagePaymentsActivated:
        case TSInfoMessageThreadMerge:
        case TSInfoMessageSessionSwitchover:
        case TSInfoMessageReportedSpam:
            return NO;
        case TSInfoMessageUserJoinedSignal:
            // In the conversation list, we want conversations with an unread "new user" notification to
            // be badged and bolded, like they received a message.
            return YES;
    }
}

- (uint64_t)expireStartedAt
{
    return 0;
}

- (void)markAsReadAtTimestamp:(uint64_t)readTimestamp
                       thread:(TSThread *)thread
                 circumstance:(OWSReceiptCircumstance)circumstance
     shouldClearNotifications:(BOOL)shouldClearNotifications
                  transaction:(SDSAnyWriteTransaction *)transaction
{
    OWSAssertDebug(transaction);

    if (self.read) {
        return;
    }

    OWSLogDebug(@"marking as read uniqueId: %@ which has timestamp: %llu", self.uniqueId, self.timestamp);

    [self anyUpdateInfoMessageWithTransaction:transaction
                                        block:^(TSInfoMessage *message) {
                                            message.read = YES;
                                        }];

    // Ignore `circumstance` - we never send read receipts for info messages.
}

@end

NS_ASSUME_NONNULL_END
