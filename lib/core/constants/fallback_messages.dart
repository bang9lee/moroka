import '../../l10n/generated/app_localizations.dart';
import '../../data/models/tarot_card_model.dart';

/// 폴백 메시지 관리 클래스
/// 오프라인 또는 API 오류 시 사용되는 기본 메시지를 다국어 지원과 함께 제공
class FallbackMessages {
  final AppLocalizations l10n;
  
  FallbackMessages(this.l10n);
  
  /// 단일 카드 폴백 해석
  String getSingleCardFallback(String cardName, String userMood) {
    return '''
[${l10n.cardMessage}]
$cardName ${l10n.cardShowingNewPerspective}

[${l10n.currentSituation}]
$userMood ${l10n.moodIsSignOfChange} ${l10n.nowIsTurningPoint}

[${l10n.practicalAdvice}]
• ${l10n.tryDifferentChoiceToday}
• ${l10n.talkWithSomeoneSpecial}
• ${l10n.setSmallGoalAndStart}

[${l10n.futureForecast}]
${l10n.positiveChangeInWeeks}
''';
  }
  
  /// 쓰리카드 폴백
  String getThreeCardFallback(List<TarotCardModel> cards, String userMood) {
    return '''
[${l10n.overallFlow}]
${l10n.flowFromPastToFuture}

[${l10n.timelineAnalysis}]
• ${l10n.past}: ${cards[0].nameKr} - ${l10n.lessonsFromPast}
• ${l10n.present}: ${cards[1].nameKr} - ${l10n.currentSituation}
• ${l10n.future}: ${cards[2].nameKr} - ${l10n.upcomingPossibilities}

[${l10n.actionGuidelines}]
${l10n.acceptPastFocusPresentPrepareFuture}

[${l10n.coreAdvice}]
$userMood ${l10n.mostImportantIsCurrentChoice}
''';
  }
  
  /// 예/아니오 폴백
  String getYesNoFallback(List<TarotCardModel> cards, String userMood) {
    // 긍정적인 카드 카운트
    final positiveCount = cards.where((c) => 
      c.name.contains('Sun') || c.name.contains('Star') || 
      c.name.contains('World') || c.name.contains('Ace')
    ).length;
    
    final answer = positiveCount >= 3 ? '⭕ ${l10n.yes}' : 
                   positiveCount >= 2 ? '⚠️ ${l10n.conditionalYes}' : '❌ ${l10n.no}';
    
    return '''
[${l10n.finalAnswer}]
$answer

[${l10n.judgmentBasis}]
• ${l10n.positiveSignals}: $positiveCount${l10n.cards}
• ${l10n.cautionSignals}: ${5 - positiveCount}${l10n.cards}

[${l10n.coreMessage}]
${cards[0].nameKr} ${l10n.cardHoldsImportantKey}

[${l10n.successConditions}]
${l10n.needCarefulPreparationAndTiming}

[${l10n.timingPrediction}]
${positiveCount >= 3 ? l10n.oneToTwoWeeks : l10n.oneToTwoMonths} ${l10n.checkResults}

[${l10n.actionGuide}]
${l10n.doBestRegardlessOfResult}
''';
  }
  
  /// 관계 폴백
  String getRelationshipFallback(List<TarotCardModel> cards, String userMood) {
    return '''
[${l10n.twoPersonEnergy}]
• ${l10n.you}: ${cards[0].nameKr} - ${l10n.importantRoleInRelationship}
• ${l10n.partner}: ${cards[1].nameKr} - ${l10n.partnersCurrentState}

[${l10n.heartTemperatureDifference}]
${l10n.temperatureDifferenceButUnderstandable}

[${l10n.relationshipObstacles}]
${cards[5].nameKr}${l10n.showingChallenges}

[${l10n.futurePossibility}]
${l10n.possibilityWithEffort}

[${l10n.adviceForLove}]
${l10n.needConversationUnderstandingTime}

[${l10n.oneLineAdvice}]
💕 ${l10n.loveIsMirrorReflectingEachOther}
''';
  }
  
  /// 켈틱 크로스 폴백
  String getCelticCrossFallback(List<TarotCardModel> cards, String userMood) {
    return '''
[${l10n.coreSituationAnalysis}]
${cards.length}${l10n.cardsShowingComplexSituation}

[${l10n.innerConflict}]
${l10n.conflictBetweenConsciousUnconscious}

[${l10n.timelineAnalysis}]
${l10n.pastInfluenceContinuesToPresent}

[${l10n.externalFactors}]
${l10n.surroundingEnvironmentImportant}

[${l10n.finalForecast}]
${l10n.positiveChangePossibility70Percent}

[${l10n.stepByStepPlan}]
1. ${l10n.thisWeek}: ${l10n.organizeSituation}
2. ${l10n.thisMonth}: ${l10n.startConcreteAction}
3. ${l10n.threeMonthsLater}: ${l10n.checkResults}

$userMood ${l10n.youHavePowerToOvercome}
''';
  }
  
  /// 채팅 폴백 응답
  String getChatFallbackResponse(String cardName, String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains(l10n.when) || lowerMessage.contains(l10n.timing)) {
      return l10n.tarotTimingAnswer(cardName);
    } else if (lowerMessage.contains(l10n.how) || lowerMessage.contains(l10n.method)) {
      return l10n.tarotMethodAnswer(cardName);
    } else if (lowerMessage.contains(l10n.why) || lowerMessage.contains(l10n.reason)) {
      return l10n.tarotReasonAnswer(cardName);
    } else {
      return l10n.tarotGeneralAnswer(cardName);
    }
  }
}