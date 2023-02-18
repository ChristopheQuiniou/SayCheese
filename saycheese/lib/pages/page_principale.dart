import 'package:flutter/material.dart';
import 'package:saycheese/pages/page_appareil_photo.dart';

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({super.key});

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Say Cheese")),
      body: Center(
        child: Column(children: [
          const Padding(padding: EdgeInsets.only(top: 25)),
          const Text(
            "Bienvenue !",
            style: TextStyle(fontSize: 34),
          ),
          const Padding(padding: EdgeInsets.only(top: 25)),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return const PageAppareilPhoto();
                }));
              },
              child: const Text("Prendre un photo"))
        ]),
      ),
    );
  }
}
