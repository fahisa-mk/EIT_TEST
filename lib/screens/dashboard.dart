import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> users = [];
  int page = 1;
  bool isLoading = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    isLoading = true;
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=$page&per_page=10'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (page == 1) {
        setState(() {
          users = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          users.addAll(data['data']);
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        page++;
      });
      fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = users[index];
                  return ListTile(
                    title: Text('${user['first_name']} ${user['last_name']}'),
                    subtitle: Text(user['email']),
                  );
                },
              ),
      ),
    );
  }
}
