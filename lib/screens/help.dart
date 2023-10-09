import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tablet_tabak/theme/colors/light_colors.dart';
import 'package:tablet_tabak/main.dart';
import 'package:tablet_tabak/screens/home_page.dart';
import 'package:tablet_tabak/screens/demands.dart';
import 'package:tablet_tabak/screens/product.dart';
import 'package:tablet_tabak/screens/report.dart';
import 'package:tablet_tabak/screens/notification.dart';

class HelpPage extends StatelessWidget {

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Row(
          children: [
            Image.network('https://cdn-icons-png.flaticon.com/512/5987/5987420.png',
              fit: BoxFit.contain,
              width: 45,
              height: 40,),
            Text(
              MyApp.userName ?? '', // Eğer userName null ise boş bir string gösterir
              style: TextStyle(
                color: Colors.white, // İstediğiniz rengi seçebilirsiniz
                fontSize: 16.0, // İstediğiniz boyutu seçebilirsiniz
                fontWeight: FontWeight.bold, // İstediğiniz kalınlığı seçebilirsiniz
              ),
            ),
            IconButton(
              color: Colors.red,
              icon: Icon(Icons.logout),
              onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()), (route) => false,);
              },
            ),
            Text(
              'Ausloggen', // Eğer userName null ise boş bir string gösterir
              style: TextStyle(
                color: Colors.red, // İstediğiniz rengi seçebilirsiniz
                fontSize: 16.0, // İstediğiniz boyutu seçebilirsiniz
                fontWeight: FontWeight.bold, // İstediğiniz kalınlığı seçebilirsiniz
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              textColor: Colors.black54,
              leading: IconButton(
                color: Colors.brown,
                icon: Icon(Icons.home),
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              ),
              title: Text('Armaturenbrett'),
            ),
            ListTile(
              textColor: Colors.black54,
              leading: IconButton(
                color: Colors.brown,
                icon: Icon(Icons.label),
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              ),
              title: Text('Produkte'),
            ),
            ListTile(
              textColor: Colors.black54,
              leading: IconButton(
                color: Colors.brown,
                icon: Icon(Icons.list),
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              ),
              title: Text('Demands'),
            ),
            ListTile(
              textColor: Colors.black54,
              leading: IconButton(
                color: Colors.brown,
                icon: Icon(Icons.message),
                onPressed: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(),
                    ),
                  );
                },
              ),
              title: Text('Notifications'),
            ),
            ListTile(
              textColor: Colors.black54,
              leading: IconButton(
                color: Colors.red,
                icon: Icon(Icons.help),
                onPressed: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HelpPage()), (route) => false,);
                },
              ),
              title: Text('Helfen'),
            ),
            ListTile(
              textColor: Colors.red,
              leading: IconButton(
                color: Colors.red,
                icon: Icon(Icons.logout),
                onPressed: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()), (route) => false,);
                },
              ),
              title: Text('Ausloggen',),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: 170,
                                  height:55,
                                  decoration: BoxDecoration(
                                      color: Colors.teal,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_road, color: Colors.white, size: 30),
                                      Text(' Lagereintrag',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // Başka bir sayfaya yönlendir.
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: 170,
                                  height:55,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_box, color: Colors.white, size: 30),
                                      Text(' Produkte',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // Başka bir sayfaya yönlendir.
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: 180,
                                  height:55,
                                  decoration: BoxDecoration(
                                      color: Colors.red.shade900,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_alert, color: Colors.white, size: 30),
                                      Text(' Kritisches Inventar',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // Başka bir sayfaya yönlendir.
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: 170,
                                  height:55,
                                  decoration: BoxDecoration(
                                      color: Colors.brown,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.crisis_alert_outlined, color: Colors.white, size: 30),
                                      Text(' Bestandsausgabe',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // Başka bir sayfaya yönlendir.
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

