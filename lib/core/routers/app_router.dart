
import 'package:go_router/go_router.dart';
import 'package:kinder_quest/features/auth/login_page.dart';
import 'package:kinder_quest/features/home/presentation/pages/home_page.dart';
import 'package:kinder_quest/features/onboarding/onboarding_page.dart';


class AppRouter {
  final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => OnboardingPage()),
      GoRoute(path: '/login', builder: (_, __) => LoginPage()),
      GoRoute(path: '/home', builder: (_, __) => HomePage()),
    ],
  );
}