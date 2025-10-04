
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_service.dart';
import '../models/expense_model.dart';
import '../screens/add_category_screen.dart';
import '../screens/add_expense_screen.dart';
import '../screens/budget_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/expense_history_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/signup_screen.dart';

class AppRouter {
  final AuthService _authService = AuthService();

  GoRouter get router => GoRouter(
        initialLocation: _authService.currentUser == null ? '/login' : '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/signup',
            builder: (context, state) => const SignupScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/add_expense',
            builder: (context, state) => AddExpenseScreen(expense: state.extra as Expense?),
          ),
          GoRoute(
            path: '/add_category',
            builder: (context, state) => const AddCategoryScreen(),
          ),
          GoRoute(
            path: '/budget',
            builder: (context, state) => const BudgetScreen(),
          ),
          GoRoute(
            path: '/expense_history',
            builder: (context, state) => const ExpenseHistoryScreen(),
          ),
        ],
        redirect: (context, state) {
          final bool loggedIn = _authService.currentUser != null;
          final bool loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

          if (!loggedIn && !loggingIn) {
            return '/login';
          }

          if (loggedIn && loggingIn) {
            return '/';
          }

          return null;
        },
      );
}
