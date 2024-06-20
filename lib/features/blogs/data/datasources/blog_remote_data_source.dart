import 'dart:convert';
import 'dart:io';

import 'package:blog_app/core/services/image_service.dart';
import 'package:blog_app/core/exception/exception.dart';
import 'package:blog_app/features/blogs/data/model/blog_model.dart';
import 'package:dio/dio.dart';

//repository layer we gonna call the method to upload the image of the blog there instead of calling it in the uploadBlog function in datasource
//datasource is only concerned with making a network call/fetching data/posting data from the data provider
abstract interface class BlogRemoteDataSource {
  Future<List<BlogModel>> getAllBlogs({required String token});
  Future<BlogModel> uploadBlog(
      {required BlogModel blog, required String token});
  Future<String> uploadBlogImage({required File image});
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final Dio dio;
  final ImageStorageService imageService;

  BlogRemoteDataSourceImpl({
    required this.dio,
    required this.imageService,
  });

  @override
  Future<BlogModel> uploadBlog(
      {required BlogModel blog, required String token}) async {
    final response = await dio.post("/upload-blog",
        data: blog.toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
          "Bearer-token": token
        }));

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw ServerException(
          errorMessage: response.statusMessage,
          statusCode: response.statusCode.toString());
    } else if (response.statusCode != null) {
      return BlogModel.fromJson(jsonEncode(response.data));
    } else {
      throw UnknownException(
          errorMessage: response.statusMessage,
          statusCode: response.statusCode.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({required File image}) async {
    final imageUrl = await imageService.uploadImage(image.path);
    return imageUrl;
  }

  @override
  Future<List<BlogModel>> getAllBlogs({required String token}) async {
    final response = await dio.get("/fetch-blogs",
        options: Options(headers: {
          'Content-Type': 'application/json',
          "Bearer-token": token,
        }));

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw ServerException(
          errorMessage: response.statusMessage,
          statusCode: response.statusCode.toString());
    } else if (response.statusCode != null) {
      final unConvertedListBlogs =
          List<Map<String, dynamic>>.from(response.data);
      return unConvertedListBlogs
          .map((e) => BlogModel.fromJson(jsonEncode(e))
              .copyWith(posterName: e["username"]))
          .toList();
    } else {
      throw UnknownException(
          errorMessage: response.statusMessage,
          statusCode: response.statusCode.toString());
    }
  }
}
