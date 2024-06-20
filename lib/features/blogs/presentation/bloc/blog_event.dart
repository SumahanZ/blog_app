part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUploadEvent extends BlogEvent {
  final String authorId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  BlogUploadEvent(
      {required this.authorId,
      required this.title,
      required this.content,
      required this.image,
      required this.topics});
}

final class BlogGetAllEvent extends BlogEvent {}
