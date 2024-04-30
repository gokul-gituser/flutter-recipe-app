import 'package:flutter/material.dart';
import 'package:recipe_app/services/auth_service.dart';
import 'package:status_alert/status_alert.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _loginFormKey = GlobalKey();
  String? username, password;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: SafeArea(child: _buildUI()),
    );
  }
  Widget _buildUI(){
    return SizedBox(
            width: MediaQuery.sizeOf(context).width,

      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _title(),
          _loginForm(),
        ],
      ),
    );
  }

  Widget _title(){
    return const Text("Recipe Book",
    style: TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.w300
    ),);
  }
  Widget _loginForm(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.90,
      height: MediaQuery.sizeOf(context).height * 0.30,
      child: Form(
        key: _loginFormKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              onSaved: (value){
                setState(() {
                  username = value;
                });
              },
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Enter a Username ";
                }
              }
              ,
              decoration: InputDecoration(hintText: "Username"),
            ),
            TextFormField(
              obscureText: true,
              onSaved: (value){
                setState(() {
                  password = value;
                });
              },
              validator: (value){
                if(value == null || value.length <5){
                  return "Enter a Valid Password ";
                }
              },
              decoration: InputDecoration(hintText: "Password"),
            ),
            _loginButton()
          ],
        )
      ),
    );
  }

  Widget _loginButton(){
    return SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.60,
            child: ElevatedButton(onPressed: () async {
              if (_loginFormKey.currentState?.validate() ?? 
              false){
                  _loginFormKey.currentState?.save();
                  bool result = await AuthService().login(username!,password!);
                  if(result){
                    Navigator.pushReplacementNamed(context, '/home');

                  }else{
                    StatusAlert.show(context,
                    duration: const Duration(seconds: 2),
                    title: 'Login Failed',
                    subtitle: "Please try again",
                    configuration: const IconConfiguration(
                      icon: Icons.error,
                    ),
                    maxWidth: 260
                    );
                  }
              }
            },
            child: const Text(
              "Login"
            ) ,)

    );
  }
}