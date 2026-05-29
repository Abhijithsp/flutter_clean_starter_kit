import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/shop_order.dart';

part 'order_history_state.freezed.dart';

@freezed
abstract class OrderHistoryState with _$OrderHistoryState {
  const factory OrderHistoryState({
    @Default([]) List<ShopOrder> orders,
  }) = _OrderHistoryState;
}
