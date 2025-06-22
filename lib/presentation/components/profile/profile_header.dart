import "package:coinhub/core/util/env.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/models/user_model.dart";

class ProfileHeader extends StatelessWidget {
  final UserModel model;
  final String userEmail;

  const ProfileHeader({
    super.key,
    required this.model,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Avatar with edit button
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Center(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.primaryColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withAlpha(51),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: theme.colorScheme.surface.withAlpha(128),
                    backgroundImage:
                        (model.avatar != null && model.avatar!.isNotEmpty)
                            ? NetworkImage(
                              "${Env.apiServerUrl}/users/${model.id}/avatar?${DateTime.now().millisecondsSinceEpoch}",
                            )
                            : const AssetImage("assets/images/CoinHub.png"),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<UserBloc>(
                        context,
                      ).add(UpdateAvatarSubmitted(model.id));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // User Name Display
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(model.fullName, style: theme.textTheme.headlineSmall),
        ),

        // User Email Display
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Text(
            userEmail,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ),
      ],
    );
  }
}
