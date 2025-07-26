part of 'deep_link_service.dart';

typedef DeepLinkEventListener = void Function(BuildContext context, DeepLinkEvent event);

class DeepLinkListener extends StatefulWidget {
  final DeepLinkEventListener listener;
  final Widget child;

  const DeepLinkListener({super.key, required this.listener, required this.child});

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  late final _service = context.read<DeepLinkService>();

  late StreamSubscription? _subscription;

  @override
  void initState() {
    _subscription = _service.stream.listen((event) {
      widget.listener(context, event);
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
