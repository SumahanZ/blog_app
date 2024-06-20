import 'package:blog_app/core/services/hive_service.dart';
import 'package:blog_app/features/blogs/data/model/blog_model.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final HiveBoxService hiveBoxService;

  BlogLocalDataSourceImpl(this.hiveBoxService);

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    final box = hiveBoxService.getBox("blogs");

    box.read(() {
      //box length is the number of entries present in the box
      //use transaction (because of for loop)
      //convert that has been converted to json format to BlogModel
      for (int i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromJson(box.get(i.toString())));
      }
    });

    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    final box = hiveBoxService.getBox("blogs");
    //clear the local storage when internet is restablished
    box.clear();
    box.write(() {
      //im putting a json format to the local storage
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
