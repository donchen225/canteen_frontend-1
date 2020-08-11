import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static Future<void> onOpen(LinkableElement link) async {
    // TODO: remove this hack once FlutterLinkify improves RegEx
    final url = link.url.replaceAll(RegExp(r"\,[^]*"), "");

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
