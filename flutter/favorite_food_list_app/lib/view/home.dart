import 'package:favorite_food_list_app/view/%08mylist/mylist.dart';
import 'package:favorite_food_list_app/view/world_list.dart';
import 'package:favorite_food_list_app/view/ourlist/our_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  late TabController tabController;
  // image path 받을 것임
  // late String name, phone, lat, lng, img, rate, inputDate;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    // name = '';
    // phone = '';
    // lat = '';
    // lng = '';
    // img = '';
    // rate = '';
    // inputDate = '';
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Food List'),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          MyList(),
          OurList(),
          WorldList(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: TabBar(
          controller: tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorWeight: 5,
          tabs: const [
            Tab(
              icon: Icon(Icons.person),
              text: 'My'
            ),
            Tab(
              icon: Icon(Icons.people),
              text: 'Our'
            ),
            Tab(
              icon: Icon(Icons.airplanemode_active),
              text: 'World'
            ),
          ]
        ),
      ),
    );
  }
}