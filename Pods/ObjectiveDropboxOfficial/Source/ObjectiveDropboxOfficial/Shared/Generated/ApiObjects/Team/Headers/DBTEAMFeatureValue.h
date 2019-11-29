///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMFeatureValue;
@class DBTEAMHasTeamFileEventsValue;
@class DBTEAMHasTeamSharedDropboxValue;
@class DBTEAMUploadApiRateLimitValue;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `FeatureValue` union.
///
/// The values correspond to entries in Feature. You may get different value
/// according to your Dropbox for Business plan.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMFeatureValue : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBTEAMFeatureValueTag` enum type represents the possible tag states
/// with which the `DBTEAMFeatureValue` union can exist.
typedef NS_ENUM(NSInteger, DBTEAMFeatureValueTag) {
  /// (no description).
  DBTEAMFeatureValueUploadApiRateLimit,

  /// (no description).
  DBTEAMFeatureValueHasTeamSharedDropbox,

  /// (no description).
  DBTEAMFeatureValueHasTeamFileEvents,

  /// (no description).
  DBTEAMFeatureValueOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBTEAMFeatureValueTag tag;

/// (no description). @note Ensure the `isUploadApiRateLimit` method returns
/// true before accessing, otherwise a runtime exception will be raised.
@property (nonatomic, readonly) DBTEAMUploadApiRateLimitValue *uploadApiRateLimit;

/// (no description). @note Ensure the `isHasTeamSharedDropbox` method returns
/// true before accessing, otherwise a runtime exception will be raised.
@property (nonatomic, readonly) DBTEAMHasTeamSharedDropboxValue *hasTeamSharedDropbox;

/// (no description). @note Ensure the `isHasTeamFileEvents` method returns true
/// before accessing, otherwise a runtime exception will be raised.
@property (nonatomic, readonly) DBTEAMHasTeamFileEventsValue *hasTeamFileEvents;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "upload_api_rate_limit".
///
/// @param uploadApiRateLimit (no description).
///
/// @return An initialized instance.
///
- (instancetype)initWithUploadApiRateLimit:(DBTEAMUploadApiRateLimitValue *)uploadApiRateLimit;

///
/// Initializes union class with tag state of "has_team_shared_dropbox".
///
/// @param hasTeamSharedDropbox (no description).
///
/// @return An initialized instance.
///
- (instancetype)initWithHasTeamSharedDropbox:(DBTEAMHasTeamSharedDropboxValue *)hasTeamSharedDropbox;

///
/// Initializes union class with tag state of "has_team_file_events".
///
/// @param hasTeamFileEvents (no description).
///
/// @return An initialized instance.
///
- (instancetype)initWithHasTeamFileEvents:(DBTEAMHasTeamFileEventsValue *)hasTeamFileEvents;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (instancetype)initWithOther;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value
/// "upload_api_rate_limit".
///
/// @note Call this method and ensure it returns true before accessing the
/// `uploadApiRateLimit` property, otherwise a runtime exception will be thrown.
///
/// @return Whether the union's current tag state has value
/// "upload_api_rate_limit".
///
- (BOOL)isUploadApiRateLimit;

///
/// Retrieves whether the union's current tag state has value
/// "has_team_shared_dropbox".
///
/// @note Call this method and ensure it returns true before accessing the
/// `hasTeamSharedDropbox` property, otherwise a runtime exception will be
/// thrown.
///
/// @return Whether the union's current tag state has value
/// "has_team_shared_dropbox".
///
- (BOOL)isHasTeamSharedDropbox;

///
/// Retrieves whether the union's current tag state has value
/// "has_team_file_events".
///
/// @note Call this method and ensure it returns true before accessing the
/// `hasTeamFileEvents` property, otherwise a runtime exception will be thrown.
///
/// @return Whether the union's current tag state has value
/// "has_team_file_events".
///
- (BOOL)isHasTeamFileEvents;

///
/// Retrieves whether the union's current tag state has value "other".
///
/// @return Whether the union's current tag state has value "other".
///
- (BOOL)isOther;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString *)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DBTEAMFeatureValue` union.
///
@interface DBTEAMFeatureValueSerializer : NSObject

///
/// Serializes `DBTEAMFeatureValue` instances.
///
/// @param instance An instance of the `DBTEAMFeatureValue` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMFeatureValue` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMFeatureValue *)instance;

///
/// Deserializes `DBTEAMFeatureValue` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMFeatureValue` API object.
///
/// @return An instantiation of the `DBTEAMFeatureValue` object.
///
+ (DBTEAMFeatureValue *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END