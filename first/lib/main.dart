import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
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

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void unlike(pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var mySelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    Widget page;
    switch (mySelectedIndex) {
      case 0:
        page = GeneratorPage();
        // break;
      case 1:
        page = FavPage();
        // break;
      default:
        throw UnimplementedError('no widget for $mySelectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: mySelectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    mySelectedIndex = value;
                  });
                  print('selected: $value');
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


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var myPair = appState.current;

    IconData myIcon;
    if (appState.favorites.contains(myPair)) {
      myIcon = Icons.favorite;
    } else {
      myIcon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: myPair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(myIcon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favList = appState.favorites;
    var favListCard = favList.map((fav) {
      return Card(child: ListTile(title: Text(fav.asLowerCase), 
                    trailing: ElevatedButton.icon(
                      onPressed: () {
                        appState.unlike(fav);
                      },
                      icon: Icon(Icons.favorite),
                      label: Text('unLike'),
                      ),
                    ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: ListView(
        children: favListCard
      ),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var currPair = appState.current;

//     IconData heart;
//     if (appState.favorites.contains(currPair)) {
//       heart = Icons.favorite;
//     } else {
//       heart = Icons.favorite_border;
//     }

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             BigCard(pair: currPair),
//             SizedBox(height: 10),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     appState.toggleFavorite();
//                   },
//                   icon: Icon(heart),
//                   label: Text('Like'),
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     print('button pressed!');
//                     appState.getNext();
//                   },
//                   child: Text('Next'),
//                 ),
//               ],
//             ),
        
//           ],
//         ),
//       ),
//     );
//   }
// }

extension TextStyleX on TextStyle {
  /// A method to underline a text with a customizable [distance] between the text
  /// and underline. The [color], [thickness] and [style] can be set
  /// as the decorations of a [TextStyle].
  TextStyle underlined({
    Color? color,
    double distance = 1,
    double thickness = 1,
    TextDecorationStyle style = TextDecorationStyle.solid,
  }) {
    return copyWith(
      shadows: [
        Shadow(
          color: this.color ?? Colors.black,
          offset: Offset(0, -distance),
        )
      ],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationThickness: thickness,
      decorationColor: color ?? this.color,
      decorationStyle: style,
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final myStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      elevation: 10,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Transform.translate(
          offset: const Offset(0,5),
          child: Text(
                  pair.asLowerCase, 
                  style: myStyle.underlined(
                    distance: 10,
                    color: theme.colorScheme.surfaceContainer,
                    thickness: 1,
                  ),
                  semanticsLabel: "${pair.first} ${pair.second}",
          ),
        ),
      ),
    );
  }
}
