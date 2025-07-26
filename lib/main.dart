import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:powerbank_web_checkout/src/app.dart';
import 'package:powerbank_web_checkout/src/core/constants/constants.dart';
import 'package:powerbank_web_checkout/src/deep_links/deep_link_service.dart';
import 'package:powerbank_web_checkout/src/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants();
  await DependencyInjection.init();
  await EasyLocalization.ensureInitialized();

  final DeepLinkService deepLinkService = DeepLinkService();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', ''), Locale('ru', '')],
      path: 'resources/langs',
      fallbackLocale: const Locale('en', ''),
      child: MyApp(deepLinkService: deepLinkService),
    ),
  );
}
