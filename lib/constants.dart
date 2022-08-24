import 'package:flutter/material.dart';

var defaultBackgroundColor = Colors.grey[300];
var appBarColor = Colors.grey[900];
var myAppBar = AppBar(
  backgroundColor: appBarColor,
  title: Text('srtm - Société Régionale de Transport de Medenine  '),
  centerTitle: false,
);
var drawerTextColor = TextStyle(color: Colors.grey[600], letterSpacing: 1);
var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);
var myDrawer = Drawer(
  backgroundColor: Colors.grey[300],
  elevation: 0,
  child: Column(
    children: [
      DrawerHeader(
          child: Container(
        child: Column(
          children: [
            Icon(
              Icons.mail,
              size: 64,
              color: Colors.blue,
            ),
            SizedBox(height: 10,),
            Text("BOUFATH Aziz")
          ],
        ),
      )),
      Padding(
        padding: tilePadding,
        
        child: ListTile(
          leading: Icon(Icons.picture_in_picture_alt),
          onTap: (() {
            print("pub");
          }),
          title: Text(
            'PUBLICITE',
            style: drawerTextColor,
          ),
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: Icon(Icons.data_exploration_sharp),
           onTap: (() {
            print("data");
          }),
          title: Text(
            'TRANSIT DATA',
            style: drawerTextColor,
          ),
        ),
      ),
      Padding(
        padding: tilePadding,
        child: ListTile(
          leading: Icon(Icons.logout),
           onTap: (() {
            print("logout");
          }),
          title: Text(
            'L O G O U T',
            style: drawerTextColor,
          ),
        ),
      ),
    ],
  ),
);
