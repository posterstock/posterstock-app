import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/home/view/widgets/post_base.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    bool keepOffset = false;
    return Stack(
      children: [
        Positioned(
          top: 58,
          right: 0,
          left: 0,
          child: Center(
            child: defaultTargetPlatform != TargetPlatform.android ? CupertinoActivityIndicator(
              radius: 10,
            ) : SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: context.colors.iconsDisabled!,
                strokeWidth: 2,
              ),
            ),
          ),
        ), //TODO remove if not loading
        NotificationListener<ScrollUpdateNotification>(
          onNotification: (n) {
            if (n.metrics.pixels < -120) {
              controller.animateTo(
                -50,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
              Future.delayed(const Duration(milliseconds: 300), () {
                keepOffset = true;
              });
              Future.delayed(const Duration(seconds: 3), () {
                keepOffset = false;
              });
            }
            if (keepOffset) {
              controller.jumpTo(
                -50,
              );
            }
            return false;
          },
          child: CustomScrollView(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                leading: const SizedBox(),
                backgroundColor: context.colors.backgroundsPrimary,
                centerTitle: true,
                title: SvgPicture.asset(
                  'assets/icons/logo.svg',
                  width: 30,
                ),
                floating: true,
                snap: true,
                elevation: 0,
                collapsedHeight: 42,
                toolbarHeight: 42,
                expandedHeight: 42,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Column(
                    children: [
                      FutureBuilder(
                        future: Future.delayed(const Duration(seconds: 2)),
                        builder: (context, snapshot) {
                          //TODO get from state holder that gets data from backend
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              index == 1) {
                            return PostBase(
                              multPost: MultiplePostModel(
                                name: 'Most Popular Movies',
                                imagePath: [
                                  'https://i.pinimg.com/originals/44/62/5b/44625b9914eb369e69f29a2be6ec4c96.jpg',
                                  'https://cdn11.bigcommerce.com/s-ydriczk/images/stencil/1280x1280/products/89058/93685/Joker-2019-Final-Style-steps-Poster-buy-original-movie-posters-at-starstills__62518.1669120603.jpg?c=2',
                                  'https://www.vintagemovieposters.co.uk/wp-content/uploads/2020/11/IMG_5878-scaled.jpeg',
                                  'https://i.ebayimg.com/images/g/v28AAOSwARljZQvF/s-l1600.jpg',
                                ],
                                author: UserModel(
                                  name: 'Bannon Morrissy',
                                  username: 'BannonMorissy',
                                  imagePath: index % 2 == 0
                                      ? 'https://ntvb.tmsimg.com/assets/assets/185244_v9_bb.jpg?w=270&h=360'
                                      : null,
                                  followed: index % 3 == 0,
                                ),
                                time: '11:11 PM',
                                description:
                                    'With the untimely death of his beloved wife still bitter in his mouth, John Wick, the expert former assassin, receives one final gift from hera precious keepsake to help John Wick.',
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return PostBase(
                              post: [
                                PostMovieModel(
                                  name: 'Star Wars',
                                  year: 1977,
                                  imagePath:
                                      'https://lwlies.com/wp-content/uploads/2017/05/US-900x0-c-default.jpg',
                                  author: UserModel(
                                    name: 'Bannon Morrissy',
                                    username: 'BannonMorissy',
                                    imagePath: index % 2 == 0
                                        ? 'https://ntvb.tmsimg.com/assets/assets/185244_v9_bb.jpg?w=270&h=360'
                                        : null,
                                    followed: index % 3 == 0,
                                  ),
                                  time: '12:31 PM',
                                  description: index % 2 == 0
                                      ? 'Star Wars (retroactively titled Star Wars: Episode IV – A New Hope) is a 1977 American epic space opera film written and directed by George Lucas, produced by Lucasfilm and distributed by 20th Century-Fox. It is the first film in the Star Wars film series and fourth chronological chapter of the "Skywalker Saga".Set "a long time ago" in a fictional universe where the galaxy is ruled by the tyrannical Galactic Empire, the story focuses on a group of freedom fighters known as the Rebel Alliance'
                                      : 'Great movie\nI loved it',
                                ),
                                if (index % 5 == 0)
                                  ...List.generate(
                                    10,
                                    (index) => PostMovieModel(
                                      name: 'Star Wars',
                                      year: 1977,
                                      imagePath:
                                          'https://lwlies.com/wp-content/uploads/2017/05/US-900x0-c-default.jpg',
                                      author: UserModel(
                                        name: 'Bannon Morrissy',
                                        username: 'BannonMorissy',
                                        imagePath: index % 2 == 0
                                            ? 'https://ntvb.tmsimg.com/assets/assets/185244_v9_bb.jpg?w=270&h=360'
                                            : null,
                                        followed: index % 3 == 0,
                                      ),
                                      time: '12:31 PM',
                                      description: 'Great movie\nI loved it',
                                    ),
                                  ),
                              ],
                            );
                          } else {
                            return PostBase();
                          }
                        },
                      ),
                      Divider(
                        color: context.colors.fieldsDefault,
                        height: 1,
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
