import 'dart:async';
import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blogs/domain/entity/blog.dart';
import 'package:blog_app/features/blogs/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blogs/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
      : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogGetAllEvent>(_onGetAll);
  }

  FutureOr<void> _onBlogUpload(
      BlogUploadEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog.call(UploadBlogParams(
      authorId: event.authorId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));

    res.fold(
        (l) => emit(BlogFailure(l.message)), (r) => emit(BlogUploadSuccess()));
  }

  FutureOr<void> _onGetAll(
      BlogGetAllEvent event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs.call(NoParams());

    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogDisplaySuccess(r)),
    );
  }
}
