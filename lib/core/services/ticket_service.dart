import "package:coinhub/core/constants/api_client.dart";
import "package:coinhub/models/ticket_model.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:printing/printing.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class TicketService {
  static final supabaseClient = Supabase.instance.client;

  static Future<http.Response> createTicket(TicketModel ticketModel) async {
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final url = Uri.parse("${ApiClient.ticketEndpoint}");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    final body = ticketModel.toJson();

    print("Creating ticket with data:");
    print("URL: $url");
    print("TicketModel: $ticketModel");
    print("JSON Body: $body");

    final response = await ApiClient.client.post(
      url,
      headers: headers,
      body: body,
    );

    // print("Create ticket response status: ${response.statusCode}");
    // print("Create ticket response body: ${response.body}");

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception("Failed to create ticket: ${response.statusCode}");
    }
  }

  static Future<http.Response> fetchTicket(String ticketId) async {
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final url = Uri.parse("${ApiClient.ticketEndpoint}/$ticketId");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    final response = await ApiClient.client.get(url, headers: headers);

    return response;
  }

  static Future<http.Response> withdrawTicket(int ticketId) async {
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    final url = Uri.parse("${ApiClient.ticketEndpoint}/$ticketId/withdraw");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    try {
      final response = await ApiClient.client.get(url, headers: headers);

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Failed to withdraw ticket: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error withdrawing ticket: $e");
      return Future.error("Failed to withdraw ticket: $e");
    }
  }

  static Future<http.Response> getSourceId(int ticketId) async {
    final session = supabaseClient.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null) {
      throw Exception("Session not found");
    }

    try {
      final response = await ApiClient.client.get(
        Uri.parse("${ApiClient.ticketEndpoint}/$ticketId/source"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Failed to fetch source ID: ${response.body}");
      }
    } catch (e) {
      print("Error fetching source ID: $e");
      return Future.error("Failed to fetch source ID: $e");
    }
  }

  // printing ticket
  static Future<void> exportTicketAsPdf(TicketModel ticket) async {
    final pdf = pw.Document();
    final currencyFormat = NumberFormat.currency(
      locale: "vi_VN",
      symbol: "đ",
      decimalDigits: 0,
    );
    final dateFormat = DateFormat("dd/MM/yyyy");

    final history =
        ticket.ticketHistory?.isNotEmpty == true
            ? ticket.ticketHistory![0]
            : null;

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Align(
            alignment: pw.Alignment.topCenter,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Ticket Summary",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 24),
                _infoRow("Ticket ID", ticket.id.toString()),
                _infoRow(
                  "Principal",
                  currencyFormat.format(history?.principal ?? 0),
                ),
                _infoRow(
                  "Interest",
                  currencyFormat.format(history?.interest ?? 0),
                ),
                _infoRow(
                  "Issued At",
                  history != null
                      ? dateFormat.format(history.issuedAt!)
                      : "N/A",
                ),
                _infoRow(
                  "Matured At",
                  history?.maturedAt.toString().split(" ")[0] == "9999-12-31"
                      ? "PR"
                      : history != null
                      ? dateFormat.format(history.maturedAt!)
                      : "N/A",
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 100,
            child: pw.Text(
              "$label:",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }
}
