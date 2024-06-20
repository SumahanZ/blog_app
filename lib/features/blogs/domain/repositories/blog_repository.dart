import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blogs/domain/entity/blog.dart';
import 'package:fpdart/fpdart.dart';

//why I dont take blogModel here?
//Because im going to create a blogmodel inside of blogrepository implementation
abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String authorId,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
