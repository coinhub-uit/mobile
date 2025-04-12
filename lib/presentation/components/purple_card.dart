import "package:flutter/material.dart";

class PurpleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double iconSize;
  final double labelSize;
  final double arrowSize;
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final bool isTransferButton;
  const PurpleCard({
    super.key,
    required this.icon,
    required this.label,
    required this.iconSize,
    required this.labelSize,
    required this.arrowSize,
    this.paddingTop = 28,
    this.paddingBottom = 8,
    this.paddingLeft = 20,
    this.paddingRight = 12,
    this.isTransferButton = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration:
          !isTransferButton
              ? BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              )
              : BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.3, 0),
                  end: Alignment.centerRight,
                  colors: [
                    // Color.fromARGB(255, 83, 120, 224),
                    // Color.fromARGB(255, 83, 120, 224).withValues(),
                    Theme.of(context).colorScheme.secondary,
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple,
                  ],
                ),
                borderRadius:
                    !isTransferButton
                        ? BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        )
                        : BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          topLeft: Radius.circular(24),
                        ),
              ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            paddingLeft,
            paddingTop,
            paddingRight,
            paddingBottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !isTransferButton
                      ? Icon(
                        icon,
                        color: Theme.of(context).colorScheme.secondary,
                        size: iconSize,
                      )
                      : Icon(
                        icon,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: iconSize,
                      ),

                  !isTransferButton
                      ? Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: arrowSize,
                      )
                      : Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Theme.of(context).colorScheme.secondary,
                        size: arrowSize,
                      ),
                ],
              ),
              SizedBox(height: 4),
              !isTransferButton
                  ? Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: labelSize,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  )
                  : Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: labelSize,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
    // TODO: implement build
  }
}
