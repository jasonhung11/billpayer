import 'package:flutter/material.dart';
import 'package:test_app/pages/user.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});
  static List<int> text = [1, 2, 4, 5, 2, 1, 2];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Name'),
      ),
      body: Center(
        child: Row(children: [
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
                                  builder: (context) => UserPage(
                                    items: List<ListItem>.generate(
                                      100,
                                      (i) => i % 6 == 0
                                          ? HeadingItem('Heading $i')
                                          : MessageItem(
                                              'Sender $i', 'Message body $i'),
                                    ),
                                  ),
                                ))
                          },
                      child: const SizedBox(
                          width: double.maxFinite,
                          height: 120,
                          child: const Card(
                              color: Color.fromRGBO(158, 192, 235, 0.8),
                              child: Column(children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    'User 1',
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
        ]),
        // ),
      ),
    );
  }
}
