import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackizer/backend/auth/login.dart';
import 'package:trackizer/backend/auth/signup.dart';
import 'package:trackizer/backend/settings/settings.dart';
import 'package:trackizer/common/color_extension.dart';
import 'package:trackizer/firebase_options.dart';
import 'package:trackizer/view/group/group_add.dart';
import 'package:trackizer/view/home/home_view.dart';
import 'package:trackizer/view/login/sign_in_view.dart';
import 'package:trackizer/view/login/user_info.dart';
import 'package:trackizer/view/login/welcome_view.dart';
import 'package:trackizer/view/main_tab/main_tab_view.dart';
import 'package:trackizer/view/pdfupload/pdfupload.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignupAuthorization()),
        ChangeNotifierProvider(create: (context) => LoginAuthorization()),
        ChangeNotifierProvider(create: (context) => UserSettings()),
      ],
      child: MaterialApp(
        title: 'Moni-Moni',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Inter",
          colorScheme: ColorScheme.fromSeed(
            seedColor: TColor.primary,
            background: TColor.gray80,
            primary: TColor.primary,
            primaryContainer: TColor.gray60,
            secondary: TColor.secondary,
          ),
          useMaterial3: false,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnp) {
            if (userSnp.hasData) {
              return const MainTabView();
            }
            return const WelcomeView();
          },
        ),
      ),
    );
  }
}
