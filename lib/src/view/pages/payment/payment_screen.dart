import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class PaymentScreen extends StatefulWidget {
  final String stationId;

  const PaymentScreen({required this.stationId, super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rent a Charger', style: TextStyle(fontSize: 26, color: Colors.black)),
            Text('4.99', style: TextStyle(fontSize: 38, color: Colors.black)),
            Text('Select Payment Method', style: TextStyle(fontSize: 20, color: Colors.black)),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.apple), Text('Pay')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
