import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge_platform/features/yatirimci/controller/yatirimci_controller.dart';

void main() {
  group('YatirimciController Unit Tests', () {
    late YatirimciController controller;

    setUp(() {
      controller = YatirimciController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta tam 16 adet yatırımcı yüklenmelidir', () {
      expect(controller.yatirimcilarNotifier.value.length, equals(16));
    });

    test('Kota dağılımı 4 Şirket, 4 Holding, 4 Melek, 4 VC olmalıdır', () {
      final list = controller.yatirimcilarNotifier.value;
      expect(list.where((y) => y.type == 'Şirket').length, equals(4));
      expect(list.where((y) => y.type == 'Holding').length, equals(4));
      expect(list.where((y) => y.type == 'Melek Yatırımcı').length, equals(4));
      expect(list.where((y) => y.type == 'VC').length, equals(4));
    });

    test('Türe göre filtreleme doğru çalışmalıdır', () {
      controller.filter(type: 'VC');
      final vcList = controller.yatirimcilarNotifier.value;
      expect(vcList.length, equals(4));
      expect(vcList.every((y) => y.type == 'VC'), isTrue);
    });

    test('Aşamaya göre filtreleme doğru çalışmalıdır', () {
      controller.filter(stage: 'Tohum');
      final tohumList = controller.yatirimcilarNotifier.value;
      expect(tohumList.every((y) => y.investmentStage == 'Tohum'), isTrue);
    });

    test('Kombine (Tür + Aşama) filtreleme doğru çalışmalıdır', () {
      controller.filter(type: 'Holding', stage: 'Seri A');
      final filtered = controller.yatirimcilarNotifier.value;
      expect(filtered.every((y) => y.type == 'Holding' && y.investmentStage == 'Seri A'), isTrue);
      expect(filtered.length, equals(1));
      expect(filtered.first.name, equals('Koç Holding Inovasyon Masası'));
    });
  });
}
