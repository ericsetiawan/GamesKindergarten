import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routers/app_router.dart';
import 'features/auth/auth_cubit.dart';
import 'features/onboarding/onboarding_cubit.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _router = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnboardingCubit()),
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Games',
        routerConfig: _router.router,
      ),
    );
  }
}