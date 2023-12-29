import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/pages/group.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'My app', // used by the OS task switcher
      home: SafeArea(
        child: MyHomePage(),
      ),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future addGroupDialog() => showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 800,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: TextButton(
                    onPressed: null,
                    child: const Text('Save'),
                  ),
                  title: Center(child: Text("My Title")),
                  minLeadingWidth: 60,
                  contentPadding: EdgeInsets.zero,
                  trailing: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Group Name',
                          border: OutlineInputBorder(),
                          hintText: 'Enter a group name',
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      });

  Widget _home() {
    List<int> text = [1, 2, 4, 5, 2, 1, 2];

    return Material(
        child: Column(children: [
      Container(
        padding: EdgeInsets.only(left: 15, right: 15.0, top: 5),
        child: Row(
          children: [
            const FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "找數啦！",
                  style: TextStyle(fontSize: 25),
                )),
            const Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton.icon(
                // <-- ElevatedButton
                onPressed: () {
                  addGroupDialog();
                },
                icon: const Icon(
                  Icons.add,
                  size: 24.0,
                ),
                label: const Text('Add Group'),
              ),
            ),
          ],
        ),
      ),
      const Align(alignment: Alignment.topRight, child: Text("Date: ")),
      Container(
        // color: Color.fromRGBO(192, 181, 127, 1),
        padding: EdgeInsets.all(15.0),
        width: double.infinity,
        child: const Column(children: [
          const SizedBox(
            width: double.infinity,
            height: 100,
            child: const Card(
                color: Color.fromRGBO(165, 241, 183, 1),
                child: Column(children: [
                  Text('Hello World!'),
                  const Row(
                    children: [
                      const Spacer(),
                      Text("Payable"),
                      const Spacer(),
                      Text("Receivable"),
                      const Spacer()
                    ],
                  ),
                  const Row(
                    children: [
                      const Spacer(),
                      const Text("0",
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.right),
                      const Spacer(),
                      const Text(
                        "0",
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.right,
                      ),
                      const Spacer()
                    ],
                  )
                ])),
          ),
        ]),
      ),
      Expanded(
          child: ListView(children: <Widget>[
        for (int i in text)
          Container(
            padding: EdgeInsets.all(15.0),
            width: double.infinity,
            child: Column(children: [
              InkWell(
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SecondRoute()),
                        )
                      },
                  child: const SizedBox(
                      width: double.maxFinite,
                      height: 120,
                      child: const Card(
                          color: Color.fromRGBO(243, 230, 216, 0.8),
                          child: Column(children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Group 1',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(145, 127, 96, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Row(
                              children: [
                                const Spacer(),
                                Text(
                                  "Total Payable",
                                  style: TextStyle(fontSize: 15),
                                ),
                                const Spacer(),
                                Text(
                                  "Total Receivable",
                                  style: TextStyle(fontSize: 15),
                                ),
                                const Spacer()
                              ],
                            ),
                            const Row(children: [
                              const Spacer(),
                              Align(
                                alignment: Alignment.center,
                                child: const Text("0",
                                    style: TextStyle(fontSize: 30),
                                    textAlign: TextAlign.right),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.center,
                                child: const Text("0",
                                    style: TextStyle(fontSize: 30),
                                    textAlign: TextAlign.right),
                              ),
                              const Spacer()
                            ]),
                          ]))))
            ]),
          )
      ])),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: <Widget>[
        /// Home page
        _home(),

        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),
      ][_selectedIndex],
    );
  }
}



// class MyAppBar extends StatelessWidget {
//   const MyAppBar({required this.title, super.key});

//   // Fields in a Widget subclass are always marked "final".

//   final Widget title;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 56, // in logical pixels
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(color: Colors.blue[500]),
//       // Row is a horizontal, linear layout.
//       child: Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.menu),
//             tooltip: 'Navigation menu',
//             onPressed: () {
//               print("object");
//             }, // null disables the button
//           ),
//           // Expanded expands its child
//           // to fill the available space.
//           Expanded(
//             child: title,
//           ),
//           const IconButton(
//             icon: Icon(Icons.search),
//             tooltip: 'Search',
//             onPressed: null,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Color.fromRGBO(153, 210, 212, 0.3),
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
