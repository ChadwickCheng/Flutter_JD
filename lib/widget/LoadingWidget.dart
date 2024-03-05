import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Padding(
        padding:EdgeInsets.all(10.0),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Loading...',
              style:TextStyle(
                fontSize:16.0,
                color:Colors.black54
              )
            ),
            CircularProgressIndicator(
              strokeWidth:1.0,
            )
          ],
        ),
      )
    );
  }
}