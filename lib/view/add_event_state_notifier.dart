import 'package:calendar_sample/common/main.dart';
import 'package:calendar_sample/model/event_data.dart';
import 'package:calendar_sample/repository/event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEventDataNotifier extends StateNotifier<AddEventDataState> {
  AddEventDataNotifier(this.ref)
      : super((const AddEventDataState(addEventData: null)));

  final Ref ref;

  ///値の追加
  addEvents(EventData data) {
    state = state.copyWith(addEventData: data);
    //TODO:driftにデータを追加
    ref.read(eventRepositoryProvider).addEvent(data);
  }
}
