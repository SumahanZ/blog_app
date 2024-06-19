import 'package:blog_app/core/common/cubits/logged_status_cubit.dart';
import 'package:blog_app/core/common/services/hive_service.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/blogs/presentation/pages/blog_page.dart';
import 'package:blog_app/injection_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  //call this always before any async calls
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjector.setup();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    DependencyInjector.getIt<AuthBloc>().add(AuthCurrentUserEvent(
        HiveBoxService.getValues(
                box: HiveBoxService.getBox("auth"), key: "token") ??
            ""));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<LoggedStatusCubit, LoggedStatusState, bool>(
        bloc: DependencyInjector.getIt<LoggedStatusCubit>(),
        selector: (state) {
          return state is LoggedStatusStateInitialLoggedIn;
        },
        builder: (context, state) {
          if (state) {
            return const BlogPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
