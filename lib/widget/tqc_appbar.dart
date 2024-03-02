import 'package:flutter/material.dart';

class TQCAppbar extends StatelessWidget implements PreferredSizeWidget{
  String title = "";
  TQCAppbar(title);

  @override
  Widget build(BuildContext context) {
    print("Title is $title");
    return AppBar(
        shape: const Border(
          bottom: BorderSide(width: 1),
        ),
        title: Text("TQC $title"), 
        actions: [
          Card(
            child: Text("About"),
            
          ),
          Card(
            child: Text("Contact"),
          )
        ],      
      );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}