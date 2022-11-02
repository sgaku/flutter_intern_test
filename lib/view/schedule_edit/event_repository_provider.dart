import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repository/event_repository.dart';

final eventRepositoryProvider = Provider((ref) => EventRepository(ref));