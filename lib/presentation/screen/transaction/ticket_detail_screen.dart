import "package:coinhub/core/bloc/source/source_logic.dart";
import "package:coinhub/core/services/ticket_service.dart";
import "package:coinhub/models/plan_model.dart";
import "package:coinhub/models/ticket_model.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:go_router/go_router.dart";
import "package:intl/intl.dart";

class TicketDetailsScreen extends StatefulWidget {
  final TicketModel ticketModel;
  final PlanModel planModel;
  const TicketDetailsScreen({
    super.key,
    required this.ticketModel,
    required this.planModel,
  });

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final currencyFormat = NumberFormat.currency(
      locale: "vi_VN",
      symbol: "đ",
      decimalDigits: 0,
    );

    return BlocConsumer<SourceBloc, SourceState>(
      listener: (context, state) {
        if (state is SourceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is SourceDeletedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Ticket withdrawn successfully"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          context.pop(true);
        }
      },
      builder: (context, state) {
        if (state is SourceLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            title: Text(
              "Ticket's Details",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(51),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.calendar_view_day_sharp,
                            color: theme.primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Check your ticket's details",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Or withdraw to boost your balance.",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    179,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Source ID:",
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    theme.dividerTheme.color ??
                                    Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.card_membership_rounded,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  widget.ticketModel.source!.id.toString(),
                                  style: theme.textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "For:",
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    theme.dividerTheme.color ??
                                    Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.alarm_outlined,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  widget.planModel.days == -1
                                      ? "Flexible Saving"
                                      : widget.planModel.days / 30 > 1
                                      ? "${widget.planModel.days ~/ 30} months"
                                      : "${widget.planModel.days} days",
                                  style: theme.textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Start Date:",
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    theme.dividerTheme.color ??
                                    Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.alarm_outlined,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  widget.ticketModel.openedAt != null
                                      ? DateFormat(
                                        "dd/MM/yyyy",
                                      ).format(widget.ticketModel.openedAt!)
                                      : "N/A",
                                  style: theme.textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Mature Date:",
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    theme.dividerTheme.color ??
                                    Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.alarm_outlined,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  widget.ticketModel.ticketHistory![0].maturedAt
                                              .toString()
                                              .split(" ")[0] ==
                                          "9999-12-31"
                                      ? "Ongoing"
                                      : widget
                                              .ticketModel
                                              .ticketHistory![0]
                                              .maturedAt !=
                                          null
                                      ? DateFormat("dd/MM/yyyy").format(
                                        widget
                                            .ticketModel
                                            .ticketHistory![0]
                                            .maturedAt!,
                                      )
                                      : "N/A",
                                  style: theme.textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Method:",
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    theme.dividerTheme.color ??
                                    Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.alarm_outlined,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    widget.ticketModel.method == "NR"
                                        ? "Principal and Interest Renewal"
                                        : widget.ticketModel.method == "PR"
                                        ? "Principal Renewal"
                                        : "Principal and Interest Renewal",
                                    style: theme.textTheme.headlineSmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Initial Amount:",
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    theme.dividerTheme.color ??
                                    Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_money_outlined,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  currencyFormat.format(
                                    widget
                                        .ticketModel
                                        .ticketHistory![0]
                                        .principal,
                                  ),
                                  style: theme.textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Interest:",
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    theme.dividerTheme.color ??
                                    Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_money_outlined,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  widget
                                              .ticketModel
                                              .ticketHistory![0]
                                              .interest !=
                                          null
                                      ? currencyFormat.format(
                                        widget
                                            .ticketModel
                                            .ticketHistory![0]
                                            .interest!,
                                      )
                                      : "0",
                                  style: theme.textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Rate:",
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    theme.dividerTheme.color ??
                                    Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_drop_up_rounded,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "${widget.planModel.rate} %",
                                  style: theme.textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Withdrawing ticket..."),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.blue,
                          ),
                        );
                        try {
                          await TicketService.withdrawTicket(
                            widget.ticketModel.id!,
                          );
                          await TicketService.exportTicketAsPdf(
                            widget.ticketModel,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        context.pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Withdraw Ticket",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
