import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';





void main() async{
  await dotenv.load();
  runApp(MyApp());
}

Future<bool>_checkLogin() async {
  print(' it is checklogin');
  final LocalStorage storage = LocalStorage('token');
  await storage.ready;
  final something = await storage.getItem('token');
  print(something);
  if (something==null) {
    print('is null');
    return false;
  } else {
    print('not null');
    return true;
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);  
  
//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(
//       title: 'Login Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: _checkLogin() ?  isLoggedin() : LoginPage2()
//       // home: LoginPage2()
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool arinloggad = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _checkLogin().then((value) => arinloggad = value);
    _checkLogin().then((value) {
      arinloggad = value;
      setState(() {
        
      });
    });
    
    
  }
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: arinloggad ?  isLoggedin() : LoginPage2()
      // home: LoginPage2()
    );
  }
}

class LoginPage2 extends StatefulWidget {
  const LoginPage2({Key? key}) : super(key: key);
  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  
  // final LocalStorage storage = LocalStorage('token');
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  

  var _token;
  var _username;

  void _getText (value){
    setState(() {
      _username = value;  
    }); 
  }

  void _saveToStorage(value) {    
    final LocalStorage storage = LocalStorage('token');
    print('token => ${jsonDecode(value)}');
    storage.setItem('token', value);
    print('token is saved');
    print(storage.getItem('token'));
  }
  Future<String?> attemptLogIn(String username, String password) async {
    var res = await http.post(
      // "http://${dotenv.env['API_URL']}/api/user/loginUser",
      'http://localhost:4000/api/user/loginUser',
      body: {
        "username": username,
        "password": password
      }
    );
    // var responseFromSever = jsonDecode(res.body);
    // if(res.statusCode == 200) return res.body; 
    if(res.statusCode == 200) return res.body; 
    return null;
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: Text("Log In"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username'
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password'
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var username = _usernameController.text;
                var password = _passwordController.text;
                var jwt = await attemptLogIn(username, password);
                if (jwt!= null) {
                _getText(username);
                _saveToStorage(jwt);
                }
              },
              child: Text("login")
            ),
          ],
        ),
      )
    ); 
  }
}

class isLoggedin extends StatelessWidget {
  const isLoggedin({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Text('already logged in');
  }
}
