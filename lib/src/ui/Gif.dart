import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Gif extends StatelessWidget {

    String src;
    String title;

    Gif(String src, String title){
        this.src = src;
        this.title = title;
        print(this.title);
        print(this.src);
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Color(0xff090909),
                title: Text(this.title),
                centerTitle: true,
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                            Share.share(this.src);
                        },
                    )
                ],
            ),
            backgroundColor: Colors.black12,
            body: Center(
                child: Image.network(this.src),
            ),
        );
    }
}