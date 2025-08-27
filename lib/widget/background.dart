import 'package:flutter/material.dart';

class BackGround {
  decoration(){
    return BoxDecoration(
        gradient: LinearGradient(colors: [
          // Colors.black12,
          Color(0xff011520),
          Color(0xff031c29),
          Color(0xff05364e),
    ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter
        )
    );
  }
  homeDecoration(){
    return BoxDecoration(
        gradient: LinearGradient(colors: [
          // Colors.black12,
          Color(0xff011520),
          Color(0xff031c29),
          Color(0xff021e2c),
          Colors.transparent,
        ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter
        )
    );
  }
}
