import 'package:flutter/material.dart';

class VideoCardShimmer extends StatelessWidget {
  const VideoCardShimmer({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 23,
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).accentColor,
                    ),
                    child: Text(''),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).accentColor,
                    ),
                    child: Text(''),
                  ),
                ],
              )
            ],
          )
        ]
      ),
    );
  }
}