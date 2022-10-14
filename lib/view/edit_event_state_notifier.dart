import 'package:calendar_sample/model/event_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditEventStateNotifier extends StateNotifier<EditEventDataState> {
  EditEventStateNotifier(initialData)
      : super(EditEventDataState(editEventData: initialData));

  void update(EditEventDataState Function(EditEventDataState state) callback) {
    final updatedState = callback(state);
    state = updatedState.copyWith(isUpdated: true);
  }
}
