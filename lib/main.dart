import 'package:biketheft_berlin/controller/app_theme_controller.dart';
import 'package:biketheft_berlin/screens/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'general_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('csvBox');
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        // override the previous value with the new object
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: Homepage(),
    ),
  );
}

class Homepage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _appThemeState = watch(appThemeControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context
          .read(appThemeProvider)
          .getAppThemedata(context, _appThemeState),
      home: MapScreen(),
    );
  }
}
