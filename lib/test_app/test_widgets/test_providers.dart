import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snackautomat_bene_alex/mid_layer/notifiers/inventory_notifier.dart';

final inventoryProvider = AsyncNotifierProvider(() => InventoryNotifier());
