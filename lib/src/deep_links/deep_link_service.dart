import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'deep_link_event.dart';

part 'deep_link_listener.dart';

class DeepLinkService {
  static const _productsPath = 'products';

  static bool _isInitialUrlHandled = false;

  final _eventHandler = StreamController<DeepLinkEvent>.broadcast();

  late final AppLinks _appLinks;

  Stream<DeepLinkEvent> get stream => _eventHandler.stream;

  StreamSubscription? _uriListener;

  void dispose() {
    _eventHandler.close();
    _uriListener?.cancel();
  }

  Future<void> handleInitialUrl() async {
    try {
      if (_isInitialUrlHandled) {
        return;
      }
      final initialUri = await _appLinks.getInitialLink();
      _listenForChange();

      if (initialUri == null) {
        return;
      }

      _parseUri(initialUri);
    } on PlatformException catch (_, __) {
      // Platform messages may fail but we ignore the exception
      /// TODO: PlatformException logic
    } on FormatException catch (_, __) {
      /// TODO: FormatException logic
    } finally {
      _isInitialUrlHandled = true;
    }
  }

  void _listenForChange() {
    _uriListener = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri == null) {
        return;
      }

      _parseUri(uri);
    });
  }

  void _parseUri(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      return;
    }

    /// Product detail deeplink looks like [https://asia.kg/products/product-slug]
    if (uri.pathSegments.first == _productsPath) {
      final slug = uri.pathSegments.last;

      _eventHandler.add(ProductsDeepLinkEvent(slug: slug));
    }
  }
}
