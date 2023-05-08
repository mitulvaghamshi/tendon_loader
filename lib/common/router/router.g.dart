// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $tendonLoaderRoute,
    ];

RouteBase get $tendonLoaderRoute => GoRouteData.$route(
      path: '/',
      factory: $TendonLoaderRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'app',
          factory: $HomeScreenRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'live-data',
              factory: $LiveDataRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'mvc-testing',
              factory: $MVCTestingRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'new-mvc-test',
              factory: $NewMVCTestRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'exercise-mode',
              factory: $ExerciseModeRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'new-exercise/:userId/:readOnly',
              factory: $NewExerciseRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'prompt-screen/:key',
              factory: $PromptScreenRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'web',
          factory: $HomePageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'exports/:userId',
              factory: $ExportListRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'export-view',
              factory: $ExportViewRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'session-info',
              factory: $SessionInfoRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'exercise-history/:userId',
              factory: $ExerciseHistoryRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'settings',
          factory: $SettingScreenRouteExtension._fromState,
        ),
      ],
    );

extension $TendonLoaderRouteExtension on TendonLoaderRoute {
  static TendonLoaderRoute _fromState(GoRouterState state) =>
      const TendonLoaderRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $HomeScreenRouteExtension on HomeScreenRoute {
  static HomeScreenRoute _fromState(GoRouterState state) =>
      const HomeScreenRoute();

  String get location => GoRouteData.$location(
        '/app',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $LiveDataRouteExtension on LiveDataRoute {
  static LiveDataRoute _fromState(GoRouterState state) => const LiveDataRoute();

  String get location => GoRouteData.$location(
        '/app/live-data',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $MVCTestingRouteExtension on MVCTestingRoute {
  static MVCTestingRoute _fromState(GoRouterState state) =>
      const MVCTestingRoute();

  String get location => GoRouteData.$location(
        '/app/mvc-testing',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $NewMVCTestRouteExtension on NewMVCTestRoute {
  static NewMVCTestRoute _fromState(GoRouterState state) =>
      const NewMVCTestRoute();

  String get location => GoRouteData.$location(
        '/app/new-mvc-test',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $ExerciseModeRouteExtension on ExerciseModeRoute {
  static ExerciseModeRoute _fromState(GoRouterState state) =>
      const ExerciseModeRoute();

  String get location => GoRouteData.$location(
        '/app/exercise-mode',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $NewExerciseRouteExtension on NewExerciseRoute {
  static NewExerciseRoute _fromState(GoRouterState state) => NewExerciseRoute(
        userId: state.pathParameters['userId']!,
        readOnly: _$boolConverter(state.pathParameters['readOnly']!),
      );

  String get location => GoRouteData.$location(
        '/app/new-exercise/${Uri.encodeComponent(userId)}/${Uri.encodeComponent(readOnly.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $PromptScreenRouteExtension on PromptScreenRoute {
  static PromptScreenRoute _fromState(GoRouterState state) => PromptScreenRoute(
        key: state.pathParameters['key']!,
      );

  String get location => GoRouteData.$location(
        '/app/prompt-screen/${Uri.encodeComponent(key)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $HomePageRouteExtension on HomePageRoute {
  static HomePageRoute _fromState(GoRouterState state) => const HomePageRoute();

  String get location => GoRouteData.$location(
        '/web',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $ExportListRouteExtension on ExportListRoute {
  static ExportListRoute _fromState(GoRouterState state) => ExportListRoute(
        userId: state.pathParameters['userId']!,
      );

  String get location => GoRouteData.$location(
        '/web/exports/${Uri.encodeComponent(userId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $ExportViewRouteExtension on ExportViewRoute {
  static ExportViewRoute _fromState(GoRouterState state) =>
      const ExportViewRoute();

  String get location => GoRouteData.$location(
        '/web/export-view',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $SessionInfoRouteExtension on SessionInfoRoute {
  static SessionInfoRoute _fromState(GoRouterState state) =>
      const SessionInfoRoute();

  String get location => GoRouteData.$location(
        '/web/session-info',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $ExerciseHistoryRouteExtension on ExerciseHistoryRoute {
  static ExerciseHistoryRoute _fromState(GoRouterState state) =>
      ExerciseHistoryRoute(
        userId: state.pathParameters['userId']!,
      );

  String get location => GoRouteData.$location(
        '/web/exercise-history/${Uri.encodeComponent(userId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

extension $SettingScreenRouteExtension on SettingScreenRoute {
  static SettingScreenRoute _fromState(GoRouterState state) =>
      const SettingScreenRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}
