import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge_platform/features/fikir_durumu/controller/fikir_durumu_controller.dart';

void main() {
  group('FikirDurumuController Unit Tests', () {
    late FikirDurumuController controller;

    setUp(() {
      controller = FikirDurumuController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta 6 adet fikir durumu ve ilk fikir seçili olmalıdır', () {
      expect(controller.allIdeas.length, equals(6));
      expect(controller.currentIdeaNotifier.value.id, equals('f1'));
      expect(controller.currentIdeaNotifier.value.projectName, contains('VeriFlow'));
    });

    test('6 adımlı Türkiye mevzuatı yol haritası listesi tam olmalıdır', () {
      expect(controller.legalSteps.length, equals(6));
      expect(controller.legalSteps.first, equals('Avukat Ataması'));
      expect(controller.legalSteps.last, equals('Hissedarlar Sözleşmesi (SHA)'));
    });

    test('switchIdea farklı bir fikri reaktif seçebilmelidir', () {
      controller.switchIdea('f4');
      expect(controller.currentIdeaNotifier.value.id, equals('f4'));
      expect(controller.currentIdeaNotifier.value.projectName, contains('PixelMoon'));
      expect(controller.currentIdeaNotifier.value.currentStepIndex, equals(5));
      expect(controller.currentIdeaNotifier.value.incomeSupportProgress, equals(1.0));
    });
  });
}
