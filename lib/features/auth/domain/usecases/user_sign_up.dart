//we dont want  usecases to be any thing, we want it to conform to a specific way of writing it or rules
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

//UserModel is only used in datalayer it is only used to convert the raw data into a model we created specifically for the datalayer
//UserEntity is the one we are using for our app
class UserSignUp extends Usecase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    //even though its abstract you can still call the abstract methods, you only cant instantiate abstract class
    //because im passing an instance of AuthRepository through the dependency injection
    return await authRepository.signUpWithEmailPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSignUpParams {
  final String email;
  final String name;
  final String password;

  UserSignUpParams(
      {required this.email, required this.name, required this.password});
}
