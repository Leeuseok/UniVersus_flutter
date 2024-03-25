import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universus/auth/AdditionalInfo_Widget.dart';

import 'package:universus/class/user/user.dart';

// Widget Import
import 'package:universus/auth/Login_Widget.dart';
import 'package:universus/component/MainPage.dart';
import 'package:universus/auth/CreateAccount_Widget.dart';
import 'package:universus/auth/PasswordForget_Widget.dart';
import 'package:universus/test/testscreen_Widget.dart';
import 'package:universus/auth/KakaoLogin.dart';
import 'package:universus/moim/placepicker.dart';
import 'package:universus/moim/jungmo/CreateJungmoWidget.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 1번코드
  KakaoSdk.init(
      nativeAppKey: 'c42d4f7154f511f29ae715dc77565878',
      javaScriptAppKey: '240cc5ab531ff61f42c8e0a1723a4f96');
  await dotenv.load(fileName: ".env"); // 2번코드
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _loginInfo;

  @override
  void initState() {
    super.initState();
    _loginInfo = checkLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder(
              future: _loginInfo,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                } else {
                  if (snapshot.data == true) {
                    return MainPage();
                  } else {
                    return LoginWidget();
                  }
                }
              },
            ),
        '/main': (context) => TestscreenWidget(),
        '/login': (context) => LoginWidget(),
        '/register': (context) => CreateAccountWidget(),
        '/passwordforgot': (context) => PasswordForgetWidget(),
        '/testscreen': (context) => TestscreenWidget(),
        '/testplacepicker': (context) => new PlacePickerScreen(),
        '/moim/createjungmo': (context) => CreatejungmoWidget(),
        '/addinfo': (context) => AdditionalInfoWidget(
              emailData: {'email': '1231231', 'university': 'asdfasdfasdf'},
            ), // 테스트 용도
      },
    );
  }

  Future<bool> checkLoginInfo() async {
    // 유저 정보 확인 메서드
    await Future.delayed(Duration(seconds: 3)); // Show logo for 3 seconds
    UserData? user = await UserData.getUser();
    return user != null;
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoSize = 0.0;

  @override
  void initState() {
    super.initState();
    _animateLogo();
  }

  void _animateLogo() {
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _logoSize = 250;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(seconds: 2),
              curve: Curves.easeOutCubic,
              width: _logoSize,
              height: _logoSize,
              child: Image.asset('images/logo.png'),
            ),
            SizedBox(height: 20),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text('나의 모임을 만나는 앱',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
