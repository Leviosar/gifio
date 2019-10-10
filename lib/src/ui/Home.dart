import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gifio/src/ui/Gif.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    String _apiKey = '8JDwzYlHUFJD28kksMyiY4C9wMJcftI5';
    String _search;
    int _page = 0;
    int _limit = 25;
    Map gifs;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Color(0xff090909),
                title: Image.network('https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif'),
                centerTitle: true,
            ),
            backgroundColor: Colors.black12,
            body: Column(
                children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextField(
                            decoration: InputDecoration(
                                labelText: "Search",
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder()
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                            textAlign: TextAlign.center,
                            onSubmitted: (text) {
                                setState(() {
                                    this._search = text;
                                    this._page = 0;
                                });
                            },
                        )
                    ),
                    Expanded(
                        child: FutureBuilder(
                            future: this._getGifs(),
                            builder: (context, snapshot) {
                                switch(snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                        return Container(
                                            width: 200.0,
                                            height: 200.0,
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                strokeWidth: 5.0,
                                            ),
                                        );
                                    default:
                                        if (snapshot.hasError) {
                                            return Container();
                                        } else {
                                            return this._createGrid(context, snapshot);
                                        }
                                }
                            }
                        ),
                    )
                ],
            ),
        );
    }

    @override
    void initState() {
        super.initState();

        this._getGifs().then(
            (map) {
                this.gifs = map;
            }
        );
    }

    int _paginate(List data) {
        if (this._search == null) {
            return data.length;
        } else {
            return data.length + 1;
        }
    }

    Future<Map> _getGifs() async {
        http.Response response;

        if (this._search == null) {
            response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=${this._apiKey}&limit=${this._limit}&rating=R');
        } else {
            response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=${this._apiKey}&q=${this._search}&limit=${this._limit}&offset=${this._limit * this._page}&rating=R&lang=en');
        }

        return json.decode(response.body);
    }

    Widget _createGrid(BuildContext context, AsyncSnapshot snapshot) {
        return GridView.builder(
            padding: EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0
            ),
            itemCount: this._paginate(snapshot.data["data"]),
            itemBuilder: (BuildContext context, int index) {
                if (this._search == null || index < snapshot.data["data"].length) {
                    return GestureDetector(
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                            height: 300.0,
                            fit: BoxFit.cover,
                        ),
                        onTap: (){
                            print(snapshot.data["data"][index] is String);
                            Navigator.push(
                                context, 
                                MaterialPageRoute(
                                    builder: (context) {
                                        return  Gif(snapshot.data["data"][index]["images"]["fixed_height"]["url"], snapshot.data["data"][index]["title"]);
                                    }
                                )
                            );
                        },
                    );
                } else {
                    return Container(
                        child: GestureDetector(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    Icon(Icons.add, color: Colors.white, size: 70.0),
                                    Text("Load more!", style: TextStyle(color: Colors.white, fontSize: 24.0),)
                                ],
                            ),
                            onTap: () {
                                setState(() {
                                    this._page++;
                                });
                            },
                            onLongPress: () { Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]); },
                        )
                    );
                }
            },
        );
    }
}