//import 'dart:html';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';



void main() {
  runApp(MyApp());
}

//entries[index] to select location
//entries[index][index] to select location attribute
//[entry name, entry id]
final List<List<String>> entries = [
  [
    'Hound Ears','0'
  ],
  [
    'The Dump','1'
  ],
  [
    'Sunken Tresure','2'
  ],
  [
    'Little Wilson','3'
  ],
  [
    'Lost Cove','4'
  ],
  [
    'Grandmother','5'
  ]
];

//routes for each entry. ex. routes for entry 3 will be at index 3
//maybe [[[]]] ??
final List<List<String>> routes = [
  [
    'Route A 1', 'Route A 2'
  ],
  [
    'Route B 1', 'Route B 2', 'Route B 3'
  ],
  [
    'Route C 1'
  ],
  [
    'Route D 1'
  ],
  [
    'Route E 1'
  ],
  [
    'Route F 1'
  ]
];

final List<List<String>> favorites = [];


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Capstone',
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 96, 202, 252),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          unselectedWidgetColor: Colors.blue
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }


  //var favorites = <WordPair>[];

  void toggleFavorite(id) {
    if (favorites.contains(entries[id])) {
      favorites.remove(entries[id]);
    } else {
      favorites.add(entries[id]);
    }
    notifyListeners();
  }
}
//}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
      page = MainPage();
      break;
      case 1:
      page = FavoritesPage();
      break;
      case 2:
      page = SettingsPage();
      break;
      
    default:
      throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: false,//constraints.maxWidth >= 500,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home, size: 75),
                      label: Text('Home', style: TextStyle(fontSize: 25)),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite, size: 75),
                      label: Text('Favorites', style: TextStyle(fontSize: 25)),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings, size: 75),
                      label: Text('Settings', style: TextStyle(fontSize: 25)),
                    )
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


//class GeneratorPage extends StatelessWidget {
  //@override
  //Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    //var pair = appState.current;

    //IconData icon;
    //if (appState.favorites.contains(pair)) {
      //icon = Icons.favorite;
    //} else {
      //icon = Icons.favorite_border;
    //}

    //return Center(
      //child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //children: [
          //BigCard(pair: pair),
          //SizedBox(height: 10),
          //Row(
            //mainAxisSize: MainAxisSize.min,
            //children: [
              //ElevatedButton.icon(
                //onPressed: () {
                  //appState.toggleFavorite();
                //},
                //icon: Icon(icon),
                //label: Text('Like'),
              //),
              //SizedBox(width: 10),
              //ElevatedButton(
                //onPressed: () {
                  //appState.getNext();
                //},
                //child: Text('Next'),
              //),
            //],
          //),
        //],
      //),
    //);
  //}
//}

/*
class FileReader {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File("$path/data.txt");
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();

      return contents;
      }catch (e) {
        return "error";
      }
    }
  }
*/



//maybe make InfoPage a listener of the home page 
//so it can be sent which location's data to retrieve
class InfoPage extends StatelessWidget {
   int id = 0;
   InfoPage(String id) {
    this.id = int.parse(id);
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
          size: 50,
        ),
        toolbarHeight: 200,
        title: Text('Info for ${entries[id][0]}', style: TextStyle(fontSize: 75, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        bottom: PreferredSize(
          child: Text("${routes[id].length} routes", style: TextStyle(fontSize: 50, color: Colors.white)),
          preferredSize: Size.zero),
      ),
      body: ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: routes[id].length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.white,
          //child: ListTile(
          child: ExpansionTile(
            title: Center(child: Text('${routes[id][index]}', style: TextStyle(fontSize: 50))),//Text('Entry ${entries[index]}', style: TextStyle(fontSize: 35)),
            subtitle: Center(child: Text('Entry info', style: TextStyle(fontSize: 35))),
            
            children: <Widget>[
              ListTile(title: Center(child: Text('info', style: TextStyle(fontSize: 25)))),
            ],
            //trailing: Row(

              //),//more_vert, size: 50),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      )
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    //final FileReader reader = FileReader();
    
    //Future<String> dat = reader.readData();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBar(
        title: const Text('Home', style: TextStyle(fontSize: 75, color: Colors.white)),
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        )
      ),
        body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            
            color: Colors.white,
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2),
                borderRadius: BorderRadius.circular(50),
              ),
              title: Center(child: Text('${entries[index][0]}', style: TextStyle(fontSize: 35))),
              subtitle: Center(child: Text('${routes[index].length} routes', style: TextStyle(fontSize: 25))),
              //subtitle: Center(child: Text('$dat')),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: favorites.contains(entries[index]) ? Icon(Icons.favorite, size: 50.0) : Icon(Icons.favorite_border, size: 50.0),
                    onPressed: () {
                      appState.toggleFavorite(index);

                    },
                  ),  
                ],
                ),//more_vert, size: 50),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoPage(entries[index][1]),
                ));
              }
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )  
    );  
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool toggle = false;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBar(
          title: const Text('Favorites', style: TextStyle(fontSize: 50, color: Colors.white)),
          backgroundColor: Colors.blue,
      )
      ),
    body: ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: favorites.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.white,
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
            title: Center(child: Text('${favorites[index][0]}', style: TextStyle(fontSize: 35))),//Text('Entry ${entries[index]}', style: TextStyle(fontSize: 35)),
            subtitle: Center(child: Text('Entry info', style: TextStyle(fontSize: 25))),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: toggle 
                      ? Icon(Icons.favorite_border, size: 50.0)
                      : Icon(Icons.favorite, size: 50.0),
                  //icon: Icon(
                    //Icons.favorite_border,
                    //size: 50.0,
                    //color: Colors.brown[900],
                  //),
                  onPressed: () {
                    //appState.toggleFavorite();
                    toggle = !toggle;

                  },
                ),  
              ],
              ),//more_vert, size: 50),
            onTap: () {
              Navigator.push(
                context,
                //when this \/\/ has entries[index][1] it has the incorrect value
                MaterialPageRoute(builder: (context) => InfoPage(entries[int.parse(favorites[index][1])][1]),
              ));
            }
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    )
    );


  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var sText = <String>["Location Services", "Dark Mode", "Voiceover"];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: AppBar(
          title: const Text('Settings', style: TextStyle(fontSize: 50, color: Colors.white)),
          backgroundColor: Colors.blue,
      )
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: 3,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 75,
            child: ListTile(
              tileColor: Colors.white,
              title: Text(sText[index],style: TextStyle(fontSize: 35)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.crop_square_rounded, size: 50.0),
                    onPressed: (
                      null
                    ),
                  )
                ]
              )
            )
          );
        },
        )
    );
  }
}

//class FavoritesPage extends StatelessWidget {
  //@override
  //Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    //if (appState.favorites.isEmpty) {
      //return Center(
        //child: Text('No favorites yet.'),
        //);
    //}

    //return ListView(
      //children: [
        //Padding(
          //padding: const EdgeInsets.all(20),
          //child: Text ('You have '
            //'${appState.favorites.length} favorites:'),
            //),
            //for (var pair in appState.favorites)
              //ListTile(
                //leading: Icon(Icons.favorite),
                //title: Text(pair.asLowerCase),
              //),
      //],
    //);
  //}
//}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase, style: style, semanticsLabel: pair.asPascalCase,),
      ),
    );
  }
}