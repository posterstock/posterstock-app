import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/profile/view/widgets/profile_appbar.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class WaitProfile extends StatelessWidget {
  final String title;

  const WaitProfile(this.title, {super.key});

  const WaitProfile.empty({super.key}) : title = '';

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: NotificationListener<ScrollUpdateNotification>(
        child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                pinned: false,
                floating: true,
                elevation: 0,
                toolbarHeight: 50,
                expandedHeight: 50,
                collapsedHeight: 50,
                backgroundColor: context.colors.backgroundsPrimary,
                leading: const SizedBox(),
                centerTitle: true,
                title: const SizedBox(),
                flexibleSpace: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    ProfileAppbar(title),
                  ],
                ),
              ),
              const WaitScreen(),
            ];
          },
          body: const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class WaitScreen extends StatelessWidget {
  const WaitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: defaultTargetPlatform != TargetPlatform.android
            ? const CupertinoActivityIndicator(radius: 10)
            : SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: context.colors.iconsDisabled!,
                  strokeWidth: 2,
                ),
              ),
      ),
    );
  }
}
