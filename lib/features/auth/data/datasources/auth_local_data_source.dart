//create interface for the authremotedatasource, so whenever we have to change supabase to any other database, we have a strict rule to follow

//datasource we are only concerned with calls made to the external database, we don;t want any other dependencies
import 'package:blog_app/core/exception/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalDataSource {
  void saveToken({required String token});
  String? getToken();
}

//pass in the supabaseClient using DI instead of instantiating it
//to make it easier to test (making a mock) and make AuthRemoteDataSource not dependent on Dio client
class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  void saveToken({required String token}) async {
    try {
      //change sharedpreference
      await prefs.setString('token', token);
    } catch (e) {
      throw LocalException(errorMessage: e.toString());
    }
  }

  @override
  String? getToken() {
    try {
      return prefs.getString("token");
    } catch (e) {
      return null;
    }
  }
}
