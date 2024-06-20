part of "injection_part.dart";

class DependencyInjector {
  static final getIt = GetIt.instance;

  static Future<void> setup() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.defaultDirectory = dir.path;
    final sharedPref = await SharedPreferences.getInstance();
    //put hive data in the default directory
    getIt.registerSingleton(sharedPref);
    getIt.registerLazySingleton<Dio>(
        () => Dio()..options.baseUrl = AppSecrets.baseUrl);
    getIt.registerFactory(() => InternetConnection());
    getIt.registerFactory<ConnectionChecker>(
        () => ConnectionCheckerImpl(getIt()));
    getIt.registerLazySingleton<LoggedStatusCubit>(() => LoggedStatusCubit());

    getIt.registerLazySingleton<HiveBoxService>(() => HiveBoxService());

    _initAuthFeature();
    _initBlogFeature();
  }

  static void _initAuthFeature() async {
    getIt
      //make sure to register, so we can use it or not it will error
      //order doesnt matter (it finds looks for registered based on the param)
      //registerFactory (everytime we call it it creates a new instance of the class)
      //registerLazySingleton ( everytime we call it , we instantiate when it is called)
      //add generic type because for example UserSignUp needs AuthRepository the abstract instead of AuthRepositoryImpl\
      ..registerFactory<AuthRepository>(
          () => AuthRepositoryImpl(getIt(), getIt(), getIt()))
      ..registerFactory<UserSignUp>(() => UserSignUp(getIt()))
      ..registerFactory<UserLogin>(() => UserLogin(getIt()))
      ..registerFactory<CurrentUser>(() => CurrentUser(getIt()))
      ..registerFactory<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(dio: getIt()))
      ..registerFactory<AuthLocalDataSource>(
          () => AuthLocalDataSourceImpl(prefs: getIt()))
      ..registerLazySingleton<AuthBloc>(() => AuthBloc(getIt(),
          userSignUp: getIt(), userLogin: getIt(), currentUser: getIt()));
  }

  static void _initBlogFeature() async {
    getIt
      ..registerLazySingleton<ImageStorageService>(() => ImageStorageService())
      ..registerFactory<BlogRemoteDataSource>(
          () => BlogRemoteDataSourceImpl(dio: getIt(), imageService: getIt()))
      ..registerFactory<BlogLocalDataSource>(
          () => BlogLocalDataSourceImpl(getIt()))
      ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(getIt(),
          blogRemoteDataSource: getIt(),
          blogLocalDataSource: getIt(),
          connectionChecker: getIt()))
      ..registerFactory(() => UploadBlog(getIt()))
      ..registerFactory(() => GetAllBlogs(getIt()))
      ..registerLazySingleton(
          () => BlogBloc(uploadBlog: getIt(), getAllBlogs: getIt()));
  }
}
