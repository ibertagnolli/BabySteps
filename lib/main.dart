import 'package:babysteps/app/pages/notes/notes.dart';
import 'package:babysteps/app/pages/tracking/tracking.dart';
import 'package:flutter/material.dart';
import 'package:babysteps/theme.dart';
import 'package:babysteps/app/pages/home/home.dart';
import 'package:babysteps/app/pages/social/social.dart';
import 'package:babysteps/app/pages/calendar/calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//TODO: add navigation to this page from any page.
//This next line allows me to run the calendar page as main since we don't have the navigation to the calendar page setup yet.
// void main() => runApp(const CalendarPage());


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
    return MaterialApp(
      title: 'BabySteps',
      theme: ThemeData(
        colorScheme: BabyStepsTheme().themedata.colorScheme,
        fontFamily: 'Georgia',
        //scaffoldBackgroundColor: const Color(0xffb3beb6),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BabySteps'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentTab = TabItem.home;
  final navigatorKey = GlobalKey<NavigatorState>();

  void _selectTab(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(tabName[_currentTab].toString()),
      ),
      bottomNavigationBar: BottomNavigation(
        currentTab: _currentTab,
        onSelectTab: _selectTab,
      ),
      body: tabPage[_currentTab],
    );
  }
}

//These aren't currently being used, beginings of making sure we can navigate to the subpages and still see navigation
class TabNavigatorRoutes {
  static const String routeHome = '/';
  static const String routeTracking = '/tracking';
  static const String routeFeeding = '/tracking/feeding';
  static const String routeBreastfeeding = '/tracking/feeding/breastfeeding';
  static const String routeBottle = '/tracking/feeding/bottle';
  static const String routeSleep = '/tracking/sleep';
  static const String routeDiaper = '/tracking/diaper';
  static const String routeWeight = '/tracking/weight';
  static const String routeTemperature = '/tracking/temperature';
  static const String routeCalendar = '/calendar';
  static const String routeNotes = '/notes';
  static const String routeSocial = '/social';
}

/*The following items are for dynamic tab setup*/

//Enum listing each available tab in the app
enum TabItem { home, tracking, calendar, notes, social }

//Maps each TabItem to it's string name to display under the icon
//and on the app bar.
const Map<TabItem, String> tabName = {
  TabItem.home: 'Home',
  TabItem.tracking: 'Tracking',
  TabItem.calendar: 'Calendar',
  TabItem.notes: 'Notes',
  TabItem.social: 'Social',
};

//Maps each TabItem to it's icon
const Map<TabItem, Icon> tabIcon = {
  TabItem.home: Icon(Icons.home),
  TabItem.tracking: Icon(Icons.folder),
  TabItem.calendar: Icon(Icons.calendar_month),
  TabItem.notes: Icon(Icons.note),
  TabItem.social: Icon(Icons.people),
};

//Maps each tab item to the actual page it displays
Map<TabItem, Widget> tabPage = {
  TabItem.home: const HomePage(),
  TabItem.tracking: const TrackingPage(),
  TabItem.calendar: const CalendarPage(),
  TabItem.notes: const NotesPage(),
  TabItem.social: const SocialPage(),
};

//This widget builds the navigation bar using the enum for the different tab items
//It's own widget to make the code above less messy and readable
class BottomNavigation extends StatelessWidget {
  const BottomNavigation(
      {required this.currentTab, required this.onSelectTab, super.key});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      indicatorColor: Theme.of(context).colorScheme.primary,
      destinations: [
        _buildItem(TabItem.home),
        _buildItem(TabItem.tracking),
        _buildItem(TabItem.calendar),
        _buildItem(TabItem.notes),
        _buildItem(TabItem.social)
      ],
      onDestinationSelected: (index) => onSelectTab(
        TabItem.values[index],
      ),
      selectedIndex: TabItem.values.indexOf(currentTab),
    );
  }

  //Helper to build the widget with its icon and label
  NavigationDestination _buildItem(TabItem tabItem) {
    return NavigationDestination(
      icon: tabIcon[tabItem]!,
      label: tabName[tabItem]!,
    );
  }
}
