import 'package:dishonest_app/CreateLieScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/Lie.dart';

void main() {
  runApp(const MyApp());
}

class Arguments {
  final String lieToUpdate;

  Arguments(this.lieToUpdate);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String id = "main_screen";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LieRepository(),
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: {
          'create_screen': (context) => CreateLieScreen(lieToUpdate: ""),
          'main_screen': (context) => MyApp(),
        },
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const MyHomePage(title: 'The Liebook'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    String arg = "";
    Arguments args = Arguments(arg);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Consumer<LieRepository>(
        builder: (context, repository, child) {
          List<Lie> list = repository.findAll();
          repository.findAll().forEach((element) {
            print(element);
          });
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (ctx, i) => LieListItem(list[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            {Navigator.pushNamed(context, CreateLieScreen.id, arguments: args)},
        tooltip: 'Add new',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LieListItem extends StatelessWidget {
  Lie lie;

  LieListItem(this.lie, {super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _showDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Lie was deleted successfully.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Great'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final repository = Provider.of<LieRepository>(context);
    return Card(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(lie.title),
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateLieScreen.id,
                  arguments: Arguments((lie.id!)));
            },
            icon: Icon(Icons.edit)),
        IconButton(
            onPressed: () {
              repository.deleteLie(lie.id!);
              _showDialog();
            },
            icon: Icon(Icons.delete_forever)),
      ],
    ));
  }
}
