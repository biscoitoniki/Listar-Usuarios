import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<Usuarios> fetchUsuarios() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/users');

  if (response.statusCode == 200) {
    return Usuarios.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Usuarios {
  //final Map<String, dynamic> listaUsuarios;
  final listaUsuarios;

  Usuarios({this.listaUsuarios});

  factory Usuarios.fromJson(var json) {
    return Usuarios(
      listaUsuarios: json,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Usuarios> futureUsuarios;
  var tamanho;

  @override
  void initState() {
    super.initState();
    futureUsuarios = fetchUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<Usuarios>(
            future: futureUsuarios,
            builder: (context, json) {
              if (json.hasData) {

                return ListView.builder(
                  itemCount: json.data.listaUsuarios.length,
                  itemBuilder: (context, index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: FlatButton(
                          color: Colors.red,
                          child: Text(json.data.listaUsuarios[index]["name"],
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(usuario: json.data.listaUsuarios[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ); 
              } else if (json.hasError) {
                return Text("${json.error}");
              }
              return CircularProgressIndicator();
            },

          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final usuario;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.usuario}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("Nome: " + usuario['name'] + "\nUsuario: " + usuario['username'] + "\nEmail: " + usuario['email'])
          )
      )
    );
  }
}