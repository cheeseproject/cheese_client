// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snap_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SnapPost _$$_SnapPostFromJson(Map<String, dynamic> json) => _$_SnapPost(
      snapPostId: json['snapPostId'] as String,
      userId: json['userId'] as String,
      postImages: (json['postImages'] as List<dynamic>)
          .map((e) => PostImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      title: json['title'] as String,
      comment: json['comment'] as String?,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      postedAt: json['postedAt'] as String,
      updatedAt: json['updatedAt'] as String,
      likedCount: json['likedCount'] as int,
      postedUser:
          PostedUser.fromJson(json['postedUser'] as Map<String, dynamic>),
      address: json['address'] as String,
    );

Map<String, dynamic> _$$_SnapPostToJson(_$_SnapPost instance) =>
    <String, dynamic>{
      'snapPostId': instance.snapPostId,
      'userId': instance.userId,
      'postImages': instance.postImages.map((e) => e.toJson()).toList(),
      'tags': instance.tags,
      'title': instance.title,
      'comment': instance.comment,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'postedAt': instance.postedAt,
      'updatedAt': instance.updatedAt,
      'likedCount': instance.likedCount,
      'postedUser': instance.postedUser.toJson(),
      'address': instance.address,
    };
