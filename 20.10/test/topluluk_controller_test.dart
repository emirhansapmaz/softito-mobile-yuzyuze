import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge_platform/features/topluluk/controller/topluluk_controller.dart';

void main() {
  group('ToplulukController Security and Functionality Tests', () {
    late ToplulukController controller;

    setUp(() {
      controller = ToplulukController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta tam 13 adet mikro-paylaşım yüklenmelidir', () {
      expect(controller.postsNotifier.value.length, equals(13));
      expect(controller.isApprovedEntrepreneur, isFalse);
      expect(controller.errorNotifier.value, isNull);
    });

    test('Onaysız kullanıcı beğeni yapamaz ve güvenlik hatası alır', () {
      final firstPost = controller.postsNotifier.value.first;
      final initialLikes = firstPost.likeCount;

      controller.likePost(firstPost.id);

      expect(
        controller.errorNotifier.value,
        equals('Bu işlem için onaylı girişimci olmanız gerekmektedir.'),
      );
      expect(
        controller.postsNotifier.value.first.likeCount,
        equals(initialLikes),
      );
    });

    test('Onaysız kullanıcı yeni gönderi paylaşamaz ve yanıt yazamaz', () {
      controller.createPost('İzinsiz paylaşım denemesi');
      expect(
        controller.errorNotifier.value,
        equals('Bu işlem için onaylı girişimci olmanız gerekmektedir.'),
      );
      expect(controller.postsNotifier.value.length, equals(13));

      controller.addReply('post_1', 'İzinsiz yanıt denemesi');
      expect(
        controller.errorNotifier.value,
        equals('Bu işlem için onaylı girişimci olmanız gerekmektedir.'),
      );
    });

    test('Onaylı girişimci (isApprovedEntrepreneur: true) tüm işlemleri yapabilir', () {
      controller.setApproved(true);

      // Gönderi oluşturma
      controller.createPost('Yeni onaylı girişimci lansmanı!');
      expect(controller.postsNotifier.value.length, equals(14));
      expect(controller.postsNotifier.value.first.content, equals('Yeni onaylı girişimci lansmanı!'));

      // Beğeni yapma
      final newPostId = controller.postsNotifier.value.first.id;
      controller.likePost(newPostId);
      expect(controller.postsNotifier.value.first.likeCount, equals(1));
      expect(controller.postsNotifier.value.first.isLikedByMe, isTrue);

      // Yanıt yazma
      controller.addReply(newPostId, 'İlk yanıt tebriği!');
      expect(controller.postsNotifier.value.first.replies.length, equals(1));
      expect(controller.postsNotifier.value.first.replies.first.content, equals('İlk yanıt tebriği!'));
      expect(controller.errorNotifier.value, isNull);
    });
  });
}
