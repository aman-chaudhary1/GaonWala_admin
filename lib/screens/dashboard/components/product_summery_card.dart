import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utility/constants.dart';
import '../../../models/product_summery_info.dart';


class ProductSummeryCard extends StatelessWidget {
  const ProductSummeryCard({
    Key? key,
    required this.info, required this.onTap,
  }) : super(key: key);

  final ProductSummeryInfo info;
  final Function(String?) onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Reduce padding for smaller cards
        final isSmall = constraints.maxWidth < 150;
        final cardPadding = isSmall ? defaultPadding * 0.5 : defaultPadding;
        final iconSize = isSmall ? 30.0 : 40.0;
        final iconPadding = isSmall ? defaultPadding * 0.5 : defaultPadding * 0.75;

        return InkWell(
          onTap: () {
            onTap(info.title);
          },
          child: Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(iconPadding),
                      height: iconSize,
                      width: iconSize,
                      decoration: BoxDecoration(
                        color: info.color!.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: SvgPicture.asset(
                        info.svgSrc!,
                        colorFilter: ColorFilter.mode(
                            info.color ?? Colors.black, BlendMode.srcIn),
                      ),
                    ),
                    Icon(Icons.more_vert, 
                      color: Colors.white54,
                      size: isSmall ? 18 : 24,
                    )
                  ],
                ),
                SizedBox(height: cardPadding * 0.5),
                Flexible(
                  child: Text(
                    info.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmall ? 12 : null,
                    ),
                  ),
                ),
                SizedBox(height: cardPadding * 0.5),
                ProgressLine(
                  color: info.color,
                  percentage: info.percentage,
                ),
                SizedBox(height: cardPadding * 0.5),
                Text(
                  "${info.productsCount} Product",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(
                        color: Colors.white70,
                        fontSize: isSmall ? 10 : null,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final double? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
