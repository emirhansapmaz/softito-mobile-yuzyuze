import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge_platform/features/programlar/controller/program_controller.dart';
import 'package:yorunge_platform/features/programlar/models/program_model.dart';

void main() {
  group('ProgramController Unit Tests', () {
    late ProgramController controller;

    setUp(() {
      controller = ProgramController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta tam 15 adet destek programı yüklenmelidir', () {
      expect(controller.programlarNotifier.value.length, equals(15));
    });

    test('Her bir kategoride tam 3 program olmalıdır (5 x 3 = 15)', () {
      final list = controller.programlarNotifier.value;
      expect(list.where((p) => p.category == 'Hibe').length, equals(3));
      expect(list.where((p) => p.category == 'Devlet Desteği').length, equals(3));
      expect(list.where((p) => p.category == 'Yurtdışı').length, equals(3));
      expect(list.where((p) => p.category == 'Özel Fon').length, equals(3));
      expect(list.where((p) => p.category == 'Kuluçka').length, equals(3));
    });

    test('Kategoriye göre filtreleme doğru çalışmalıdır', () {
      controller.filterByCategory('Hibe');
      final hibeList = controller.programlarNotifier.value;
      expect(hibeList.length, equals(3));
      expect(hibeList.every((p) => p.category == 'Hibe'), isTrue);

      controller.filterByCategory('Tümü');
      expect(controller.programlarNotifier.value.length, equals(15));
    });

    test('Program durumları mantıklı bir dağılıma sahip olmalıdır', () {
      final list = controller.programlarNotifier.value;
      expect(list.any((p) => p.status == ProgramStatus.open), isTrue);
      expect(list.any((p) => p.status == ProgramStatus.upcoming), isTrue);
      expect(list.any((p) => p.status == ProgramStatus.closed), isTrue);
    });
  });
}
