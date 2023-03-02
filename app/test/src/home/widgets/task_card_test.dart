import 'package:flutter_test/flutter_test.dart';
import 'package:listinha/src/home/widgets/task_card.dart';
import 'package:listinha/src/shared/services/realm/models/task_model.dart';
import 'package:realm/realm.dart';

void main() {
  testWidgets('task card ...', (tester) async {
    final tasks = [
      TaskModel(Uuid.v4(), '', completed: true),
      TaskModel(Uuid.v4(), '', completed: true),
      TaskModel(Uuid.v4(), ''),
      TaskModel(Uuid.v4(), ''),
    ];

    final board = TaskBoardModel(Uuid.v4(), '', tasks: tasks);
    final card = TaskCard(board: board);

    expect(card.getProgress(tasks), 0.5);
  });
}
