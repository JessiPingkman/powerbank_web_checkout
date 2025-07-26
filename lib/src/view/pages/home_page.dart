import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:powerbank_web_checkout/src/deep_links/deep_link_service.dart';
import 'package:powerbank_web_checkout/src/view/routes/auto_router_config.gr.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DeepLinkListener(
      listener: (BuildContext context, DeepLinkEvent event) {
        ///station/RECH082203000350
        print('event is StationDeepLinkEvent: ${event is StationDeepLinkEvent}');
        if (event is StationDeepLinkEvent) {
          AutoRouter.of(context).push(PaymentRoute(stationId: event.stationId));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SvgPicture.asset('assets/icons/logo.svg'),
              ),
              Text('recharge.city', style: TextStyle(color: Color(0XFF1EE300))),
            ],
          ),
          centerTitle: false,
        ),
      ),
    );
  }
}
