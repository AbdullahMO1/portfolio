import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/router/app_router.dart';
import 'package:portoflio/theme/app_theme.dart';
import 'package:portoflio/theme/theme_notifier.dart';

void main() {
  runApp(const ProviderScope(child: PortfolioApp()));
}

/// Root application widget.
///
/// Wired to:
/// - [appRouter] for declarative routing with deep linking
/// - [themeNotifierProvider] for dynamic light/dark mode
/// - [AppTheme] for Material 3 theming
class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Abdullah Mohammed — Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
