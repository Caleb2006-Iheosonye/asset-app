import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen ({Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
        title: const Text('Reports'),
         actions: [IconButton(
            icon:  Icon(Icons.download),
            onPressed: () {
              // handle the press
            }
      )]
      ),
      body: SafeArea(
       child: SingleChildScrollView(
         child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
        Text('Welcome to the Report Screen!'),],
            )
       )
      ),
       )
    );
  }
}