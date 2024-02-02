import 'package:flutter/material.dart';
import 'package:test_app/api/groupAPI.dart';
import 'package:test_app/pages/transactionHistory.dart';
import 'package:test_app/pages/user.dart';

class GroupDetailPage extends StatefulWidget {
  const GroupDetailPage({super.key});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPage();
}

class _GroupDetailPage extends State<GroupDetailPage> {
  dynamic groupDetail = {};
  List<dynamic> userList = [];

  int totalPayable = 0;
  int totalReceivable = 0;
  @override
  void initState() {
    super.initState();
    getGroupDetail("123").then((Map<String, dynamic> result) {
      setState(() {
        groupDetail = result;
        userList = groupDetail["amount"];
        for (dynamic userPayable in result["amount"]) {
          totalPayable += int.parse(userPayable["payable"].toString());
          totalReceivable += int.parse(userPayable["receivable"].toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: groupDetail["groupName"].toString().isEmpty
              ? Text("")
              : Text(groupDetail["groupName"].toString()),
        ),
        body: Center(
            child: Column(children: [
          Row(
            children: [
              const Spacer(),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                  // <-- ElevatedButton
                  onPressed: () {
                    // addGroupDialog();
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 24.0,
                  ),
                  label: const Text('New Transaction'),
                ),
              ),
            ],
          ),
          Container(
            // color: Color.fromRGBO(192, 181, 127, 1),
            padding: EdgeInsets.all(15.0),
            width: double.infinity,
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: 120,
                child: Card(
                    color: Color.fromRGBO(165, 241, 183, 1),
                    child: Column(children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "YOU",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(145, 127, 96, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          Spacer(),
                          Text(
                            "Total Payable",
                            style: TextStyle(fontSize: 15),
                          ),
                          Spacer(),
                          Text(
                            "Total Receivable",
                            style: TextStyle(fontSize: 15),
                          ),
                          Spacer()
                        ],
                      ),
                      Row(children: [
                        Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Text(totalPayable.toString(),
                              style: TextStyle(
                                fontSize: 30,
                                color: totalPayable > 0
                                    ? Colors.red
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.right),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: Text(totalReceivable.toString(),
                              style: TextStyle(
                                fontSize: 30,
                                color: totalReceivable > 0
                                    ? Colors.green
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.right),
                        ),
                        const Spacer()
                      ]),
                    ])),
              ),
            ]),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final itemData = userList[index];

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
                                              const TransactionHistoryPage(
                                                  groupId: "123", userId: "3")),
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
                                            itemData["userName"],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Color.fromRGBO(
                                                  145, 127, 96, 1),
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
                                            child: Text(
                                                itemData["payable"].toString(),
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
                                                itemData["receivable"]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  color:
                                                      itemData["receivable"] > 0
                                                          ? Colors.green
                                                          : Colors.black,
                                                ),
                                                textAlign: TextAlign.right),
                                          ),
                                          const Spacer()
                                        ]),
                                      ]))))
                        ]));
                  }))
          // Padding(
          //   padding: EdgeInsets.only(top: 10),
          //   child: Text(
          //     user["userName"],
          //     style: TextStyle(
          //       fontSize: 18,
          //       color: Color.fromRGBO(145, 127, 96, 1),
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // const Row(
          //   children: [
          //     const Spacer(),
          //     Text(
          //       "Total Payable",
          //       style: TextStyle(fontSize: 15),
          //     ),
          //     const Spacer(),
          //     Text(
          //       "Total Receivable",
          //       style: TextStyle(fontSize: 15),
          //     ),
          //     const Spacer()
          //   ],
          // ),
          // const Row(children: [
          //   const Spacer(),
          //   Align(
          //     alignment: Alignment.center,
          //     child: const Text("0",
          //         style: TextStyle(fontSize: 30),
          //         textAlign: TextAlign.right),
          //   ),
          //   const Spacer(),
          //   Align(
          //     alignment: Alignment.center,
          //     child: const Text("0",
          //         style: TextStyle(fontSize: 30),
          //         textAlign: TextAlign.right),
          //   ),
          //   const Spacer()
          // ]),
        ])));
  }
}
