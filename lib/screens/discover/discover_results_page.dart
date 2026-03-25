import 'package:flutter/material.dart';
import '../match/match_page.dart';

class DiscoverResultsPage extends StatelessWidget {

  final String goal;

  const DiscoverResultsPage({
    super.key,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      appBar: AppBar(

        elevation: 0,
        backgroundColor: Colors.white,

        leading: IconButton(

          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),

          onPressed: (){
            Navigator.pop(context);
          },

        ),

        title: Text(
          goal,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),

      body: const MatchPage(),

    );

  }

}