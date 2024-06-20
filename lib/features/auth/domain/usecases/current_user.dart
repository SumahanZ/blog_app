import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository _authRepository;

  CurrentUser(this._authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await _authRepository.getUserData();
  }
}
