part of 'deep_link_service.dart';

abstract class DeepLinkEvent {
  const factory DeepLinkEvent.products({required final String slug}) = ProductsDeepLinkEvent;
}

class ProductsDeepLinkEvent implements DeepLinkEvent {
  final String slug;

  const ProductsDeepLinkEvent({required this.slug});
}
