import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamer_gram/pages/home_page.dart';
import 'package:gamer_gram/pages/login_screen.dart';
import 'package:gamer_gram/pages/web_page.dart';
import 'package:gamer_gram/providers/user_provider.dart';
import 'package:gamer_gram/util/colors.dart';
import 'package:gamer_gram/widget/responsive_widget.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCkpMT9CRFSAPEdCCv40H1O-B8cxm-AcMo",
        appId: "1:67291339722:web:d3e57428f81334bb45cd33",
        messagingSenderId: "67291339722",
        projectId: "gamergram-a6724",
        storageBucket: "gamergram-a6724.appspot.com",
      ),
    );
    runApp(const MyApp());
  } else {
    await Firebase.initializeApp();
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'GG',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        //home: ResponsiveWidget(mobileScreenLayout: HomePage(),webScreenLayout: WebScreen(),),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveWidget(
                    webScreenLayout: WebScreen(), mobileScreenLayout: HomePage());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error})"),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

