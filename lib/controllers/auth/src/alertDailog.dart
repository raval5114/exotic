import 'package:flutter/material.dart';

/// Alert types
enum AlertType { success, error, warning }

void showCustomAlertBox({
  required BuildContext context,
  required String message,
  required List<String>? errors,
  AlertType type = AlertType.error,
  required VoidCallback onOkay,
}) {
  late Color bgColor;
  late Color iconColor;
  late IconData icon;

  switch (type) {
    case AlertType.success:
      bgColor = Colors.green.shade50;
      iconColor = Colors.green;
      icon = Icons.check_circle_outline;
      break;

    case AlertType.warning:
      bgColor = Colors.orange.shade50;
      iconColor = Colors.orange;
      icon = Icons.warning_amber_rounded;
      break;

    case AlertType.error:
      break;

    default:
      bgColor = Colors.red.shade50;
      iconColor = Colors.red;
      icon = Icons.error_outline;
      break;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ICON
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 34),
                  ),
                ),

                const SizedBox(height: 16),

                /// MAIN MESSAGE
                Center(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                /// ERROR LIST
                if (errors != null && errors.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        errors.map((error) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("•  "),
                                Expanded(
                                  child: Text(
                                    error,
                                    style: TextStyle(
                                      fontFamily: "NunitoSans",
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ],

                const SizedBox(height: 24),

                /// OK BUTTON
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: onOkay,
                    child: Text(
                      'Okay',
                      style: TextStyle(
                        fontFamily: "NunitoSans",
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// void showCustomDialog({
//   required BuildContext context,
//   required Map<String, dynamic> message,
//   required VoidCallback onOkay,
// }) {
//   showDialog(
//     context: context,
//     builder:
//         (context) => Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 24.0,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Circular icon container
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.pink[50],
//                     shape: BoxShape.circle,
//                   ),
//                   padding: const EdgeInsets.all(12),
//                   child: const Icon(
//                     Icons.error_outline,
//                     color: Colors.pink,
//                     size: 32,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Message Text
//                 Text(
//                   "${message['message']}.",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.raleway(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 // Okay button
//                 SizedBox(
//                   width: double.infinity,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     onPressed: onOkay,
//                     child: Text(
//                       'Okay',
//                       style: GoogleFonts.nunitoSans(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//   );
// }
