import 'package:freezed_annotation/freezed_annotation.dart';

import 'event_data.dart';

part 'edit_event_data_state.freezed.dart';

@freezed
class EditEventDataState with _$EditEventDataState {
  const factory EditEventDataState({
    @Default(false) bool isUpdated,
    required EventData editEventData,
  }) = _EditEventDataState;
}
