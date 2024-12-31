// lib/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logQuizScore(String userId, int score, String theme) async {
    await _analytics.logEvent(
      name: 'quiz_completed',
      parameters: {
        'user_id': userId,
        'score': score,
        'theme': theme,
      },
    );
  }

  Future<void> setUserProperty(String userId, String theme) async {
    await _analytics.setUserProperty(
      name: 'preferred_theme',
      value: theme,
    );
  }

  Future<void> logQuestionAnswered(String questionId, bool wasCorrect) async {
    await _analytics.logEvent(
      name: 'question_answered',
      parameters: {
        'question_id': questionId,
        'correct': wasCorrect,
      },
    );
  }
}