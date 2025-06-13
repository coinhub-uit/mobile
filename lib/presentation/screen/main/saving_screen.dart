import "package:coinhub/core/bloc/user/user_logic.dart";
import "package:coinhub/core/services/plan_service.dart";
import "package:coinhub/models/plan_model.dart";
import "package:coinhub/models/source_model.dart";
import "package:coinhub/models/ticket_model.dart";
import "package:coinhub/models/user_model.dart";
import "package:coinhub/presentation/routes/routes.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class SavingsScreen extends StatefulWidget {
  final UserModel model;
  const SavingsScreen({super.key, required this.model});
  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  late List<TicketModel> tickets = [];
  late List<TicketModel> allTickets = [];

  late List<PlanModel> plans = [];
  late List<SourceModel> sources = [];

  bool _ticketsReady = false;
  bool _sourcesReady = false;

  Future<void> _fetchPlans() async {
    final fetchedPlans = await PlanService.fetchPlans();
    setState(() {
      plans = fetchedPlans;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch tickets when the screen is initialized
    context.read<UserBloc>().add(TicketsFetching(widget.model.id));
    context.read<UserBloc>().add(SourcesFetching(widget.model.id));
    // Fetch plans when the screen is initialized
    _fetchPlans();
  }

  void _sortByTime() {
    setState(() {
      tickets.sort((a, b) {
        if (a.openedAt == null || b.openedAt == null) return 0;
        return a.openedAt!.compareTo(b.openedAt!);
      });
    });
  }

  void _filterBySource(String sourceId) {
    setState(() {
      tickets =
          allTickets.where((ticket) => ticket.sourceId == sourceId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: "vi_VN",
      symbol: "đ",
      decimalDigits: 0,
    );

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is TicketFetchedSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              allTickets = List.from(state.tickets);
              tickets = List.from(state.tickets);
              _ticketsReady = true;
            });
          });
        } else if (state is SourcesFetchedSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              sources = state.sources;
              _sourcesReady = true;
            });
          });
        } else if (state is TicketError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error fetching: ${state.error}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        // print("Current ticket: $tickets");
        // print("Current sources: $sources");

        int totalInterest = 0;
        int totalPrincipal = 0;

        for (var ticket in tickets) {
          if (ticket.status != "active" &&
              ticket.ticketHistory != null &&
              ticket.ticketHistory!.isNotEmpty) {
            totalInterest += ticket.ticketHistory![0].interest?.toInt() ?? 0;
            totalPrincipal += ticket.ticketHistory![0].principal?.toInt() ?? 0;
          }
        }

        final overAllRate =
            totalPrincipal == 0
                ? 0
                : ((totalInterest / totalPrincipal) * 100).round();
        final overAllPrincipal = totalPrincipal;

        if (state is TicketError) {
          return Center(child: Text("Error: ${state.error}"));
        }
        if (!_ticketsReady || !_sourcesReady) {
          return const Center(child: CircularProgressIndicator());
        }
        // if (tickets.isEmpty && sources.isNotEmpty ||
        //     sources.isEmpty && tickets.isNotEmpty) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            title: Text("Tickets", style: theme.textTheme.titleLarge),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
          ),
          body: Column(
            children: [
              // Savings Summary Card
              (sources.isNotEmpty && _sourcesReady)
                  ? SizedBox(
                    height: 260,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sources.length,

                      itemBuilder: (context, index) {
                        final activePlans =
                            tickets
                                .where(
                                  (ticket) =>
                                      ticket.sourceId == sources[index].id,
                                )
                                .toList();
                        return GestureDetector(
                          onTap: () async {
                            final reload = await context.push(
                              Routes.transaction.sourceDetails,
                              extra: sources[index],
                            );
                            if (reload == true) {
                              // ignore: use_build_context_synchronously
                              context.read<UserBloc>().add(
                                TicketsFetching(widget.model.id),
                              );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 48,
                            margin: const EdgeInsets.fromLTRB(24, 24, 24, 16),
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
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.primaryColor.withAlpha(51),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sources[index].id,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Savings:",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(51),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.arrow_upward,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            currencyFormat.format(
                                              overAllPrincipal,
                                            ),
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  currencyFormat.format(
                                    int.parse(sources[index].balance ?? "0"),
                                  ),
                                  style: theme.textTheme.headlineLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSummaryItem(
                                      context,
                                      icon: Icons.account_balance,
                                      label: "Active Plans",
                                      value: "${activePlans.length}",
                                    ),
                                    _buildSummaryItem(
                                      context,
                                      icon: Icons.trending_up,
                                      label: "Avg. Interest",
                                      value: "$overAllRate%",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  : (sources.isEmpty && _sourcesReady)
                  ? GestureDetector(
                    onTap: () async {
                      final reload = await context.push(
                        Routes.transaction.addSource,
                        extra: widget.model,
                      );
                      if (reload == true) {
                        // ignore: use_build_context_synchronously
                        context.read<UserBloc>().add(
                          TicketsFetching(widget.model.id),
                        );
                      }
                    },
                    child: SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 48,
                        margin: const EdgeInsets.fromLTRB(24, 24, 24, 16),
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
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withAlpha(51),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Track your finances now!",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(51),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "By adding a new source",
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  )
                  : const Center(child: CircularProgressIndicator()),

              // Savings Plans List Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your Tickets", style: theme.textTheme.titleLarge),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.access_time),
                                      title: const Text(
                                        "Sort by Creation Time",
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _sortByTime();
                                      },
                                    ),
                                    const Divider(),
                                    ...sources.map((source) {
                                      return ListTile(
                                        leading: const Icon(
                                          Icons.account_balance_wallet,
                                        ),
                                        title: Text(
                                          "Filter by Source: ${source.id}",
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _filterBySource(source.id);
                                        },
                                      );
                                    }),
                                    ListTile(
                                      leading: const Icon(Icons.clear),
                                      title: const Text("Show All Tickets"),
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          tickets = List.from(allTickets);
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },

                          icon: const Icon(Icons.sort, size: 18),
                          label: const Text("Sort"),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.primaryColor,
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                          ),
                        ),
                        IconButton(
                          onPressed:
                              () =>
                                  context.read<UserBloc>()
                                    ..add(TicketsFetching(widget.model.id))
                                    ..add(SourcesFetching(widget.model.id)),
                          icon: const Icon(Icons.refresh, size: 20),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.primaryColor,
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Savings Plans List
              Expanded(
                child:
                    (tickets.isNotEmpty && _ticketsReady)
                        ? ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: tickets.length,
                          itemBuilder: (context, index) {
                            final start = tickets[index].openedAt!;
                            final end =
                                tickets[index].ticketHistory?.isNotEmpty == true
                                    ? tickets[index].ticketHistory![0].maturedAt
                                    : null;
                            final now = DateTime.now();
                            final planId = tickets[index].plan?.planId;
                            // print("Ticket: $tickets");
                            // print("Matching planId: $_planId");

                            // print(plans);
                            final plan = plans.firstWhere(
                              (p) => p.planId == planId,
                              orElse:
                                  () => PlanModel(planId: -1, days: 0, rate: 0),
                            );
                            final rate = plan.rate;

                            double progress =
                                end != null
                                    ? now.isBefore(start)
                                        ? 0.0
                                        : now.isAfter(end)
                                        ? 1.0
                                        : now.difference(start).inMilliseconds /
                                            end.difference(start).inMilliseconds
                                    : 1;
                            return tickets[index].status == "active"
                                ? _buildSavingsPlanCard(
                                  context,
                                  index: index + 1,
                                  moneyInit:
                                      tickets[index].ticketHistory![0].principal
                                          ?.toInt() ??
                                      0,
                                  profit:
                                      tickets[index].ticketHistory![0].interest
                                          ?.toInt() ??
                                      0,
                                  profitPercentage: rate,
                                  startDate: DateFormat(
                                    "dd/MM/yyyy",
                                  ).format(tickets[index].openedAt!),
                                  endDate:
                                      tickets[index].ticketHistory![0].maturedAt
                                                  .toString()
                                                  .split(" ")[0] ==
                                              "9999-12-31"
                                          ? "Ongoing"
                                          : DateFormat("dd/MM/yyyy").format(
                                            tickets[index]
                                                .ticketHistory![0]
                                                .maturedAt!,
                                          ),
                                  progress: progress.clamp(
                                    0.0,
                                    1.0,
                                  ), // Simulated progress values
                                  ticket: tickets[index],
                                  plan: plan,
                                )
                                : null;
                          },
                        )
                        : tickets.isEmpty && _ticketsReady
                        ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "No tickets found. Start saving now!",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        )
                        : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final reload = await context.push(
                Routes.transaction.savingPlan,
                extra: widget.model,
              );
              if (reload == true) {
                // ignore: use_build_context_synchronously
                context.read<UserBloc>().add(TicketsFetching(widget.model.id));
              }
            },
            backgroundColor: theme.primaryColor,
            elevation: 4,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withAlpha(204),
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavingsPlanCard(
    BuildContext context, {
    required int index,
    required int moneyInit,
    required int profit,
    required double profitPercentage,
    required String startDate,
    required String endDate,
    required double progress,
    required TicketModel ticket,
    required PlanModel plan,
  }) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: "vi_VN",
      symbol: "đ",
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(64),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final reload = await context.push(
              Routes.transaction.ticketDetail,
              extra: {"ticket": ticket, "plan": plan},
            );
            if (reload == true) {
              // ignore: use_build_context_synchronously
              context.read<UserBloc>().add(TicketsFetching(widget.model.id));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Ticket #$index",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: Colors.green[700],
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$profitPercentage%",
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Initial Amount",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          currencyFormat.format(moneyInit),
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Expected Return",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          currencyFormat.format(profit),
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withAlpha(26),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 8,
                      width: MediaQuery.of(context).size.width * progress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primaryColor,
                            theme.primaryColor.withBlue(255),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: theme.colorScheme.onSurface.withAlpha(153),
                        ),
                        const SizedBox(width: 4),
                        Text(startDate, style: theme.textTheme.bodySmall),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.event_outlined,
                          size: 12,
                          color: theme.colorScheme.onSurface.withAlpha(153),
                        ),
                        const SizedBox(width: 4),
                        Text(endDate, style: theme.textTheme.bodySmall),
                      ],
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
}
