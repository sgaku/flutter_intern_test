import 'package:calendar_sample/model/event_data.dart';
import 'package:calendar_sample/repository/event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/add_event_data_state.dart';

final addEventStateProvider =
    StateNotifierProvider.autoDispose<AddEventStateNotifier, AddEventDataState>(
        (ref) {
  return AddEventStateNotifier(ref);
});

class AddEventStateNotifier extends StateNotifier<AddEventDataState> {
  AddEventStateNotifier(this.ref)
      : super((const AddEventDataState(addEventData: null)));

  final Ref ref;

  ///値の追加
  Future<void> addEvents(EventData data) async {
    state = state.copyWith(addEventData: data);
    await ref.read(eventRepositoryProvider).addEvent(data);
  }
}
