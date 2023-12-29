import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchQueryController = TextEditingController();

  bool isLoading = true;
  double payable = 0;
  double receivable = 0;

  static const int _searchFetchingSeconds = 2;
  DateTime? _latestInputTime;

  @override
  void initState() {
    super.initState();

    //setState(() {
    //  shops = [
    //    Shop(
    //        id: "123123123id",
    //        name: "test",
    //        address: "testsetsetatesatset",
    //        available: true),
    //    Shop(
    //        id: "123123123id",
    //        name: "test",
    //        address: "testsetsetatesatset",
    //        available: true)
    //  ];

    //  orginalShopList = List.from(shops);
    //  isLoading = false;
    //});
  }

  Widget _header() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "ShoppingChk",
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.wysiwyg_rounded),
          onPressed: () => {},
        )
      ],
      titleTextStyle:
          const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    );
  }

  Widget _main() {
    return Material(
        // alignment: Alignment.center,
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextField(
          onChanged: (value) => {},
          controller: _searchQueryController,
          decoration: InputDecoration(
            focusColor: Colors.black,
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 20.0))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
            child: ListView(
          children: [_header(), _main()],
        )));
  }
}
