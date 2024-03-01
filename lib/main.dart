import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'package:provider/provider.dart';
import 'package:zhilki/firebase_options.dart';
import 'package:zhilki/first/onboarding.dart';
import 'package:zhilki/providers/declare.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zhilki/main%20page/navigation.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(); //initilization of Firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  User? user = FirebaseAuth.instance.currentUser ;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Zhilki', debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true ,
        ),
        home : FutureBuilder(
            future: Future.delayed(Duration(seconds: 3)),
            builder: (ctx, timer) =>
            timer.connectionState == ConnectionState.done
                ? ( user == null ? TestScreen() : Home() ) //Screen to navigate to once the splashScreen is done.
                : Container(
              color: Colors.white ,
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: AssetImage('assets/in.png'),
              ),
            ),
        ),
      ),
    );
  }
}
