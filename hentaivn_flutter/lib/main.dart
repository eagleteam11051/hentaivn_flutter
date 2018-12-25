import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'HentaiVN'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    var data = await http
        .get("https://trolyao.rao.vn/hentaivn/gettheloai.php?linkTheLoai=https://hentaivn.net/the-loai-133-big_ass.html");

    var jsonData = json.decode(data.body);
    List<User> users = [];

    for (var u in jsonData) {
      // ignore: not_enough_required_arguments
      User user =
          User( u["title"], u["img"], u["theLoai"], u["luotXem"], u["link"]);
      users.add(user);
    }

    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading"),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data[index].img),

                      ),
                      title: Text(snapshot.data[index].title),
                      subtitle: Text(snapshot.data[index].luotXem),
                      onTap: () {

                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(snapshot.data[index])));
                      },
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}

class DetailPage extends StatelessWidget {
  final User user;
  DetailPage(this.user);


  Future<List<Chap>> _getChap() async {
    var linktruyen = user.link;
    var data = await http
        .get("https://trolyao.rao.vn/hentaivn/getchap.php?url=$linktruyen");

    var jsonData = json.decode(data.body);
    List<Chap> chaps = [];

    for (var u in jsonData) {
      // ignore: not_enough_required_arguments
      Chap chap =
      Chap( u["chapter"], u["time"], u["link"]);
      chaps.add(chap);
    }
    print(user.link);
    print(chaps.length);
    return chaps;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(
          title: Text(user.title),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getChap(),
            builder: (BuildContext context, AsyncSnapshot snapshot1) {
              if (snapshot1.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading"),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot1.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(

                      title: Text(snapshot1.data[index].chapter),

                    );
                  },
                );
              }
            },
          ),
        ));
  }
}

class User {
  final String title;
  final String img;
  final String theloai;
  final String luotXem;
  final String link;

  User( this.title, this.img, this.theloai,this.luotXem, this.link);
}
class Chap {
  final String chapter;
  final String time;
  final String link;

  Chap( this.chapter, this.time, this.link);
}
