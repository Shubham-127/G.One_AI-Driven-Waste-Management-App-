import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/report/report_bloc.dart';
import 'repositories/report_repository.dart';
import 'screens/login_page.dart';
import 'screens/dashboard_page.dart';
import 'screens/report_page.dart';
import 'screens/schedule_page.dart';
import 'screens/nearest_centers_page.dart';
import 'screens/scanner_page.dart';
import 'screens/profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ReportRepository reportRepository = ReportRepository();

  @override
  Widget build(BuildContext context) {
    final lightGreen = Color(0xFFE8F6EF);
    final primaryGreen = Color(0xFF1F8F5A);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<ReportBloc>(create: (_) => ReportBloc(reportRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'G.One',
        theme: ThemeData(
          scaffoldBackgroundColor: lightGreen,
          primaryColor: primaryGreen,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: primaryGreen,
            secondary: Color(0xFF3FA56A),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black87),
            elevation: 0,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (_) => LoginPage(),
          DashboardPage.routeName: (_) => DashboardPage(),
          ReportPage.routeName: (_) => ReportPage(),
          SchedulePage.routeName: (_) => const SchedulePage(),
          NearestCentersPage.routeName: (context) => const NearestCentersPage(),
          ScannerPage.routeName: (context) => const ScannerPage(),
          ProfilePage.routeName: (context) => ProfilePage(),
        },
      ),
    );
  }
}
