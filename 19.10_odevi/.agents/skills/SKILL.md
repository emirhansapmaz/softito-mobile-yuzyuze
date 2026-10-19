name:flutter-feature-scaffold
description: Flutter projelerinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini UI ayrımını ve birim test iskeletini standartlara uygun olarak üretir.

# Flutter feature scaffold (modüler ekran iskeleti)
Bu yetenek, projede yeni bir ekran ya da işlev modülü açarken Clean UI ve reaktif State kurallarına tam uyulmasını garanti altına alır.

## Temel Kurallar
1. **Asla tek dosyada toplama:**
UI (`_view.dart`) State Controller
(`_controller.dart`) ve model
(`_model.dart`) kesinlikle ayrı dosyalara yazılacaktır.
2. **Const Zorunluluğu:**
Mümkün olan tüm widgetlarda const olmalıdır.

## Adım Adım Uygulama Akışı
## Adım 1: Klasör Yapısı oluşturma
Hedeflenen modül adlarını (örn: `diary`), `lib/features/<feature_name>` altına yapıyı kur

```text
lib/features/<feature_name>
    controllers/
    <feature_name>_controller.dart
    models/
    <feature_name>_model.dart
    views/
    <feature_name>_view.dart
    widgets/
    <feature_name>_card.dart
```

### Adım 2: Controller Dosyasını Yaz
`controllers/<feature_name>_controller.dart` içinde takvim ve günlük mantığını yönetecek `ValueNotifier` tanımlarını oluştur:

```dart
import 'package:flutter/material.dart';

class DiaryController {
    final ValueNotifier<DateTime> selectedDate = ValueNotifier<DateTime>(DateTime.now());
    final ValueNotifier<List<String>> dailyEntries = ValueNotifier<List<String>>([]);

    void changeDate(DateTime newDate){
        selectedDate.value = newDate;
        // Burada yeni tarihe göre günlükler yüklenebilir
    }

    void addEntry(String entry){
        final updatedList = List<String>.from(dailyEntries.value)..add(entry);
        dailyEntries.value = updatedList;
    }

    void clearEntries(){
        dailyEntries.value = [];
    }

    void dispose(){
        selectedDate.dispose();
        dailyEntries.dispose();
    }
}
```

### Adım 3: Model Dosyasını Oluşturma
`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson`, `toJson` metotlarını içerecek ve `immutable` olacak şekilde yaz (Günlük girdisi için):

```dart
class DiaryEntry {
    final String id;
    final String content;
    final String dateString;
    final String mood;

    const DiaryEntry({
        required this.id,
        required this.content,
        required this.dateString,
        required this.mood
    });

    DiaryEntry copyWith({
        String? id,
        String? content,
        String? dateString,
        String? mood
    }) {
        return DiaryEntry(
            id: id ?? this.id,
            content: content ?? this.content,
            dateString: dateString ?? this.dateString,
            mood: mood ?? this.mood
        );
    }

    factory DiaryEntry.fromJson(Map<String,dynamic> json) => DiaryEntry(
        id: json['id'],
        content: json['content'],
        dateString: json['dateString'],
        mood: json['mood']
    );
    
    Map<String,dynamic> toJson(){
        return {
            'id': id,
            'content': content,
            'dateString': dateString,
            'mood': mood
        };
    }
}
```

### Adım 4: View Dosyasını Oluşturma
`views/<feature_name>_view.dart` dosyasında `StatelessWidget` kullanılarak takvim ve günlük alanı arayüzünü (UI katmanını) oluştur:

```dart
import 'package:flutter/material.dart';
import '../controllers/diary_controller.dart';

class DiaryView extends StatelessWidget {
    final DiaryController _controller = DiaryController();

    DiaryView({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dijital Günlük'),
        ),
        body: ValueListenableBuilder<DateTime>(
          valueListenable: _controller.selectedDate,
          builder: (context, selectedDate, _) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Seçili Tarih: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _controller.changeDate(DateTime.now()),
                    child: const Text('Bugüne Dön'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _controller.addEntry("Yeni günlük yazısı..."),
                    child: const Text('Günlük Ekle'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _controller.clearEntries,
                    child: const Text('Temizle'),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
}
```

### Adım 5: Widget Dosyasını Oluşturma
`widgets/<feature_name>_card.dart` dosyasında `StatelessWidget` kullanarak günlük kartı UI katmanını oluştur:

```dart
import 'package:flutter/material.dart';

class DiaryCard extends StatelessWidget {
  final String dateString;
  final String contentSnippet;
  final String moodIcon;

  const DiaryCard({
    Key? key,
    required this.dateString,
    required this.contentSnippet,
    required this.moodIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateString,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(contentSnippet),
            const SizedBox(height: 8),
            Text('Ruh Hali: $moodIcon'),
          ],
        ),
      ),
    );
  }
}
```

### Adım 6: Clean Architecture Kurallarına Uyum
- **Separation of Concerns:** Her dosyanın belirli bir sorumluluğu olduğundan emin ol.
- **Reusability:** Widgetları ve controller'ı diğer ekranlarda da kullanabilecek şekilde tasarla.
- **Testability:** Her katman için ayrı testler yazabileceğinden emin ol.

## Kullanım Örnekleri

### Örnek 1: Basit bir ekran oluşturma
```dart
import 'package:flutter/material.dart';
import 'package:flutter_feature_scaffold/features/diary/views/diary_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DiaryView();
  }
}
```

### Örnek 2: Modüler widget kullanımı
```dart
import 'package:flutter/material.dart';
import 'package:flutter_feature_scaffold/features/diary/widgets/diary_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DiaryCard(
      dateString: '20.10.2026',
      contentSnippet: 'Bugün harika bir gün geçirdim, yeni bir projeye başladım.',
      moodIcon: '😊',
    );
  }
}
```

## Ekstra İpuçları
- **Dependency Injection:** Controller'ları widgetlara inject etmek için GetIt veya Provider kullanabilirsin.
- **Navigation:** Navigasyonu sağlamak için Navigator 2.0 veya go_router kullanabilirsin.
- **Testing:** Her katman için ayrı testler yazarak uygulamanın stabilitesini sağlayabilirsin.

## SSS

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Yeni bir ekran veya işlev modülü oluştururken bu yeteneği kullanmalısın.

### Soru: Bu yetenek hangi durumlarda kullanmamalıyım?
**Cevap:** Mevcut bir ekranı güncellerken veya küçük bir hata düzeltmesi yaparken bu yeteneği kullanmamalısın.