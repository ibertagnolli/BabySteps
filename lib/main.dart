import 'package:babysteps/app/pages/notes/notes.dart';
import 'package:babysteps/app/pages/tracking/diaper.dart';
import 'package:babysteps/app/pages/tracking/feeding/bottleFeeding.dart';
import 'package:babysteps/app/pages/tracking/feeding/breastFeeding.dart';
import 'package:babysteps/app/pages/tracking/feeding/feeding.dart';
import 'package:babysteps/app/pages/tracking/sleep.dart';
import 'package:babysteps/app/pages/tracking/temperature.dart';
import 'package:babysteps/app/pages/tracking/tracking.dart';
import 'package:babysteps/app/pages/tracking/weight/weight.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/theme.dart';
import 'package:babysteps/app/pages/home/home.dart';
import 'package:babysteps/app/pages/social/social.dart';
import 'package:babysteps/app/pages/calendar/calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';

//Code for routing (most of this page) taken and adjusted from this tutorial and this github:
//https://codewithandrea.com/articles/flutter-bottom-navigation-bar-nested-routes-gorouter/
//https://github.com/bizz84/nested_navigation_examples/blob/main/examples/gorouter/lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      title: 'BabySteps',
      theme: ThemeData(
        colorScheme: BabyStepsTheme().themedata.colorScheme,
        fontFamily: 'Georgia',
        //scaffoldBackgroundColor: const Color(0xffb3beb6),
        useMaterial3: true,
      ),
    );
  }
}

// Stateful nested navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        indicatorColor: Theme.of(context).colorScheme.primary,
        destinations: const [
          NavigationDestination(label: 'Home', icon: Icon(Icons.home)),
          NavigationDestination(label: 'Tracking', icon: Icon(Icons.folder)),
          NavigationDestination(
              label: 'Calendar', icon: Icon(Icons.calendar_month)),
          NavigationDestination(label: 'Notes', icon: Icon(Icons.note)),
          NavigationDestination(label: 'Social', icon: Icon(Icons.people)),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorTrackingKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellTracking');
final _shellNavigatorCalendarKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellCalendar');
final _shellNavigatorNotesKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellNotes');
final _shellNavigatorSocialKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSocial');

// the one and only GoRouter instance
final goRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: [
    // Stateful nested navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // the UI shell
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        // first branch (Home)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => NoTransitionPage(
                  child: HomePage() //(label: 'A', detailsPath: '/a/details'),
                  ),
            ),
          ],
        ),
        // second branch (Tracking)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorTrackingKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/tracking',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: TrackingPage()),
              routes: [
                // feeding routes
                GoRoute(
                  path: 'feeding',
                  builder: (context, state) => const FeedingPage(),
                  routes: [
                    GoRoute(
                        path: 'breastFeeding',
                        builder: (context, state) => const BreastFeedingPage()),
                    GoRoute(
                        path: 'bottleFeeding',
                        builder: (context, state) => const BottleFeedingPage()),
                  ],
                ),
                GoRoute(
                  path: 'sleep',
                  builder: (context, state) => const SleepPage(),
                ),
                GoRoute(
                  path: 'diaper',
                  builder: (context, state) => const DiaperPage(),
                ),
                GoRoute(
                  path: 'weight',
                  builder: (context, state) => const WeightPage(),
                ),
                GoRoute(
                  path: 'temperature',
                  builder: (context, state) => const TemperaturePage(),
                ),
              ],
            ),
          ],
        ),
        // third branch (Calendar)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCalendarKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/calendar',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: CalendarPage()),
            ),
          ],
        ),
        // fourth branch (Notes)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorNotesKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/notes',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: NotesPage()),
            ),
          ],
        ),
        // fifth branch (Social)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSocialKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/social',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SocialPage()),
            ),
          ],
        ),
      ],
    ),
  ],
);
