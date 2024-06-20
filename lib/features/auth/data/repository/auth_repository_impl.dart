import "package:blog_app/core/error/failure.dart";
import "package:blog_app/core/exception/exception.dart";
import "package:blog_app/core/network/connection_checker.dart";
import "package:blog_app/features/auth/data/datasources/auth_local_data_source.dart";
import "package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart";
import "package:blog_app/core/common/entities/user.dart";
import "package:blog_app/features/auth/data/models/user_model.dart";
import "package:blog_app/features/auth/domain/repository/auth_repository.dart";
import "package:fpdart/fpdart.dart";

final class AuthRepositoryImpl implements AuthRepository {
  //DEPENDING ON THE INTERFACE INSTEAD OF THE CONCRETE IMPLEMENTATION
  //WE DONT CARE ABOUT HOW THE IMPLEMENTATION WAS DONE, WE JUST CARE IF THE METHOD EXIST OR NOT IN THE CONTRACT
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final ConnectionChecker connectionChecker;

  const AuthRepositoryImpl(this.authRemoteDataSource, this.authLocalDataSource,
      this.connectionChecker);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return Left(Failure(message: "No internet connection!"));
      }
      final userModel = await authRemoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );

      if (userModel.token != null && userModel.token != "") {
        authLocalDataSource.saveToken(token: userModel.token!);
      }
      return Right(userModel.toEntity());
    } on ServerException catch (err) {
      return Left(ResponseFailure(message: err.errorMessage ?? ""));
    } on UnknownException catch (_) {
      return Left(ResponseFailure());
    } on LocalException catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    //wrap with try catch block to handle the exceptions
    try {
      if (!await (connectionChecker.isConnected)) {
        return Left(Failure(message: "No internet connection!"));
      }

      final userModel = await authRemoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );

      return Right(userModel.toEntity());
    } on ServerException catch (err) {
      return Left(ResponseFailure(message: err.errorMessage ?? ""));
    } on UnknownException catch (_) {
      return Left(ResponseFailure());
    } catch (err) {
      return Left(ResponseFailure(message: err.toString()));
    }
  }

//getting token/uploading image/etc will be handled in repository
  @override
  Future<Either<Failure, User>> getUserData() async {
    try {
      final receivedToken = authLocalDataSource.getToken();

      if (receivedToken == "" || receivedToken == null) {
        return Left(Failure(message: "Not logged in"));
      }

      if (!await (connectionChecker.isConnected)) {
        return Right(UserModel(id: "", email: "", name: "").toEntity());
      }

      final userModel =
          await authRemoteDataSource.getUserData(token: receivedToken);

      if (userModel == null) {
        return Left(ResponseFailure(message: "User not logged in!"));
      }

      return Right(userModel.toEntity());
    } on ServerException catch (err) {
      return Left(ResponseFailure(message: err.errorMessage ?? ""));
    } on UnknownException catch (_) {
      return Left(ResponseFailure());
    } catch (err) {
      return Left(ResponseFailure(message: err.toString()));
    }
  }
}
