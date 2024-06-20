import 'dart:convert';

import 'package:blog_app/features/blogs/domain/entity/blog.dart';
import 'package:flutter/foundation.dart';

class BlogModel extends Blog {
  BlogModel(
      {required super.id,
      required super.authorId,
      required super.title,
      required super.content,
      required super.imageUrl,
      required super.topics,
      required super.updatedAt,
      super.posterName});

  BlogModel copyWith({
    String? id,
    String? authorId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return BlogModel(
        id: id ?? this.id,
        authorId: authorId ?? this.authorId,
        title: title ?? this.title,
        content: content ?? this.content,
        imageUrl: imageUrl ?? this.imageUrl,
        topics: topics ?? this.topics,
        updatedAt: updatedAt ?? this.updatedAt,
        posterName: posterName ?? this.posterName);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'authorId': authorId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'topics': topics,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      id: map['_id'] ?? "",
      authorId: map['authorId'] ?? "",
      title: map['title'] ?? "",
      content: map['content'] ?? "",
      imageUrl: map['imageUrl'] ?? "",
      topics: List<String>.from((map['topics'] ?? [])),
      updatedAt: map["updatedAt"] != null
          ? DateTime.parse(map["updatedAt"])
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogModel.fromJson(String source) =>
      BlogModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BlogModel(id: $id, authorId: $authorId, title: $title, content: $content, imageUrl: $imageUrl, topics: $topics, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant BlogModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.authorId == authorId &&
        other.title == title &&
        other.content == content &&
        other.imageUrl == imageUrl &&
        listEquals(other.topics, topics) &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        authorId.hashCode ^
        title.hashCode ^
        content.hashCode ^
        imageUrl.hashCode ^
        topics.hashCode ^
        updatedAt.hashCode;
  }
}
