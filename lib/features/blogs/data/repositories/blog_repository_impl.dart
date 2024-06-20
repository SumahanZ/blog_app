import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/exception/exception.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:blog_app/features/blogs/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blogs/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blogs/data/model/blog_model.dart';
import 'package:blog_app/features/blogs/domain/entity/blog.dart';
import 'package:blog_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource _blogRemoteDataSource;
  final BlogLocalDataSource _blogLocalDataSource;
  final ConnectionChecker _connectionChecker;
  final AuthLocalDataSource _authLocalDataSource;

  BlogRepositoryImpl(this._authLocalDataSource,
      {required BlogRemoteDataSource blogRemoteDataSource,
      required BlogLocalDataSource blogLocalDataSource,
      required ConnectionChecker connectionChecker})
      : _blogRemoteDataSource = blogRemoteDataSource,
        _blogLocalDataSource = blogLocalDataSource,
        _connectionChecker = connectionChecker;

  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String authorId,
      required List<String> topics}) async {
    try {
      final token = _authLocalDataSource.getToken();
      if (token == "" || token == null) {
        return Left(ResponseFailure(
            message: "Token is not valid, please login again."));
      }

      if (!await (_connectionChecker.isConnected)) {
        return Left(Failure(message: "No internet connection!"));
      }

      BlogModel blogModel = BlogModel(
          id: const Uuid().v1(),
          authorId: authorId,
          title: title,
          content: content,
          imageUrl: "",
          topics: topics,
          updatedAt: DateTime.now());

      final imageUrl =
          await _blogRemoteDataSource.uploadBlogImage(image: image);

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      return Right(await _blogRemoteDataSource.uploadBlog(
          blog: blogModel, token: token));
    } on ServerException catch (err) {
      return Left(ResponseFailure(message: err.errorMessage ?? ""));
    } on UnknownException catch (_) {
      return Left(ResponseFailure());
    } on LocalException catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      final token = _authLocalDataSource.getToken();
      if (token == "" || token == null) {
        return Left(ResponseFailure(
          message: "Token is not valid, please login again.",
        ));
      }

      if (!await (_connectionChecker.isConnected)) {
        return Right(_blogLocalDataSource.loadBlogs());
      }

      final blogs = await _blogRemoteDataSource.getAllBlogs(token: token);
      _blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return Right(blogs);
    } on ServerException catch (err) {
      return Left(ResponseFailure(message: err.errorMessage ?? ""));
    } on UnknownException catch (_) {
      return Left(ResponseFailure());
    } on LocalException catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }
}
