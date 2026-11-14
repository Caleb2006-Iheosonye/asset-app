import 'package:flutter/material.dart';
import 'package:asset_app/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.notifications))],
      ),
       body: SafeArea(
       child: SingleChildScrollView(
         child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
        Text('Welcome to the Profile Screen!'),],
            )
       )
      ),
       )
    );
  }
}