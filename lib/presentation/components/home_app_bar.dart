import "package:flutter/material.dart";

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? imgUrl;
  final String userName;
  const HomeAppBar({super.key, this.imgUrl, required this.userName});
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 24,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        SizedBox(width: 20),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              imgUrl != null
                  ? CircleAvatar(
                    radius: 27,
                    backgroundImage:
                        imgUrl!.isNotEmpty
                            ? NetworkImage(imgUrl!)
                            : AssetImage("assets/images/CoinHub.png")
                                as ImageProvider,
                  )
                  : const SizedBox.shrink(),
              SizedBox(width: 10),
              Text(
                "Hello,",
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              SizedBox(width: 10),
              Text(
                userName,
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
