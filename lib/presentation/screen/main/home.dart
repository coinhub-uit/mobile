import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/core/constants/theme.dart";
import "package:coinhub/core/services/user_service.dart";
import "package:coinhub/models/source_model.dart";
import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/screen/main/profile_screen.dart";
import "package:coinhub/presentation/screen/main/saving_screen.dart";
import "package:flutter/material.dart";
import "package:coinhub/core/services/auth_service.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = "temporaryId";
  int _selectedIndex = 0;
  UserModel? userModel;
  String? userEmail;
  bool get isUserLoaded => userModel != null && userModel!.id != "temporaryId";

  List<Widget> get _screens => [
    if (userModel != null) ...[
      HomeScreenContent(model: userModel!),
      SavingsScreen(model: userModel!),
      ProfileScreen(
        model: userModel!,
        userEmail: userEmail!,
        onUserUpdated: (updatedUser) {
          setState(() {
            userModel = updatedUser;
          });
        },
      ),
    ] else ...[
      const Center(child: CircularProgressIndicator()),
    ],
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0 && isUserLoaded) {
      BlocProvider.of<UserBloc>(context).add(SourcesFetching(userId));
    }
  }

  Future<UserModel?> getUserModel(String id) async {
    try {
      return await UserService.getUser(id);
    } catch (error) {
      debugPrint("Error fetching user: $error");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // auth
    AuthService.authStateChanges.listen((data) async {
      final id = data.session?.user.id;
      final email = data.session?.user.email;

      if (email != null) {
        setState(() {
          userEmail = email;
        });
      }

      if (id != null) {
        setState(() {
          userId = id;
        });

        final model = await getUserModel(id);
        setState(() {
          userModel = model;
        });
        BlocProvider.of<UserBloc>(context).add(SourcesFetching(userId));
      } else {
        debugPrint("User not logged in.");
      }
    });

    // source
  }

  @override
  Widget build(BuildContext context) {
    if (!isUserLoaded) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: onItemTapped,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(
            context,
          ).colorScheme.onSurface.withAlpha(153),
          selectedLabelStyle: Theme.of(context).textTheme.labelMedium,
          unselectedLabelStyle: Theme.of(context).textTheme.labelSmall,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.wallet),
              label: "Savings",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userLarge),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

// Home screen content
class HomeScreenContent extends StatelessWidget {
  final UserModel model;
  const HomeScreenContent({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: "vi_VN",
      symbol: "đ",
      decimalDigits: 0,
    );

    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar with User Info
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: _buildAppBar(context),
              ),

              const SizedBox(height: 32),

              // Balance Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildBalanceCard(context, currencyFormat),
              ),

              const SizedBox(height: 40),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildActionButtons(context, screenSize),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome,",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(179),
              ),
            ),
            const SizedBox(height: 4),
            Text(model.fullName, style: theme.textTheme.titleLarge),
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: theme.colorScheme.onSurface.withAlpha(179),
                  size: 24,
                ),
                onPressed: () {
                  context.push(Routes.notifications, extra: model.id);
                },
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.surface,
              backgroundImage:
                  (model.avatar != null && model.avatar!.isNotEmpty)
                      ? NetworkImage(model.avatar!)
                      : const AssetImage("assets/images/CoinHub.png")
                          as ImageProvider,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context, NumberFormat currencyFormat) {
    final theme = Theme.of(context);

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is SourcesError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        if (state is SourcesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SourcesError) {
          return Center(child: Text(state.error));
        }
        if (state is SourcesFetchedSuccess) {
          final List<SourceModel> sources = state.sources;
          if (sources.isEmpty) {
            return GestureDetector(
              onTap: () async {
                final reload = await context.push(Routes.transaction.addSource);
                if (reload == true) {
                  BlocProvider.of<UserBloc>(
                    context,
                  ).add(SourcesFetching(model.id));
                }
              },
              child: SizedBox(
                height: 210,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.88,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withBlue(255),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withAlpha(77),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Track your finances now by",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Add your first source!",
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(26),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.add_circle_outlined,
                                    color: Color(0xFF10B981),
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return SizedBox(
            height: 210,
            child: PageView.builder(
              itemCount: sources.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final source = sources[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == sources.length - 1 ? 0 : 8,
                    left: index == 0 ? 0 : 8,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final reload = await context.push(
                        Routes.transaction.sourceDetails,
                        extra: source,
                      );
                      if (reload == true) {
                        BlocProvider.of<UserBloc>(
                          context,
                        ).add(SourcesFetching(model.id));
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.88,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primaryColor,
                            theme.primaryColor.withBlue(255),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withAlpha(77),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            source.id,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Balance",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withAlpha(204),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currencyFormat.format(int.parse(source.balance!)),
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  sources.length > 1 &&
                                          index < sources.length - 1
                                      ? Icons.arrow_right_rounded
                                      : null,
                                  color: Color(0xFF10B981),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  sources.length > 1 &&
                                          index < sources.length - 1
                                      ? "Swipe left to see other sources"
                                      : "",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withAlpha(204),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        // Default return to satisfy non-nullable return type
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, Size screenSize) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Actions", style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),

        // First row of buttons
        Row(
          children: [
            _buildActionButton(
              context,
              icon: Icons.arrow_downward_rounded,
              label: "Deposit",
              color: const Color(0xFF10B981),
              width: (screenSize.width - 56) / 2,
              onTap: () async {
                final reload = await context.push(
                  Routes.transaction.deposit,
                  extra: model,
                );
                if (reload == true) {
                  BlocProvider.of<UserBloc>(
                    context,
                  ).add(SourcesFetching(model.id));
                }
              },
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              context,
              icon: Icons.add_card_rounded,
              label: "Add New Source",
              color: theme.colorScheme.onSurface.withAlpha(153),
              width: (screenSize.width - 56) / 2,
              onTap: () async {
                final reload = await context.push(Routes.transaction.addSource);
                if (reload == true) {
                  BlocProvider.of<UserBloc>(
                    context,
                  ).add(SourcesFetching(model.id));
                }
              },
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Second row of buttons
        Row(
          children: [
            _buildActionButton(
              context,
              icon: Icons.savings_outlined,
              label: "New Saving Plan",
              color: const Color(0xFF8B5CF6),
              width: (screenSize.width - 56) / 2,
              onTap: () async {
                final reload = await context.push(
                  Routes.transaction.savingPlan,
                  extra: model,
                );
                if (reload == true) {
                  BlocProvider.of<UserBloc>(
                    context,
                  ).add(SourcesFetching(model.id));
                }
              },
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              context,
              icon: Icons.swap_horiz_rounded,
              label: "Transfer",
              color: AppTheme.accentCopper,
              width: (screenSize.width - 56) / 2,
              onTap: () async {
                final reload = await context.push(
                  Routes.transaction.transfer,
                  extra: model,
                );
                if (reload == true) {
                  BlocProvider.of<UserBloc>(
                    context,
                  ).add(SourcesFetching(model.id));
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required double width,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerTheme.color!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(label, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
