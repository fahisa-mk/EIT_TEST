import 'dart:convert';
import 'package:eit_test/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
bool _obscureText = true;
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      Uri.parse('https://reqres.in/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // login successful
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // login failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid email or password'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome..!!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40
              )),
              SizedBox(height: 25),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 25.0),
               child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email'
                    ),
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
               
                  ),
                ),
                
               ),
             ),
             SizedBox(height: 5),
                Padding(
               padding: const EdgeInsets.symmetric(horizontal: 25.0),
               child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: TextFormField(
                    controller: _passwordController,
                   obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      suffixIcon: IconButton( icon: Icon(_obscureText? Icons.visibility: Icons.visibility_off),
                      onPressed:  _toggleObscureText,
                      )
                    ),
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                
                    ),
                  ),
                ),
                ),
                SizedBox(height: 10),
                
                Padding(padding: EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Center(
                    child:TextButton(onPressed: () { },
                    child: Text('Submit',style: TextStyle(
                      color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16
                    ),),)
                  ),
                ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member ? ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () { Navigator.push(
                      context, MaterialPageRoute(builder: (context) => RegisterPage()),
    ); },
                      child: Text('Register now',
                    style: TextStyle(
                      color: Colors.blue,fontWeight: FontWeight.bold
                    ), )),
                    
                  ],
                )
             ]), 

            
      )));

}}