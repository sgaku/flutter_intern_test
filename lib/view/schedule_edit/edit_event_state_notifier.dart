import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/edit_event_data_state.dart';
import '../../model/event_data.dart';

final editEventStateProviderFamily = StateNotifierProvider.autoDispose
    .family<EditEventStateNotifier, EditEventDataState, EventData>(
        (ref, eventData) {
  return EditEventStateNotifier(eventData);
});

final editEventStateProvider = StateNotifierProvider.autoDispose<
    EditEventStateNotifier,
    EditEventDataState>((ref) => throw UnimplementedError());

class EditEventStateNotifier extends StateNotifier<EditEventDataState> {
  EditEventStateNotifier(initialData)
      : super(EditEventDataState(editEventData: initialData));

  void update(EditEventDataState Function(EditEventDataState state) callback) {
    final updatedState = callback(state);
    state = updatedState.copyWith();
  }
}
