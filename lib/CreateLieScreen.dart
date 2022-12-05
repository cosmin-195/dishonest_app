import 'package:dishonest_app/domain/Lie.dart';
import 'package:dishonest_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateLieScreen extends StatefulWidget {
  const CreateLieScreen({super.key, required this.lieToUpdate});

  final String lieToUpdate;

  static const String id = "create_screen";

  @override
  State createState() => _CreateLieScreenState(lieToUpdate);
}

class _CreateLieScreenState extends State<CreateLieScreen> {
  final formKey = GlobalKey<FormState>();
  Lie data = Lie("", "", "", "", LieSeverity.mild);
  int people_counter = 0;
  LieSeverity lieSeverity = LieSeverity.mild;
  final relatedTo = <String, bool>{};
  final String lieToUpdate;


  _CreateLieScreenState(this.lieToUpdate);

  @override
  Widget build(BuildContext context) {
    // final Arguments toUpdate =
    //     ModalRoute.of(context)!.settings.arguments as Arguments;

    final repository = Provider.of<LieRepository>(context, listen: false);
    for (var element in repository.map.keys) {
      relatedTo[element] = false;
    }

    if (lieToUpdate != "") {
      data = repository.getLie(lieToUpdate);
      people_counter = data.relatedTo.length;
    }
    return Scaffold(
        appBar: AppBar(title: Text("Add a new lie")),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  initialValue: data.title,
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (input) => data.title = input!,
                ),
                TextFormField(
                  initialValue: data.text,
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (input) => data.text = input!,
                ),
                TextFormField(
                  initialValue: data.truth,
                  decoration: InputDecoration(labelText: 'Truth'),
                  onSaved: (input) => data.truth = input!,
                ),
                Column(
                  children: <Widget>[
                    for (int i = 0; i < people_counter + 1; i++)
                      TextFormField(
                        initialValue:
                            i < data.heardBy.length ? data.heardBy[i] : "",
                        decoration:
                            InputDecoration(labelText: "People who've heard"),
                        onSaved: (input) => {data.heardBy.add(input!)},
                      ),
                    for (MapEntry<String, Lie> entry in repository.map.entries)
                      Row(
                        children: [
                          Text(entry.value.title),
                          Checkbox(
                              value: relatedTo[entry.key]!,
                              onChanged: (val) => {
                                    setState(() {
                                      relatedTo[entry.key] = true;
                                    })
                                  })
                        ],
                      )
                  ],
                ),
                DropdownButton<String>(
                  value: lieSeverity.toString(),
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      lieSeverity = value! as LieSeverity;
                    });
                  },
                  items: LieSeverity.values.map<DropdownMenuItem<String>>((LieSeverity value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        people_counter++;
                      });
                    },
                    icon: Icon(Icons.add_card)),
                TextButton(
                    onPressed: () => {
                          formKey.currentState?.save(),
                          relatedTo.forEach((key, value) {
                            if (value == true) {
                              data.relatedTo.add(repository.map[key]!);
                            }
                          }),
                          repository.addLie(data),
                          print(repository.map.values),
                          Navigator.pop(context)
                        },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Submit'))
              ],
            ),
          ),
        ));
  }
}
