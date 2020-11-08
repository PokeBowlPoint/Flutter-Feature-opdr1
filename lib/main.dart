import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Portal',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cat Portal'),
        ),
        body: Center(child: CatListView()),
      ),
    );
  }
}

class Cat {
  final String name;
  final String image;
  final String breed;
  final String dob;

  Cat({this.name, this.image, this.breed, this.dob});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      name: json['name'],
      image: json['image'],
      breed: json['breed'],
      dob: json['dob'],
    );
  }
}

class CatListView extends StatelessWidget {

  var data;

  var index;


  Widget build(BuildContext context) {
    return FutureBuilder<List<Cat>>(
      future: _fetchJobs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Cat> data = snapshot.data;
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Cat>> _fetchJobs() async {
    final jobsListAPIUrl =
        'http://hers.hosts1.ma-cloud.nl/catabase/getcats.php';
    final response = await http.get(jobsListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['cats'];
      return jsonResponse.map((job) => new Cat.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].image, data[index].name, data[index].breed, data[index].dob);
        });
  }

  ListTile _tile(String leading, String title, String subtitle, String trailing) => ListTile(
      leading: CircleAvatar(
          backgroundImage: NetworkImage('http://placekitten.com/450/450')
      ),
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      trailing: Text(trailing));
}

