import 'dart:async';
import 'dart:ui';
import 'package:delivery_app/CommonMethod/BgService.dart';
import 'package:delivery_app/CommonMethod/CommonColors.dart';
import 'package:delivery_app/Models/LoginModel.dart';
import 'package:delivery_app/Services/Services.dart';
import 'package:delivery_app/View/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void ServiceCall()async{
  var status = await Permission.location.request();
  if (status == PermissionStatus.granted) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uId = preferences.getString("user_id") ?? "";
    BackgroundService.initializeService();
    if(uId!=""){
      BackgroundService.startService();
    }
    // initBackgroundFetch();
  } else if (status == PermissionStatus.denied) {
    // Permission denied
  } else if (status == PermissionStatus.permanentlyDenied) {
    // Permission permanently denied, take the user to app settings
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceCall();
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

    if(_loginModel.roles != null){
      _isPageLoading = false;
      preferences.setBool("islogin", true);
      preferences.setString("user_id",_loginModel.id.toString() ?? "0");
      preferences.setString("name",_loginModel.name ?? "dummy");
      Fluttertoast.showToast(
          msg: "Login successfully",
          toastLength: Toast.LENGTH_SHORT);
      BackgroundService.startService();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()));
    }else{
      _isPageLoading = false;
      Fluttertoast.showToast(
          msg: "Login failed",
          toastLength: Toast.LENGTH_SHORT);
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

