import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/edit_event_data_state.dart';

class EditEventStateNotifier extends StateNotifier<EditEventDataState> {
  EditEventStateNotifier(initialData)
      : super(EditEventDataState(editEventData: initialData));

  void update(EditEventDataState Function(EditEventDataState state) callback) {
    final updatedState = callback(state);
    state = updatedState.copyWith();
  }
}
