import 'package:flutter/material.dart';
import 'package:sleep_app/data.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/InformationItem.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final controller = TextEditingController();

  String searchText = '';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Information"),
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0),
          child: TextField(
            controller: controller,
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_outlined),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                  padding: const EdgeInsets.only(right: 8.0),
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    setState(() {
                      searchText = '';
                    });
                    FocusScope.of(context).unfocus();
                  },
                )
                    : null,
              hintText: 'Поиск',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),
        )
        ,
        Expanded(
            child: GridView.builder(
                itemCount: filteredInfs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformationDetailPage(
                              information: filteredInfs[index].mainText!,
                              name: filteredInfs[index].name!),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors:
                          [Color.fromARGB(228, 91, 75, 125), Color.fromARGB(
                            211, 111, 80, 125)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.4),
                              blurRadius: 2,
                              spreadRadius: 1,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset(
                                filteredInfs[index].image!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Center(
                              child: Text(
                                filteredInfs[index].name!,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }))
      ]),
    );
  }

  List<InformationItem> get filteredInfs {
    RegExp regex = RegExp(searchText, caseSensitive: false);
    return searchText.isEmpty
        ? infs
        : infs.where((inf) => regex.hasMatch(inf.name!)).toList();
  }

}

class InformationDetailPage extends StatelessWidget {
  final String information;
  final String name;

  const InformationDetailPage({super.key, required this.information, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder(
        future: loadAsset(information),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String dataTo = snapshot.data.toString();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                data: dataTo,
                onTapLink: (text, href, title) {
                  href != null
                      ? launch(href)
                      : null;
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<String> loadAsset(String toLoad) async {
    return await rootBundle.loadString(toLoad);
  }
}
