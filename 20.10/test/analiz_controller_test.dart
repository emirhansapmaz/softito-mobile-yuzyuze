import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorunge_platform/features/analiz/controller/analiz_controller.dart';
import 'package:yorunge_platform/features/analiz/models/analiz_model.dart';

void main() {
  group('AnalizController Unit Tests', () {
    late AnalizController controller;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      controller = AnalizController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta 0. adım ve boş model olmalıdır', () {
      expect(controller.currentStep, equals(0));
      expect(controller.currentForm.ideaSummary, isEmpty);
      expect(controller.stepTitles.length, equals(8));
    });

    test('Adım adımları (nextStep ve previousStep) doğru çalışmalıdır', () {
      controller.nextStep();
      expect(controller.currentStep, equals(1));

      controller.nextStep();
      expect(controller.currentStep, equals(2));

      controller.previousStep();
      expect(controller.currentStep, equals(1));
    });

    test('updateField form verilerini dinamik olarak güncellemelidir', () {
      controller.updateField(
        ideaSummary: 'Yeni Yapay Zeka Çözümü',
        traction: '100 Aktif Kullanıcı',
      );

      expect(controller.currentForm.ideaSummary, equals('Yeni Yapay Zeka Çözümü'));
      expect(controller.currentForm.traction, equals('100 Aktif Kullanıcı'));
    });

    test('saveDraft ve loadDraft yerel bellek kalıcılığını sağlamalıdır', () async {
      controller.updateField(
        ideaSummary: 'Kalıcı Taslak Testi',
        marketAnalysis: '500M Pazar Hacmi',
      );
      await controller.saveDraft();

      final newController = AnalizController();
      await newController.loadDraft();

      expect(newController.currentForm.ideaSummary, equals('Kalıcı Taslak Testi'));
      expect(newController.currentForm.marketAnalysis, equals('500M Pazar Hacmi'));

      newController.dispose();
    });

    test('AnalizModel JSON serileştirme ve tersine çevirme hatasız çalışmalıdır', () {
      const original = AnalizModel(
        ideaSummary: 'Test Özeti',
        teamDetails: '3 Kişilik Ekip',
        isCompleted: true,
      );

      final json = original.toJson();
      final fromJson = AnalizModel.fromJson(json);

      expect(fromJson, equals(original));
      expect(fromJson.isCompleted, isTrue);
    });
  });
}
