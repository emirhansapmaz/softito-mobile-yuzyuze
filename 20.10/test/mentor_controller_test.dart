import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge_platform/features/mentor/controller/mentor_controller.dart';
import 'package:yorunge_platform/features/mentor/models/mentor_model.dart';

void main() {
  group('MentorController Unit Tests', () {
    late MentorController controller;

    setUp(() {
      controller = MentorController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta tüm mentorlar yüklenmelidir (en az 9 mentor)', () {
      expect(controller.mentorsNotifier.value.length, greaterThanOrEqualTo(9));
      expect(controller.featuredMentors.isNotEmpty, isTrue);
    });

    test('Sektöre göre filtreleme doğru çalışmalıdır', () {
      controller.filterBySector('Fintek');
      final fintekList = controller.mentorsNotifier.value;
      expect(fintekList.every((m) => m.sector == 'Fintek'), isTrue);

      controller.filterBySector('Tümü');
      expect(controller.mentorsNotifier.value.length, greaterThanOrEqualTo(9));
    });

    test('Metin araması isim, şirket ve uzmanlıkta çalışmalıdır', () {
      controller.search('Selin');
      expect(controller.mentorsNotifier.value.length, equals(1));
      expect(controller.mentorsNotifier.value.first.name, contains('Selin'));

      controller.search('Ar-Ge');
      expect(controller.mentorsNotifier.value.length, greaterThanOrEqualTo(1));
    });

    test('requestMatch mentor durumunu pending yapmalıdır', () {
      final firstMentor = controller.mentorsNotifier.value.first;
      expect(firstMentor.matchStatus, equals(MatchStatus.none));

      controller.requestMatch(firstMentor.id);
      final updatedMentor = controller.mentorsNotifier.value
          .firstWhere((m) => m.id == firstMentor.id);
      expect(updatedMentor.matchStatus, equals(MatchStatus.pending));
    });
  });
}
