import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CurrentPostShower extends StatelessWidget {
  const CurrentPostShower({
    Key? key,
    required this.current,
    required this.length,
    this.swipedRight = true,
  }) : super(key: key);
  final int current;
  final int length;
  final bool swipedRight;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    return Row(
      children: List.generate(length, (index) {
        double? width;
        double translation = 0;
        translation = (current - 2) * 3.9;
        if (translation < 0) translation = 0;
        if (current == 0) {
          if (index == 4) width = 2;
          if (index == 3) width = 4;
        } else if (current == 1) {
          if (index == 3) width = 8;
          if (index == 4) width = 4;
        } else if (current == length - 1) {
          if (index == length - 4) width = 4;
          if (index == length - 5) width = 2;
        } else if (current == length - 2) {
          if (index == length - 4) width = 8;
          if (index == length - 5) width = 4;
        } else {
          if (index == current - 2) width = 4;
          if (index == current + 2) width = 4;
        }
        width ??= (current - index).abs() > 2 ? 0 : 8;
        return Row(
          children: [
            const SizedBox(width: 4),
            AnimatedContainer(
              transform: Matrix4(
                1,0,0,0,
                0,1,0,0,
                0,0,1,0,
                -translation,0,0,1,
              ),
              duration: duration,
              width: width,
              height: width,
              decoration: BoxDecoration(
                color: index == current
                    ? context.colors.iconsActive
                    : context.colors.iconsDisabled,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      }),
    );
  }
}
