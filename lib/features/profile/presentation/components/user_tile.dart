import 'package:flutter/material.dart';
import 'package:isd_app/features/profile/domain/entities/profile_user.dart';
import 'package:isd_app/features/profile/presentation/pages/profile_page.dart';

class UserTile extends StatelessWidget {
  final ProfileUser user;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.user,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      subtitleTextStyle: 
        TextStyle(color: Theme.of(context).colorScheme.primary, 
        fontSize: 14.0),
      leading: Icon(
        Icons.person,
        color: Theme.of(context).colorScheme.primary,
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primary,
      ),

      onTap: onTap,
      // onTap: () => Navigator.push(
      //   context, 
      //   MaterialPageRoute(
      //     builder: (context) => 
      //       ProfilePage(uid: user.uid,),
      //   ),
      // ),
    );
  }
}