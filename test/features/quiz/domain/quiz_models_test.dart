import 'package:flutter_test/flutter_test.dart';

import 'package:quizle/features/quiz/domain/quiz_models.dart';

void main() {
  group('QuizCatalog', () {
    test('parses valid localized content', () {
      const source = '''
      {
        "quizzes": [
          {
            "id": "technology",
            "title": "Technology",
            "description": "Technology basics",
            "difficulty": "beginner",
            "questions": [
              {
                "id": "cpu",
                "prompt": "What is a CPU?",
                "imageAsset": "images/cpu.jpg",
                "imageDescription": "A CPU",
                "correctOptionId": "processor",
                "explanation": "A CPU is a processor.",
                "options": [
                  {"id": "processor", "text": "A processor"},
                  {"id": "display", "text": "A display"}
                ]
              }
            ]
          }
        ]
      }
      ''';

      final catalog = QuizCatalog.fromJsonString(source);

      expect(catalog.quizzes, hasLength(1));
      expect(
        catalog.quizzes.single.questions.single.correctOption.id,
        'processor',
      );
    });

    test('rejects content without the declared correct option', () {
      const source = '''
      {
        "quizzes": [
          {
            "id": "technology",
            "title": "Technology",
            "description": "Technology basics",
            "difficulty": "beginner",
            "questions": [
              {
                "id": "cpu",
                "prompt": "What is a CPU?",
                "imageAsset": "images/cpu.jpg",
                "imageDescription": "A CPU",
                "correctOptionId": "missing",
                "explanation": "A CPU is a processor.",
                "options": [
                  {"id": "processor", "text": "A processor"},
                  {"id": "display", "text": "A display"}
                ]
              }
            ]
          }
        ]
      }
      ''';

      expect(
        () => QuizCatalog.fromJsonString(source),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
