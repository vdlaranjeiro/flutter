import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Users List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> users = [];

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        users = jsonResponse;
      });
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
    }
  }
  
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            color: index.isEven ? Colors.white : const Color.fromARGB(40, 208, 250, 255),
            child: ListTile(
              title: Text(
                user['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('username: ${user['username']}'),
                      Text('email: ${user['email']}'),
                      Text('phone: ${user['phone']}'),
                      Text('website: ${user['website']}'),
                    ]
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Address', style: TextStyle(fontWeight: FontWeight.w600),),
                      Text('${user['address']['street']}, ${user['address']['suite']} - ${user['address']['city']}'),
                      Text('zipcode: ${user['address']['zipcode']}'),
                      Text('geo: ${user['address']['geo']['lat']}, ${user['address']['geo']['lng']}'),
                    ]
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Company', style: TextStyle(fontWeight: FontWeight.w600),),
                      Text('${user['company']['name']}'),
                      Text('${user['company']['catchPhrase']}'),
                      Text('${user['company']['bs']}'),
                    ],
                  )
                ],
              ),
            )
          );
        }), 
    );
  }
}
