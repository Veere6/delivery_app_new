import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundService{

  static void sendLocationToBackend(Position position, userID) async {
    // TODO: Send the location to the backend.
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String uId = preferences.getString("user_id") ?? "3";
    var url = Uri.parse('http://netra.161cloud.in/api/ulocation?delivery_admin=$userID');
    var response = await http.post(url, headers: {
      'Authorization': "Bearer testdd",
      'Content-Type': 'application/json'
    }, body: jsonEncode({
      'l1': position.latitude.toString(),
      'l2': position.longitude.toString(),
    }) );
    print(response.request);
    print('latitude: ${position.latitude.toString()}');
    print('longitude: ${position.longitude.toString()}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    // print('Sending location: ${position.latitude}, ${position.longitude}');
  }

  static void initBackgroundFetch(userId) {
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
        print(currentLocation);
        // Send the current location to the backend immediately.
        sendLocationToBackend(currentLocation,userId);
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
  static const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
  static const notificationId = 888;

 static Future<void> onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // bring to foreground

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.reload();
          String userID= preferences.getString("user_id") ?? "null";
           if(userID!="null") {
             print("USER ID : ${userID}");
             initBackgroundFetch(userID);
           }
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


 static Future<void> initializeService() async {

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

  }

 static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    // await preferences.reload();
    final log = preferences.getStringList('log') ?? <String>[];
    log.add(DateTime.now().toIso8601String());
    await preferences.setStringList('log', log);

    return true;
  }

  static Future<void> stopService() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    } else {
      print("Background service is not running.");
    }
  }
  static Future<void> startService() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (!isRunning) {
      await service.startService();
    } else {
      print("Background service is not running.");
    }
  }

}