import 'package:calendar_sample/service/event_db.dart';
import 'package:calendar_sample/view/calendar_view.dart';
import 'package:calendar_sample/view/schedule_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late MyDatabase dataBase;

void main() {
  dataBase = MyDatabase();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
      ],
      locale: const Locale('ja'),
      title: 'Calendar Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const CalendarView(),
      routes: {
        '/': (context) => const CalendarView(),
        'schedule': (context) => const ScheduleDetail(),
      },
    );
  }
}
