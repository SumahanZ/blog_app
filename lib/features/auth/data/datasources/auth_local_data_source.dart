//create interface for the authremotedatasource, so whenever we have to change supabase to any other database, we have a strict rule to follow

//datasource we are only concerned with calls made to the external database, we don;t want any other dependencies
import 'package:blog_app/core/common/services/hive_service.dart';
import 'package:blog_app/core/exception/exception.dart';
import 'package:hive/hive.dart';

abstract interface class AuthLocalDataSource {
  void saveToken({required String token});
  String getToken();
}

//pass in the supabaseClient using DI instead of instantiating it
//to make it easier to test (making a mock) and make AuthRemoteDataSource not dependent on Dio client
class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  final Box<dynamic> box;

  AuthLocalDataSourceImpl({required this.box});

  @override
  void saveToken({required String token}) {
    try {
      HiveBoxService.insertBox<String>(box: box, key: "token", values: token);
    } catch (e) {
      throw LocalException(errorMessage: e.toString());
    }
  }

  @override
  String getToken() {
    return HiveBoxService.getValues<String>(box: box, key: "token");
  }
}
