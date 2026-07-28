import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
runApp(
ChangeNotifierProvider(
create: (context) => ThemeProvider(),
child: const StateManagementActivity(),
),
);
}

/// Manages the application's Light and Dark Mode.
class ThemeProvider extends ChangeNotifier {
// The application starts in Light Mode.
ThemeMode _themeMode = ThemeMode.light;

/// Returns the currently selected theme.
ThemeMode get themeMode => _themeMode;

/// Checks whether Dark Mode is enabled.
bool get isDarkMode => _themeMode == ThemeMode.dark;

/// Changes the application theme.
void toggleTheme(bool isDarkMode) {
if (isDarkMode) {
_themeMode = ThemeMode.dark;
} else {
_themeMode = ThemeMode.light;
}


// Updates all widgets listening to ThemeProvider.
notifyListeners();

}
}

/// The root widget of the application.
class StateManagementActivity extends StatelessWidget {
const StateManagementActivity({super.key});

@override
Widget build(BuildContext context) {
// Listens to the current theme from ThemeProvider.
final themeProvider = Provider.of<ThemeProvider>(context);

return MaterialApp(
  // Removes the red DEBUG banner.
  debugShowCheckedModeBanner: false,

  // Sets the application title.
  title: 'State Management Activity',

  // Uses Flutter's default Light Mode theme.
  theme: ThemeData.light(),

  // Uses Flutter's default Dark Mode theme.
  darkTheme: ThemeData.dark(),

  // Applies the selected theme.
  themeMode: themeProvider.themeMode,

  // The Counter Screen is the application's home screen.
  home: const CounterScreen(),
);

}
}

/// CounterScreen demonstrates Ephemeral State.
class CounterScreen extends StatefulWidget {
const CounterScreen({super.key});

@override
State<CounterScreen> createState() => _CounterScreenState();
}

/// Stores and manages the local counter value.
class _CounterScreenState extends State<CounterScreen> {
// The counter starts at zero.
int _counter = 0;

/// Increases the counter value by one.

void _incrementCounter() {
setState(() {
_counter++;
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
// Displays the Counter Screen title and Settings button.
appBar: AppBar(
title: const Text('Ephemeral State'),

    // Places the Settings icon on the top-right.
    actions: [
      IconButton(
        icon: const Icon(Icons.settings),

        // Opens the separate Theme Screen.
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ThemeScreen(),
            ),
          );
        },

        tooltip: 'Theme Settings',
      ),
    ],
  ),

  // Displays the counter.
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'You have pushed the button this many times:',
        ),

        // Displays the current counter value.
        Text(
          '$_counter',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium,
        ),
      ],
    ),
  ),

  // Increases the counter when pressed.
  floatingActionButton: FloatingActionButton(
    onPressed: _incrementCounter,
    tooltip: 'Increment',
    child: const Icon(Icons.add),
  ),
);

}
}

/// ThemeScreen demonstrates App State using Provider.
class ThemeScreen extends StatelessWidget {
const ThemeScreen({super.key});

@override
Widget build(BuildContext context) {
// Listens to ThemeProvider for theme changes.
final themeProvider = Provider.of<ThemeProvider>(context);

return Scaffold(
  // Displays the Theme Screen title.
  appBar: AppBar(
    title: const Text('Theme Settings'),
  ),

  // Displays the Light/Dark Mode switch.
  body: Center(
    child: SwitchListTile(
      title: const Text('Dark Mode'),

      subtitle: Text(
        themeProvider.isDarkMode
            ? 'Dark Mode is enabled'
            : 'Light Mode is enabled',
      ),

      // Shows whether Dark Mode is enabled.
      value: themeProvider.isDarkMode,

      // Changes the theme when the switch is pressed.
      onChanged: themeProvider.toggleTheme,
    ),
  ),
);

}
}
