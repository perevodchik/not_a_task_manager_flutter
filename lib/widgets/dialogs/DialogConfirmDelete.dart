import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class DialogConfirmDelete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Вы действительно хотите удалить эту задачу?", textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text("Назад", style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.pop(context)
                ),
                TextButton(
                  child: Text("Удалить", style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold)),
                    onPressed: () => Navigator.pop(context, true)
                )
              ]
            )
          ]
      )
    );
  }
}