import 'package:dishonest_app/domain/Lie.dart';
import 'package:dishonest_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateLieScreen extends StatelessWidget {
  static const String id = "create_screen";

  final formKey = GlobalKey<FormState>();

  final Lie data = Lie("nre", "", "", "", LieSeverity.normal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, CreateLieScreen.id),
            child: Icon(Icons.account_circle, color: Colors.white)),
        appBar: AppBar(title: Text("Add a new lie")),
        body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (input) => data.title = input!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (input) => data.text = input!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Truth'),
                onSaved: (input) => data.truth = input!,
              ),
              TextButton(
                  onPressed: () => {
                        formKey.currentState?.save(),
                        Provider.of<LieRepository>(context, listen: false).addLie(data),
                        Navigator.of(context).pop()
                      },
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Submit'))
            ],
          ),
        ));
  }
}


