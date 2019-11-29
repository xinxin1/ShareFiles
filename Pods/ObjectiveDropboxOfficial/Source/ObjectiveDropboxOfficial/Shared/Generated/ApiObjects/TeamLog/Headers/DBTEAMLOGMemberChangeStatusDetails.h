///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGJoinTeamDetails;
@class DBTEAMLOGMemberChangeStatusDetails;
@class DBTEAMLOGMemberStatus;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `MemberChangeStatusDetails` struct.
///
/// Changed the membership status of a team member.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGMemberChangeStatusDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Previous member status. Might be missing due to historical data gap.
@property (nonatomic, readonly, nullable) DBTEAMLOGMemberStatus *previousValue;

/// New member status.
@property (nonatomic, readonly) DBTEAMLOGMemberStatus *dNewValue;

/// Additional information relevant when a new member joins the team.
@property (nonatomic, readonly, nullable) DBTEAMLOGJoinTeamDetails *teamJoinDetails;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param dNewValue New member status.
/// @param previousValue Previous member status. Might be missing due to
/// historical data gap.
/// @param teamJoinDetails Additional information relevant when a new member
/// joins the team.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGMemberStatus *)dNewValue
                    previousValue:(nullable DBTEAMLOGMemberStatus *)previousValue
                  teamJoinDetails:(nullable DBTEAMLOGJoinTeamDetails *)teamJoinDetails;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param dNewValue New member status.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGMemberStatus *)dNewValue;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `MemberChangeStatusDetails` struct.
///
@interface DBTEAMLOGMemberChangeStatusDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGMemberChangeStatusDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGMemberChangeStatusDetails` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGMemberChangeStatusDetails` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGMemberChangeStatusDetails *)instance;

///
/// Deserializes `DBTEAMLOGMemberChangeStatusDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGMemberChangeStatusDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGMemberChangeStatusDetails` object.
///
+ (DBTEAMLOGMemberChangeStatusDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
