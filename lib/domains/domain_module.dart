import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/manage_apis_screen.dart';

final domainRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/result', builder: (_, __) => const ResultScreen()),
    GoRoute(path: '/apis', builder: (_, __) => const ManageDomainApisScreen()),
  ],
);