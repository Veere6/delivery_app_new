import 'package:delivery_app/CommonMethod/CommonColors.dart';
import 'package:delivery_app/Models/LoginModel.dart';
import 'package:delivery_app/Services/Services.dart';
import 'package:delivery_app/View/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
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
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> Login() async{
    _loginModel = await Service.LoginCredentials(email.text, password.text);

    if(_loginModel.status == true){
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomePage()));
    }else{
      print("objectdjsh"+ _loginModel.msg.toString());
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                Login();
                              }
                            },
                            textColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Login', style: TextStyle(fontSize: 18,),),
                            ),
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

