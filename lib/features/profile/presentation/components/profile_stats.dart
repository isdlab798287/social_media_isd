import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats({
    super.key,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.onTap,
  });

  //Build UI
  @override
  Widget build(BuildContext context) {
    //text style for count
    var textStyleForCount = TextStyle(
      fontSize: 20, 
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    // text style for text
    var textStyleForText = TextStyle(
      fontSize: 20, 
      color: Theme.of(context).colorScheme.primary,
    );

    return GestureDetector(
      onTap: onTap, //call the function when tapped
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
          //posts
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  postsCount.toString(),
                  style: textStyleForCount,
                ),
                
                Text('Posts', style: textStyleForText,),
              ],
            ),
          ),
      
          //followers
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followersCount.toString(),
                  style: textStyleForCount,
                ),
                Text('Followers', style: textStyleForText,),
              ],
            ),
          ),
      
          //following
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followingCount.toString(),
                  style: textStyleForCount,
                ),
                Text('Following',
                style: textStyleForText,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}