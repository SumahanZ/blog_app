part of "injection_part.dart";

class DependencyInjector {
  static final getIt = GetIt.instance;

  static Future<void> setup() async {
    await Hive.initFlutter();
    await Hive.openBox("auth");
    getIt.registerLazySingleton<Box<dynamic>>(() => Hive.box("auth"));
    _initAuthFeature();
    getIt.registerLazySingleton<Dio>(
        () => Dio()..options.baseUrl = AppSecrets.baseUrl);
  }

  static void _initAuthFeature() async {
    getIt
      //make sure to register, so we can use it or not it will error
      //order doesnt matter (it finds looks for registered based on the param)
      //registerFactory (everytime we call it it creates a new instance of the class)
      //registerLazySingleton ( everytime we call it , we instantiate when it is called)
      //add generic type because for example UserSignUp needs AuthRepository the abstract instead of AuthRepositoryImpl\
      ..registerFactory<AuthRepository>(
          () => AuthRepositoryImpl(getIt(), getIt()))
      ..registerFactory<UserSignUp>(() => UserSignUp(getIt()))
      ..registerFactory<UserLogin>(() => UserLogin(getIt()))
      ..registerFactory<CurrentUser>(() => CurrentUser(getIt()))
      ..registerFactory<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(dio: getIt()))
      ..registerFactory<AuthLocalDataSource>(
          () => AuthLocalDataSourceImpl(box: getIt()))
      ..registerLazySingleton<LoggedStatusCubit>(() => LoggedStatusCubit())
      ..registerLazySingleton<AuthBloc>(() => AuthBloc(getIt(),
          userSignUp: getIt(), userLogin: getIt(), currentUser: getIt()));
  }
}
