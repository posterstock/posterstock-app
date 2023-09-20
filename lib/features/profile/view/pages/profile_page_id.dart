import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:poster_stock/features/profile/view/pages/profile_page.dart';

@RoutePage()
class ProfilePageId extends StatelessWidget {
  const ProfilePageId({
    @PathParam('id') this.id = 0,
    super.key,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}
