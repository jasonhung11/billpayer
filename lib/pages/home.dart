import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/api/groupAPI.dart';
import 'package:test_app/api/userAPI.dart';
import 'package:test_app/pages/group.dart';

class AddUserDialog extends StatefulWidget {
  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  List<bool> isSelected = [true, false];
  List<String> options = ['User', 'Guest'];
  final TextEditingController userController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 10, top: 20, left: 30, right: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 15),
                Row(children: [
                  const SizedBox(height: 16.0),
                  ToggleButtons(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    children: options
                        .map((option) => Container(
                            width: (MediaQuery.of(context).size.width - 83) / 2,
                            child: Padding(
                                padding: EdgeInsets.zero,
                                // padding: EdgeInsets.all(5),
                                child: Center(
                                    child: Text(
                                  option,
                                  style: TextStyle(fontSize: 16.0),
                                )))))
                        .toList(),
                    fillColor: Colors.amber,
                    isSelected: isSelected,
                    onPressed: (index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                        print(isSelected);
                      });
                    },
                  ),
                ]),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                TextField(
                  controller: userController,
                  decoration: InputDecoration(
                    labelText: 'UserName',
                    border: OutlineInputBorder(),
                    hintText:
                        isSelected[1] ? 'Enter guest name' : "Enter username",
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        Map<String, String> user = <String, String>{};
                        if (isSelected[0]) {
                          final response =
                              await findUserByUsername(userController.text);
                          if (response["user"] == null) {
                            // Show error message
                          } else {
                            user["type"] = "user";
                            user["name"] = userController.text;
                            user["id"] = response["user"]["id"];
                          }
                          // check user exist
                        } else {
                          user["type"] = "guest";
                          user["name"] = userController.text;
                        }
                        Navigator.pop(context, user);
                      },
                      child: const Text('Add'),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                    const Spacer(),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> groupSummary = [];
  int totalPayable = 0;
  int totalReceivable = 0;
  String userId = "";
  String username = "";
  List<bool> isSelected = [false, false];
  List<String> options = ['User', 'Guest'];
  int currentPageIndex = 0;
  int _selectedIndex = 0;
  int totalNewUser = 1;
  void getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.get('userId').toString();
      username = prefs.get('username').toString();
      print("userIdbbbbbbaaaa: " + userId + " userName:" + username);
      getUserGroupSummary(userId).then((Map<String, dynamic> result) {
        setState(() {
          groupSummary = result["data"];
          print(result);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          getUserDetail(),
        });

    ;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateNewUser(int user) {
    setState(() {
      totalNewUser += user;
    });
  }

  void addUserDialog(isSelectedList) => showDialog(
      context: context,
      // applicationName: "Add User",
      builder: (BuildContext context) => Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 10, top: 20, left: 30, right: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Group Name',
                      border: OutlineInputBorder(),
                      hintText: 'Enter a group name',
                    ),
                  ),
                  const Text('This is a typical dialog.'),
                  const SizedBox(height: 15),
                  const Text(
                    'Select One Option:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    SizedBox(height: 16.0),
                    ToggleButtons(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      children: options
                          .map((option) => Container(
                              width:
                                  (MediaQuery.of(context).size.width - 83) / 2,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                      child: Text(
                                    option,
                                    style: TextStyle(fontSize: 16.0),
                                  )))))
                          .toList(),
                      fillColor: Colors.amber,
                      isSelected: isSelectedList,
                      onPressed: (index) {
                        setState(() {
                          for (int i = 0; i < isSelectedList.length; i++) {
                            isSelected[i] = i == index;
                          }
                          print(isSelected);
                        });
                      },
                    ),
                  ]),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          )));

  Future addGroupDialog() => showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: 800,
            color: Colors.white,
            alignment: Alignment.topCenter,
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                  ListTile(
                    leading: TextButton(
                      onPressed: () => {
                        // createGroup
                      },
                      child: const Text('Save'),
                    ),
                    title: const Center(child: Text("My Title")),
                    minLeadingWidth: 60,
                    contentPadding: EdgeInsets.zero,
                    trailing: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(children: [
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Group Name',
                          border: OutlineInputBorder(),
                          hintText: 'Enter a group name',
                        ),
                      ),
                      Card(
                          child: Column(
                        children: [
                          ListTile(title: Text('One-line ListTile')),
                          const Text("Member List"),
                          // const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 20)),
                            onPressed: () async {
                              final a = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddUserDialog();
                                },
                              );
                              print(a.toString());
                            },
                            child: Row(children: [
                              const Spacer(),
                              Text('Add'),
                              Icon(Icons.add),
                              const Spacer()
                            ]),
                          ),
                        ],
                      )),
                    ]),
                    // margin: const EdgeInsets.all(15.0),
                    // padding: const EdgeInsets.all(3.0),
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.grey)),
                    // child:
                    // Center(
                    // child: Row(
                    //     // mainAxisAlignment: MainAxisAlignment.center,
                    //     // mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Column(
                    //         children: [
                    //   const Text("Member List"),
                    //   const Spacer(),
                    //   ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //         textStyle:
                    //             const TextStyle(fontSize: 20)),
                    //     onPressed: () async {
                    //       final a = await showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) {
                    //           return AddUserDialog();
                    //         },
                    //       );
                    //       print(a.toString());
                    //     },
                    //     child: Row(children: [
                    //       const Spacer(),
                    //       Text('Add'),
                    //       Icon(Icons.add),
                    //       const Spacer()
                    //     ]),
                    //   ),
                    // ],
                    //       ),
                    //       const Text("dataaaa")
                    //     ]),

                    // new List.generate(totalNewUser, (index) => )
                    // Container(
                    //   // color: Colors.blue,
                    //   height: 100,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       const Expanded(
                    //         child: TextField(
                    //           decoration: InputDecoration(
                    //             labelText: 'User 1',
                    //             border: OutlineInputBorder(),
                    //             hintText: 'Enter user email or guest name',
                    //           ),
                    //         ),
                    //       ),

                    //             // child: IconButton(

                    //     icon: const Icon(Icons.add)),

                    // Container(width: 50, height: 50, color: Colors.red),
                    // Container(
                    //     width: 50, height: 50, color: Colors.green),
                    // Container(
                    //     width: 50, height: 50, color: Colors.yellow),

                    // const Spacer(),
                    // ElevatedButton(
                    //   child: const Text('Close BottomSheet'),
                    //   onPressed: () => Navigator.pop(context),
                    // ),
                    // Other widgets...

                    // children: [
                    //   Container(
                    //     height: 100,
                    //     child: Row(
                    //       children: [

                    //       ],
                    //     ),
                    //   ),
                    // ],
                  ),
                  Spacer(),
                ])));
        //   ),
        // );
      });

  Widget _home() {
    List<int> text = [1, 2, 4, 5, 2, 1, 2];

    return Material(
        child: SafeArea(
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
      TextButton(
        child: const Text("Logout"),
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
      ),
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
                  Text('YOU'),
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
          child: ListView.builder(
              itemCount: groupSummary.length,
              itemBuilder: (context, index) {
                final itemData = groupSummary[index];
                return Container(
                    padding: EdgeInsets.all(15.0),
                    width: double.infinity,
                    child: Column(children: [
                      InkWell(
                          onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GroupDetailPage()),
                                )
                              },
                          child: SizedBox(
                              width: double.maxFinite,
                              height: 120,
                              child: Card(
                                  color: Color.fromRGBO(243, 230, 216, 0.8),
                                  child: Column(children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        itemData["groupName"],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(145, 127, 96, 1),
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
                                    Row(children: [
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.center,
                                        child:
                                            Text(itemData["payable"].toString(),
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  color: itemData["payable"] > 0
                                                      ? Colors.red
                                                      : Colors.black,
                                                ),
                                                textAlign: TextAlign.right),
                                      ),
                                      const Spacer(),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                            itemData["receivable"].toString(),
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: itemData["receivable"] > 0
                                                  ? Colors.green
                                                  : Colors.black,
                                            ),
                                            textAlign: TextAlign.right),
                                      ),
                                      const Spacer()
                                    ]),
                                  ]))))
                    ]));
              })),

      // TextButton(
      //   onPressed: () async {
      //     try {
      //       final user = await loginWithGoogle();
      //       if (user != null) {
      //         print(user);
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => const LoginPage()),
      //         );
      //       }
      //     } on FirebaseAuthException catch (e) {
      //       print(e);
      //     } catch (e) {
      //       print(e.toString() + "fasd");
      //     }
      //   },
      //   child: const Text('Login'),
      // ),
    ])));
  }

  Widget mainPage(theme) {
    return <Widget>[
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
    ][_selectedIndex];
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
        body: mainPage(theme));
  }
}
