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
      title: 'Flutter feature - opdracht 1',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter feature - opdracht 1'),
          backgroundColor: Colors.grey,
        ),
        body: Center(child: CatsListView()),
      ),
    );
  }
}

class Cats {
  final String name;
  final String image;
  final String breed;
  final String dob;

  Cats({this.name,
    this.image,
    this.breed,
    this.dob});

  factory Cats.fromJson(Map<String, dynamic> json) {
    return Cats(
      name: json['name'],
      image: json['image'],
      breed: json['breed'],
      dob: json['dob'],
    );
  }
}

class CatsListView extends StatelessWidget {

  var data;

  var index;


  Widget build(BuildContext context) {
    return FutureBuilder<List<Cats>>(
      future: _fetchCats(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Cats> data = snapshot.data;
          return _catsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return LinearProgressIndicator();
      },
    );
  }

  Future<List<Cats>> _fetchCats() async {
    final catsApi =
        'http://hers.hosts1.ma-cloud.nl/catabase/getcats.php';
    final response = await http.get(catsApi);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['cats'];
      return jsonResponse.map((cats) => new Cats.fromJson(cats)).toList();
    } else {
      throw Exception('Kon geen cats uit API laden');
    }
  }

  ListView _catsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile( data[index].image,
              data[index].name,
              data[index].breed,
              data[index].dob);
        });
  }

  ListTile _tile(String leading, String title, String subtitle, String trailing) => ListTile(
      leading: CircleAvatar(
          backgroundImage: NetworkImage('http://placekitten.com/450/450')
      ),
      title: Text(title,
          style: TextStyle(
            fontSize: 20,
          )),
      subtitle: Text(subtitle,
          style: TextStyle(
            fontSize: 18,
          )),
      trailing: Text(trailing,
        style: TextStyle(
          fontSize: 18,
        ),));
}

