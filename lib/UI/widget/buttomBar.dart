import 'package:flutter/material.dart';
import 'package:latihan_mvvm/UI/PegawaiPage.dart';
import 'package:latihan_mvvm/UI/homePage.dart';

Widget buildBottomBar(index,BuildContext context){
  return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap:  (i){
          switch (i) {
            case 0:
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context)=>HomePage()
              ));
              break;
               case 1:
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context)=>PegawaiPage()
              ));
              break;
            default:
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle), title: Text("Pegawai")),
        ],
      );
}