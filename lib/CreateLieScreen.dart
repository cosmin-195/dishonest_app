import 'package:dishonest_app/domain/Lie.dart';
import 'package:dishonest_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateLieScreen extends StatelessWidget {
  static const String id = "create_screen";

  final formKey = GlobalKey<FormState>();

  final Lie data = Lie("nre", "", "", "", LieSeverity.normal);

  int people_counter = 1;

  @override
  Widget build(BuildContext context) {
    final relatedTo = List.of(Provider.of<LieRepository>(context, listen: false)
        .map.keys.map((e) => [e,false]));
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
              Column(
                children: <Widget>[
                  for (int i = 0; i < people_counter; i++)
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "People who've heard"),
                      onSaved: (input) => {data.heardBy.add(input!)},
                    )
                ],
              ),
              Column(
                children: <Widget>[
                  for ( MapEntry<String, Lie> entry  in Provider.of<LieRepository>(context, listen: false)
                      .map.entries)
                    Row(
                      children: [
                        Text(entry.value.title),
                        CheckboxListTile(value: false, onChanged: (bool? value) {

                        },),
                      ],
                    )
                ],
              ),
              TextButton(
                  onPressed: () => {
                        formKey.currentState?.save(),
                        Provider.of<LieRepository>(context, listen: false)
                            .addLie(data),
                        Navigator.of(context).pop(),
                        print(Provider.of<LieRepository>(context, listen: false)
                            .map
                            .values)
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
