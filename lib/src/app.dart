import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:powerbank_web_checkout/src/view/routes/auto_router_config.dart';
import 'package:provider/provider.dart';

import 'deep_links/deep_link_service.dart';

class MyApp extends StatelessWidget {
  final DeepLinkService deepLinkService;

  const MyApp({required this.deepLinkService, super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => deepLinkService..handleInitialUrl(),
      child: Builder(
        builder:
            (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: MaterialApp.router(
                title: 'rent-power-bank',
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.light,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                routerConfig: AppRouter().config(),
              ),
            ),
      ),
    );
  }
}
