
import 'package:calendar_sample/model/event_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditEventDataNotifier extends StateNotifier<EditEventDataState>{
  EditEventDataNotifier(initialData)
      : super(EditEventDataState(editEventData: initialData));

  ///値の更新
  void updateTitle(String title) {
    final updateTitle = state.editEventData.copyWith(title: title);
    state = state.copyWith(isUpdated: true, editEventData: updateTitle);
  }

  void updateIsAllDay(bool isAllDay) {
    final updateIsAllDay = state.editEventData.copyWith(isAllDay: isAllDay);
    state = state.copyWith(isUpdated: true, editEventData: updateIsAllDay);
  }

  void updateStartTime(DateTime startTime) {
    final updateStartTime = state.editEventData.copyWith(startTime: startTime);
    state = state.copyWith(isUpdated: true, editEventData: updateStartTime);
  }

  void updateEndTime(DateTime endTime) {
    final updateEndTime = state.editEventData.copyWith(endTime: endTime);
    state = state.copyWith(isUpdated: true, editEventData: updateEndTime);
  }

  void updateComment(String comment) {
    final updateComment = state.editEventData.copyWith(comment: comment);
    state = state.copyWith(isUpdated: true, editEventData: updateComment);
  }
}