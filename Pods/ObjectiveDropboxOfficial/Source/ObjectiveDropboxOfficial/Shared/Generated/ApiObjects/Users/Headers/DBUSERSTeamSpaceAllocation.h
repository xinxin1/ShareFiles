///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBUSERSTeamSpaceAllocation;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `TeamSpaceAllocation` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBUSERSTeamSpaceAllocation : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The total space currently used by the user's team (bytes).
@property (nonatomic, readonly) NSNumber *used;

/// The total space allocated to the user's team (bytes).
@property (nonatomic, readonly) NSNumber *allocated;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param used The total space currently used by the user's team (bytes).
/// @param allocated The total space allocated to the user's team (bytes).
///
/// @return An initialized instance.
///
- (instancetype)initWithUsed:(NSNumber *)used allocated:(NSNumber *)allocated;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `TeamSpaceAllocation` struct.
///
@interface DBUSERSTeamSpaceAllocationSerializer : NSObject

///
/// Serializes `DBUSERSTeamSpaceAllocation` instances.
///
/// @param instance An instance of the `DBUSERSTeamSpaceAllocation` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBUSERSTeamSpaceAllocation` API object.
///
+ (nullable NSDictionary *)serialize:(DBUSERSTeamSpaceAllocation *)instance;

///
/// Deserializes `DBUSERSTeamSpaceAllocation` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBUSERSTeamSpaceAllocation` API object.
///
/// @return An instantiation of the `DBUSERSTeamSpaceAllocation` object.
///
+ (DBUSERSTeamSpaceAllocation *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
