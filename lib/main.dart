import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:delivery_app/CommonMethod/CommonColors.dart';
import 'package:delivery_app/Models/LoginModel.dart';
import 'package:delivery_app/Services/Services.dart';
import 'package:delivery_app/View/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

void sendLocationToBackend(Position position) async {
  // TODO: Send the location to the backend.
  var url = Uri.parse('https://cws.in.net/delivery_service/api/Order');
  var response = await http.post(url, body: {
    'flag':'add_lat_long',
    'delivery_boy_id':'6',
    'latitude': position.latitude.toString(),
    'longitude': position.longitude.toString(),
  });

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  // print('Sending location: ${position.latitude}, ${position.longitude}');
}

void initBackgroundFetch() {
//
//   BackgroundLocation.getLocationUpdates((location) {
//     sendLocationToBackend(location);
//     // print(location);
//   });
//
//     // Permission granted, access the user's location
    Geolocator.checkPermission().then((permission)async {
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final currentLocation = await Geolocator.getCurrentPosition();

        // Send the current location to the backend immediately.
        sendLocationToBackend(currentLocation);

        // Set up a timer to send the location to the backend every minute.
        // Timer.periodic(Duration(minutes: 1), (timer) async {
        //   final location = await Geolocator.getCurrentPosition();
        //   sendLocationToBackend(location);
        // });
      }else{

      }
    });
}
// this will be used as notification channel id
const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // bring to foreground
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        initBackgroundFetch();
        flutterLocalNotificationsPlugin.show(
          notificationId,
          'App is running in background',
          'location update ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    }
  });
}


Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        // iOS: IOSInitializationSettings(),
        iOS: DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
        ),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      // auto start service
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'App is running in foreground',
      initialNotificationContent: 'Location update ${DateTime.now()}',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var status = await Permission.location.request();
  if (status == PermissionStatus.granted) {
    await initializeService();

    // initBackgroundFetch();
  } else if (status == PermissionStatus.denied) {
    // Permission denied
  } else if (status == PermissionStatus.permanentlyDenied) {
    // Permission permanently denied, take the user to app settings
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: CommonColors.white
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }

}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();

}


class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  late LoginModel _loginModel;
  bool _isPageLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  late SharedPreferences preferences;
  Future<void> Login() async{

    _isPageLoading = true;
    _loginModel = await Service.LoginCredentials(email.text, password.text);

    if(_loginModel.status == true){
      _isPageLoading = false;
      preferences.setBool("islogin", true);
      preferences.setString("user_id",_loginModel.body?.userId ?? "0");
      preferences.setString("name",_loginModel.body?.name ?? "dummy");
      Fluttertoast.showToast(
          msg: _loginModel.msg.toString(),
          toastLength: Toast.LENGTH_SHORT);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()));
    }else{
      _isPageLoading = false;
      Fluttertoast.showToast(
          msg: _loginModel.msg.toString(),
          toastLength: Toast.LENGTH_SHORT);
      print("objectdjsh"+ _loginModel.msg.toString());
    }
  }


  @override
  void initState() {
    checkLogin();
  }

  void checkLogin()async {
    preferences = await SharedPreferences.getInstance();
    bool islogin = preferences.getBool("islogin") ?? false;
    if(islogin){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()));
    }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    alignment: Alignment.center,
                    child: Image.asset("images/divlivery victor-01 1.png",
                    width: 300,
                      height: 200,
                 ),
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 25.0,
                      // letterSpacing: 5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Card(
                    color: Color(0xfff1f0f6),
                    shadowColor: Colors.black,
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 5.0, left: 10.0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                            labelStyle: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.w400),
                            hintStyle: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.w400),
                          border: InputBorder.none
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                        // style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Card(
                    color: Color(0xfff1f0f6),
                    shadowColor: Colors.black,
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 5.0, left: 10.0),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: password,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            labelStyle: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.w400),
                            hintStyle: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.w400),
                            border: InputBorder.none
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!.trim();
                        },
                        // style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                    child: InkWell(
                      onTap: (){

                      },
                      child: const Text("Forgot Password ?",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff1A78F1)
                        ),
                      ),
                    ) ,
                  ),
                  SizedBox(height: 40.0),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset("images/delivery_login_bg.png",
                          width: 300,
                          height: 200,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.fromLTRB(0, 90.0, 0, 0),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            color: Color(0xff25476A)
                        ),
                        // child: _isPageLoading ? Center(
                        //   child: CircularProgressIndicator(),
                        // ):
                        child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width,
                          height: 50,
                          child: MaterialButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            textColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: _isPageLoading == true ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ):Text('Login', style: TextStyle(fontSize: 18,),),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                Login();
                              }
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

