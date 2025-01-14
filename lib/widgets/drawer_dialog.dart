import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:healer_therapist/constants/colors.dart';
import 'package:healer_therapist/widgets/dialog_button.dart';

class DrawerDialoge extends StatelessWidget {
  DrawerDialoge({super.key, this.radius = 8, required this.mdFileName})
      : assert(mdFileName.contains('.md'));
  final double radius;
  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: white,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future:
                Future.delayed(const Duration(milliseconds: 150)).then((value) {
              return rootBundle.loadString(
                "asset/$mdFileName",
              );
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Markdown(
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(color: textColor),
                    h1: const TextStyle(color: textColor),
                    h2: const TextStyle(color: textColor),
                    h3: const TextStyle(color: textColor),
                    h4: const TextStyle(color: textColor),
                    h5: const TextStyle(color: textColor),
                    h6: const TextStyle(color: textColor),
                    strong: const TextStyle(color: textColor),
                    em: const TextStyle(color: textColor),
                    code: const TextStyle(color: textColor),
                    blockquote: const TextStyle(color: textColor),
                  ),
                  data: snapshot.data!,
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )),
          SizedBox(
            width: 300,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: buildButton(text: 'Close'),
            )
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
