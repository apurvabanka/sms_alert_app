import 'dart:async';
import 'dart:io';
// import 'dart:html';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:telephony/telephony.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:just_audio/just_audio.dart';

// class PodcastBackgroundTask extends BackgroundAudioTask {
//   AudioPlayer _player = AudioPlayer();
//
//   onPlay() async {
//     _player.play('https://luan.xyz/files/audio/ambient_c_motion.mp3');
//     // Show the media notification, and let all clients no what
//     // playback state and media item to display.
//     await AudioServiceBackground.setState(playing: true);
//     await AudioServiceBackground.setMediaItem(MediaItem(title: "Hey Jude",));
//   } // import 'package:audio_service/audio_service.dart';
// }
  // final AudioPlayer audioPlayer = AudioPlayer();
  // play() async {
  //   audioPlayer.play('https://luan.xyz/files/audio/ambient_c_motion.mp3');
  // }
  //
  // stop() {
  //   print("stoping .....");
  //   audioPlayer.stop();
  // }
// int i=0;
// Future<int> abc() async{
//   while(i==0){
//     if(i==1){
//       break;
//     }
//     else{
//       continue;
//     }
//   }
//
// }
// class ring{
//    static void ringStart() async{
//      FlutterRingtonePlayer f = new FlutterRingtonePlayer();
//     FlutterRingtonePlayer.play(
//       android: AndroidSounds.alarm,
//       ios: IosSounds.glass,
//       looping: true, // Android only - API >= 28
//       volume: 0.1, // Android only - API >= 28
//       asAlarm: false, // Android only - all APIs
//     );
//     await abc();
//   }
//   static void ringStop() async{
//     FlutterRingtonePlayer.stop();
//   }
// }

check()async{
  SharedPreferences prefs1 = await SharedPreferences.getInstance();
  String a = prefs1.getString("alm");
  if(a=="0") {
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 0.9, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
    print("Playing audio");
  }
  if(a=="1"){
    print("Stopping audio");
    FlutterRingtonePlayer.stop();
  }
}
setShared()async{
  SharedPreferences prefs1 = await SharedPreferences.getInstance();
  prefs1.setString("alm", "1");
}
backgrounMessageHandler(SmsMessage message) async{
  Fluttertoast.showToast(
      msg: "The Alarm is about to sound",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0
  );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    var androidInitialize = new AndroidInitializationSettings("launch_background");
    var iOSInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(androidInitialize, iOSInitialize);
    flutterLocalNotificationsPlugin=new  FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    void scheduleAlarm(DateTime scheduledNotificationDateTime) async {
    var androidDetails = new AndroidNotificationDetails("Channel ID", "SMS Alert APP", "APP Alert", sound: RawResourceAndroidNotificationSound('androidsound'),importance: Importance.Max);
    var iOSDetails = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidDetails, iOSDetails);
    await flutterLocalNotificationsPlugin.schedule(0, "SMS Alert APP", "Click Here To Open the App", scheduledNotificationDateTime, platformChannelSpecifics);
  }
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String keyEnt = prefs.getString("key");
  String msg = message.body;
  SharedPreferences prefs1 = await SharedPreferences.getInstance();
  // String a = prefs1.getString("alm");
  if(msg.indexOf(keyEnt)!= -1 ){
    scheduleAlarm(DateTime.now().add(new Duration(seconds: 5)));
    //     FlutterRingtonePlayer.play(
    //   android: AndroidSounds.alarm,
    //   ios: IosSounds.glass,
    //   looping: true, // Android only - API >= 28
    //   volume: 0.9, // Android only - API >= 28
    //   asAlarm: false, // Android only - all APIs
    // );
    prefs1.setString("alm", "0");
    check();
  }
}
// stopAudioService() async{
//   await AudioService.connect();
//   AudioService.stop();
// }

void main(){
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMS Alert App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SMS Alert App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  saveKeyPreference(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("key", key);
  }

  @override
  void initState(){
    super.initState();
    final Telephony telephony = Telephony.instance;
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        // Handle message
        print(message.body);
        Fluttertoast.showToast(
            msg: message.body,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      },
      onBackgroundMessage: backgrounMessageHandler,
      // listenInBackground: false,
    );
    // SmsReceiver receiver = new SmsReceiver();

    // );
  }

  Future notificationSelected(String payload) async{
  }
  final keyEntered = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Padding(
                padding:EdgeInsets.all(20),
                child:Text(
                  "Enter key here",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                )
          ),
            TextField(
              controller: keyEntered,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Keys',
                hintText: 'Type here...'
            )
            ),
            RaisedButton(
                child: Text("SAVE"),
                onPressed: () {
                  saveKeyPreference(keyEntered.text);
                Fluttertoast.showToast(
                      msg: "Key saved",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
              }
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        height: 300.0,
        width: 300.0,
        child: FittedBox(
          child: FloatingActionButton(
              onPressed: () {
                exit(0);
              },
              child: Text(
                  "Stop Alarm",
                  style: TextStyle(
                    fontSize: 8,
                  ),
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}