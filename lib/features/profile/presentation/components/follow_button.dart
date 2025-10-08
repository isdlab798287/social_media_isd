/*
  to use this widget, you need to pass the following parameters:
  A FUNCTION to toggle follow status
  IS FOLLOWING BOOLEAN to indicate if the user is already following
 */

import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(

      //padding around the button
      padding: const EdgeInsets.symmetric(horizontal: 25.0),

      //button to follow or unfollow the user
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: MaterialButton(
          onPressed: onPressed,
          padding: const EdgeInsets.all(18),

          //background color
          color: isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,

          //text
          child: Text(
            isFollowing ? 'Unfollow' : 'Follow',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              
              fontWeight: FontWeight.bold,
            ),
        ),
      ),
    ),
    );
  }
}