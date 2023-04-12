
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDetailsPage extends StatefulWidget {
  final int id;

  UserDetailsPage({required this.id});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  dynamic _user;
  bool _isLoading = false;

  void _loadUser() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.get(
      Uri.parse('https://reqres.in/api/users/${widget.id}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _user = data['data'];
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load user'),
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

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: _isLoading || _user == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(_user['avatar']),
                    radius: 80.0,
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    '${_user['first_name']} ${_user['last_name']}',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _user['email'],
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              ),
);
  }}