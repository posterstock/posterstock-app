import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ChoosePosterTile extends StatefulWidget {
  const ChoosePosterTile(
      {Key? key,
      required this.index,
      required this.imagePath,
      required this.name,
      required this.year})
      : super(key: key);
  final int index;
  final String imagePath;
  final String name;
  final String year;

  @override
  State<ChoosePosterTile> createState() => _ChoosePosterTileState();
}

class _ChoosePosterTileState extends State<ChoosePosterTile> {
  bool chosen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            chosen = !chosen;
            setState(() {});
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  color: context.colors.backgroundsSecondary,
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Transform.scale(
                    scale: 1.2,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      color: chosen
                          ? context.colors.backgroundsPrimary
                          : context.colors.textsBackground!.withOpacity(0.4),
                      child: chosen
                          ? SvgPicture.asset('assets/icons/ic_check.svg')
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption2!.copyWith(
            color: context.colors.textsPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.year,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.caption1!.copyWith(
            color: context.colors.textsDisabled,
          ),
        ),
      ],
    );
  }
}
