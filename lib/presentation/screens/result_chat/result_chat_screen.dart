import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../data/models/tarot_card_model.dart';
import '../../../core/utils/app_logger.dart';
import '../../widgets/common/animated_gradient_background.dart';
import '../../widgets/common/glass_morphism_container.dart';
import '../../widgets/common/custom_loading_indicator.dart';
import '../../widgets/spreads/spread_layout_widget.dart';
import '../../widgets/chat/chat_bubble_widget.dart';
import '../../widgets/chat/typing_indicator.dart';
import '../../widgets/common/accessible_icon_button.dart';
import '../main/main_viewmodel.dart';
import '../spread_selection/spread_selection_viewmodel.dart';
import 'result_chat_viewmodel.dart';
import '../../../data/models/tarot_spread_model.dart';

/// 타로 결과 및 채팅 화면
/// 선택된 카드의 해석과 AI 채팅을 제공합니다
class ResultChatScreen extends ConsumerStatefulWidget {
  final List<int> selectedCardIndices;
  
  const ResultChatScreen({
    super.key,
    required this.selectedCardIndices,
  });

  @override
  ConsumerState<ResultChatScreen> createState() => _ResultChatScreenState();
}

class _ResultChatScreenState extends ConsumerState<ResultChatScreen>
    with TickerProviderStateMixin {
  // Controllers
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  // Animation Controllers
  late AnimationController _layoutRevealController;
  late AnimationController _interpretationController;
  late AnimationController _cardFlipController;
  late Animation<double> _layoutFadeAnimation;
  late Animation<double> _interpretationFadeAnimation;
  
  // State
  bool _showInterpretation = false;
  bool _showChat = false;

  // Section Animations
  final List<AnimationController> _sectionControllers = [];
  final List<Animation<double>> _sectionAnimations = [];

  // Constants
  static const Duration _layoutRevealDuration = Duration(milliseconds: 1500);
  static const Duration _interpretationDuration = Duration(milliseconds: 800);
  static const Duration _cardFlipDuration = Duration(milliseconds: 600);
  static const Duration _sectionStaggerDelay = Duration(milliseconds: 200);
  static const int _maxSectionAnimations = 10;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startRevealSequence();
  }

  void _initializeAnimations() {
    // Main animations
    _layoutRevealController = AnimationController(
      duration: _layoutRevealDuration,
      vsync: this,
    );
    
    _interpretationController = AnimationController(
      duration: _interpretationDuration,
      vsync: this,
    );
    
    _cardFlipController = AnimationController(
      duration: _cardFlipDuration,
      vsync: this,
    );
    
    _layoutFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _layoutRevealController,
      curve: Curves.easeIn,
    ));
    
    _interpretationFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _interpretationController,
      curve: Curves.easeIn,
    ));
    
    // Section animations
    _initializeSectionAnimations();
  }

  void _initializeSectionAnimations() {
    for (int i = 0; i < _maxSectionAnimations; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 400 + (i * 100)),
        vsync: this,
      );
      _sectionControllers.add(controller);
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
      _sectionAnimations.add(animation);
    }
  }

  Future<void> _startRevealSequence() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final selectedSpread = ref.read(selectedSpreadProvider);
    final userMood = ref.read(userMoodProvider) ?? '';
    
    // Use the static method from TarotCardModel - now async
    final cardFutures = widget.selectedCardIndices
        .map((id) => TarotCardModel.getCardById(id))
        .toList();
    
    final cardResults = await Future.wait(cardFutures);
    final cards = cardResults.whereType<TarotCardModel>().toList();
    
    // Initialize viewmodel
    await Future(() {
      ref.read(resultChatViewModelProvider.notifier).initializeWithSpread(
        cards: cards,
        userMood: userMood,
        spread: selectedSpread!,
      );
    });
    
    // Animate layout reveal
    await Future.delayed(const Duration(milliseconds: 500));
    await _layoutRevealController.forward();
    
    // Animate interpretation
    await Future.delayed(const Duration(milliseconds: 1000));
    await _interpretationController.forward();
    
    if (mounted) {
      setState(() {
        _showInterpretation = true;
      });
    }
    
    // Animate sections
    await _animateSections();
    
    // Show chat
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _showChat = true;
      });
    }
  }

  Future<void> _animateSections() async {
    final sectionCount = math.min(_sectionControllers.length, 6);
    for (int i = 0; i < sectionCount; i++) {
      await Future.delayed(_sectionStaggerDelay);
      if (mounted && i < _sectionControllers.length) {
        _sectionControllers[i].forward();
      }
    }
  }

  List<Widget> _buildInterpretationSections(String interpretation) {
    AppLogger.debug('Building interpretation sections');
    
    if (interpretation.isEmpty) {
      return [_buildEmptyInterpretation()];
    }
    
    final sectionData = _parseInterpretation(interpretation);
    
    if (sectionData.isEmpty) {
      return [_buildSingleInterpretationCard(interpretation)];
    }
    
    return sectionData.asMap().entries.map((entry) {
      final index = entry.key;
      final section = entry.value;
      return _buildSectionCard(index, section);
    }).toList();
  }

  List<Map<String, dynamic>> _parseInterpretation(String interpretation) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(resultChatViewModelProvider);
    
    // 예/아니오 스프레드 특별 처리
    if (state.spreadType == SpreadType.yesNo) {
      return _parseYesNoInterpretation(interpretation);
    }
    
    // 원카드 특별 처리
    if (state.spreadType == SpreadType.oneCard || state.selectedCards.length == 1) {
      return _parseOneCardInterpretation(interpretation);
    }
    
    // 기존 파싱 로직
    final sectionData = <Map<String, dynamic>>[];
    String? currentTitle;
    String currentContent = '';
    
    final lines = interpretation.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      
      // 빈 줄은 스킵
      if (line.isEmpty) {
        if (currentContent.isNotEmpty) {
          currentContent += '\n\n';
        }
        continue;
      }
      
      // 섹션 제목인지 확인
      bool isSection = false;
      String? newTitle;
      
      // [제목] 형식
      if (line.startsWith('[') && line.endsWith(']')) {
        newTitle = line.substring(1, line.length - 1);
        isSection = true;
      }
      // **제목** 형식
      else if (line.startsWith('**') && line.endsWith('**') && line.length > 4) {
        newTitle = line.substring(2, line.length - 2);
        isSection = true;
      }
      // # 제목 형식
      else if (line.startsWith('#')) {
        newTitle = line.replaceAll('#', '').trim();
        isSection = true;
      }
      // 특별한 패턴: "제목" 뒤에 내용이 바로 오는 경우
      else {
        // 켈틱 크로스의 섹션 제목들 - 다국어 및 한국어 키워드 매핑
        final sectionTitles = [
          l10n.coreSituationAnalysis,
          l10n.innerConflict,
          l10n.timelineAnalysis,
          l10n.externalFactors,
          l10n.finalForecast,
          l10n.stepByStepPlan,
          l10n.twoPersonEnergy,
          l10n.heartTemperatureDifference,
          l10n.relationshipObstacles,
          l10n.futurePossibility,
          l10n.adviceForLove,
          l10n.oneLineAdvice,
          l10n.overallFlow,
          l10n.timeBasedInterpretation,
          l10n.actionGuidelines,
          l10n.coreAdvice,
        ];
        
        // 한국어 키워드 매핑 (AI가 한국어로 응답하는 경우)
        final koreanKeywords = {
          '핵심 상황 분석': l10n.coreSituationAnalysis,
          '내면의 갈등': l10n.innerConflict,
          '시간의 흐름': l10n.timelineAnalysis,
          '외부 요인': l10n.externalFactors,
          '최종 전망': l10n.finalForecast,
          '단계별 실행 계획': l10n.stepByStepPlan,
          '두 사람의 에너지': l10n.twoPersonEnergy,
          '마음의 온도차': l10n.heartTemperatureDifference,
          '관계의 장애물': l10n.relationshipObstacles,
          '미래의 가능성': l10n.futurePossibility,
          '사랑을 위한 조언': l10n.adviceForLove,
          '한 줄 조언': l10n.oneLineAdvice,
          '전체적인 흐름': l10n.overallFlow,
          '시기별 해석': l10n.timeBasedInterpretation,
          '행동 지침': l10n.actionGuidelines,
          '핵심 조언': l10n.coreAdvice,
        };
        
        // 먼저 한국어 키워드 체크
        for (final entry in koreanKeywords.entries) {
          if (line.startsWith(entry.key)) {
            newTitle = entry.value;
            isSection = true;
            final afterTitle = line.substring(entry.key.length).trim();
            if (afterTitle.isNotEmpty) {
              currentContent = '$afterTitle\n';
            }
            break;
          }
        }
        
        // 한국어 키워드가 없으면 현재 언어 제목 체크
        if (!isSection) {
          for (final title in sectionTitles) {
            if (line.startsWith(title)) {
              newTitle = title;
              isSection = true;
              final afterTitle = line.substring(title.length).trim();
              if (afterTitle.isNotEmpty) {
                currentContent = '$afterTitle\n';
              }
              break;
            }
          }
        }
      }
      
      if (isSection && newTitle != null) {
        // 이전 섹션 저장
        if (currentTitle != null && currentContent.trim().isNotEmpty) {
          sectionData.add({
            'title': currentTitle,
            'content': currentContent.trim(),
          });
        }
        
        currentTitle = newTitle;
        // 제목과 내용이 같은 줄에 있는 경우가 아니면 초기화
        if (!line.contains('$newTitle ') && !line.contains('$newTitle:')) {
          currentContent = '';
        }
      } else {
        // 일반 내용
        if (currentTitle != null) {
          currentContent += '$line\n';
        }
      }
    }
    
    // 마지막 섹션 저장
    if (currentTitle != null && currentContent.trim().isNotEmpty) {
      sectionData.add({
        'title': currentTitle,
        'content': currentContent.trim(),
      });
    }
    
    // 섹션이 없으면 전체를 하나의 섹션으로
    if (sectionData.isEmpty && interpretation.trim().isNotEmpty) {
      // 내용 기반으로 자동 섹션 분리 시도
      final autoSections = _autoDetectSections(interpretation);
      if (autoSections.isNotEmpty) {
        return autoSections;
      }
    }
    
    return sectionData;
  }

  // 원카드 전용 파싱
  List<Map<String, dynamic>> _parseOneCardInterpretation(String interpretation) {
    final sections = <Map<String, dynamic>>[];
    final lines = interpretation.split('\n');
    
    String? currentTitle;
    List<String> currentLines = [];
    
    for (final line in lines) {
      final trimmed = line.trim();
      
      // 원카드 섹션 제목 패턴
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        // 이전 섹션 저장
        if (currentTitle != null && currentLines.isNotEmpty) {
          sections.add({
            'title': currentTitle,
            'content': currentLines.join('\n').trim(),
          });
        }
        
        currentTitle = trimmed.substring(1, trimmed.length - 1);
        currentLines = [];
      } else if (trimmed.isNotEmpty) {
        currentLines.add(trimmed);
      }
    }
    
    // 마지막 섹션 저장
    if (currentTitle != null && currentLines.isNotEmpty) {
      sections.add({
        'title': currentTitle,
        'content': currentLines.join('\n').trim(),
      });
    }
    
    return sections;
  }

  // 예/아니오 전용 파싱
  List<Map<String, dynamic>> _parseYesNoInterpretation(String interpretation) {
    final l10n = AppLocalizations.of(context)!;
    final sections = <Map<String, dynamic>>[];
    
    // 예/아니오 특수 섹션 패턴 - AI가 한국어로만 응답하므로 한국어 패턴 사용
    final patterns = {
      l10n.yes: RegExp(r'최종 답변[:\s]*(.+?)(?=판단 근거|$)', dotAll: true),
      l10n.judgmentBasis: RegExp(r'판단 근거[:\s]*(.+?)(?=핵심 메시지|$)', dotAll: true),
      l10n.coreMessage: RegExp(r'핵심 메시지[:\s]*(.+?)(?=성공 조건|$)', dotAll: true),
      l10n.successConditions: RegExp(r'성공 조건[:\s]*(.+?)(?=시기 예측|$)', dotAll: true),
      l10n.timingPrediction: RegExp(r'시기 예측[:\s]*(.+?)(?=행동 가이드|$)', dotAll: true),
      l10n.actionGuide: RegExp(r'행동 가이드[:\s]*(.+?)$', dotAll: true),
    };
    
    for (final entry in patterns.entries) {
      final match = entry.value.firstMatch(interpretation);
      if (match != null) {
        final content = match.group(1)?.trim();
        if (content != null && content.isNotEmpty) {
          // 최종 답변은 특별 처리
          if (entry.key == l10n.yes) {
            sections.add({
              'title': entry.key,
              'content': content,
              'isSpecial': true,
            });
          } else {
            sections.add({
              'title': entry.key,
              'content': content,
            });
          }
        }
      }
    }
    
    // 섹션이 없으면 기본 파싱 시도
    if (sections.isEmpty) {
      final lines = interpretation.split('\n');
      String? currentTitle;
      List<String> currentLines = [];
      
      for (final line in lines) {
        final trimmed = line.trim();
        
        // 섹션 제목 감지
        bool isTitle = false;
        for (final title in patterns.keys) {
          if (trimmed.startsWith(title)) {
            // 이전 섹션 저장
            if (currentTitle != null && currentLines.isNotEmpty) {
              sections.add({
                'title': currentTitle,
                'content': currentLines.join('\n').trim(),
                'isSpecial': currentTitle == l10n.yes,
              });
            }
            
            currentTitle = title;
            // 제목과 같은 줄에 내용이 있으면
            final content = trimmed.substring(title.length).trim();
            currentLines = content.isNotEmpty ? [content] : [];
            isTitle = true;
            break;
          }
        }
        
        if (!isTitle && trimmed.isNotEmpty) {
          currentLines.add(trimmed);
        }
      }
      
      // 마지막 섹션 저장
      if (currentTitle != null && currentLines.isNotEmpty) {
        sections.add({
          'title': currentTitle,
          'content': currentLines.join('\n').trim(),
          'isSpecial': currentTitle == l10n.yes,
        });
      }
    }
    
    return sections;
  }
  
  List<Map<String, dynamic>> _autoDetectSections(String interpretation) {
    final l10n = AppLocalizations.of(context)!;
    final sections = <Map<String, dynamic>>[];
    final lines = interpretation.split('\n');
    
    // 주요 키워드로 섹션 자동 감지 - 한국어 키워드 포함
    final keywordPatterns = {
      // 원카드용 한국어 키워드
      '카드 의미': l10n.interpretation,
      '상황 해석': l10n.comprehensiveInterpretation,
      '조언': l10n.practicalAdvice,
      '오늘의 메시지': l10n.specialInterpretation,
      
      // 3카드용 한국어 키워드
      '과거': l10n.pastInfluence,
      '현재': l10n.currentSituation,
      '미래': l10n.futureForecast,
      
      // 기타 한국어 키워드
      '메시지': l10n.coreMessage,
      '의미': l10n.interpretation,
      '해석': l10n.comprehensiveInterpretation,
      '전체 해석': l10n.comprehensiveInterpretation,
      '종합 해석': l10n.comprehensiveInterpretation,
      
      // English keywords (in case AI responds in English)
      'Card Message': l10n.coreMessage,
      'Current Situation': l10n.currentSituation,
      'Practical Advice': l10n.practicalAdvice,
      'Past': l10n.pastInfluence,
      'Present': l10n.currentSituation,
      'Future': l10n.futureForecast,
      'Overall Flow': l10n.overallFlow,
      'Time-based Interpretation': l10n.timeBasedInterpretation,
      'Action Guidelines': l10n.actionGuidelines,
      'Core Advice': l10n.coreAdvice,
    };
    
    String currentSection = '';
    String currentTitle = l10n.coreMessage;
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) continue;
      
      // 키워드 감지
      bool foundKeyword = false;
      for (final entry in keywordPatterns.entries) {
        if (trimmedLine.contains(entry.key) && 
            (trimmedLine.length < 50 || trimmedLine.startsWith(entry.key))) {
          // 이전 섹션 저장
          if (currentSection.isNotEmpty) {
            sections.add({
              'title': currentTitle,
              'content': currentSection.trim(),
            });
          }
          
          currentTitle = entry.value;
          currentSection = '$trimmedLine\n';
          foundKeyword = true;
          break;
        }
      }
      
      if (!foundKeyword) {
        currentSection += '$trimmedLine\n';
      }
    }
    
    // 마지막 섹션 저장
    if (currentSection.isNotEmpty) {
      sections.add({
        'title': currentTitle,
        'content': currentSection.trim(),
      });
    }
    
    // 섹션이 너무 적으면 수동으로 분리
    if (sections.length <= 1) {
      return _manualSplitSections(interpretation);
    }
    
    return sections;
  }
  
  List<Map<String, dynamic>> _manualSplitSections(String interpretation) {
    final l10n = AppLocalizations.of(context)!;
    final sections = <Map<String, dynamic>>[];
    final sentences = interpretation.split(RegExp(r'[.!?]\s+'));
    
    if (sentences.length >= 6) {
      // 문장이 많으면 3개 섹션으로 분리
      final third = sentences.length ~/ 3;
      
      sections.add({
        'title': l10n.currentSituation,
        'content': '${sentences.take(third).join('. ')}.',
      });
      
      sections.add({
        'title': l10n.cardMessage,
        'content': '${sentences.skip(third).take(third).join('. ')}.',
      });
      
      sections.add({
        'title': l10n.futureAdvice,
        'content': '${sentences.skip(third * 2).join('. ')}.',
      });
    } else {
      // 문장이 적으면 하나의 섹션으로
      sections.add({
        'title': l10n.cardMessage,
        'content': interpretation,
      });
    }
    
    return sections;
  }

  Widget _buildEmptyInterpretation() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Text(
          l10n.preparingInterpretation,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.fogGray,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildSingleInterpretationCard(String interpretation) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blackOverlay40,
            AppColors.blackOverlay60,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.whiteOverlay10,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.blackOverlay40,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.mysticPurple.withAlpha(40),
                    AppColors.mysticPurple.withAlpha(25),
                  ],
                ),
                border: const Border(
                  bottom: BorderSide(
                    color: AppColors.whiteOverlay10,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.mysticPurple.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppColors.mysticPurple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    l10n.cardMessage,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.mysticPurple,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(28),
              child: _buildParagraphs(interpretation),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(int index, Map<String, dynamic> section) {
    final l10n = AppLocalizations.of(context)!;
    final animationIndex = index < _sectionAnimations.length 
        ? index 
        : _sectionAnimations.length - 1;
    
    final style = _getSectionStyle(section['title']);
    
    // 예/아니오 최종 답변 특별 처리
    if (section['isSpecial'] == true && section['title'] == l10n.yes) {
      return _buildYesNoAnswerCard(section, animationIndex);
    }
    
    return AnimatedBuilder(
      animation: _sectionAnimations[animationIndex],
      builder: (context, child) {
        final animationValue = _sectionAnimations[animationIndex].value.clamp(0.0, 1.0);
        
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.blackOverlay40,
                    AppColors.blackOverlay60,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.whiteOverlay10,
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.blackOverlay40,
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section Header - 개선된 헤더 디자인
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (style['color'] as Color).withAlpha(40),
                            (style['color'] as Color).withAlpha(25),
                          ],
                        ),
                        border: const Border(
                          bottom: BorderSide(
                            color: AppColors.whiteOverlay10,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // 아이콘 배경
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (style['color'] as Color).withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              style['icon'] as IconData,
                              color: style['color'] as Color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // 섹션 제목
                          Expanded(
                            child: Text(
                              section['title'],
                              style: AppTextStyles.sectionTitle.copyWith(
                                color: style['color'] as Color,
                                fontSize: 22,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Section Content - 여유있는 패딩
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: _buildSectionContent(section, style),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 예/아니오 최종 답변 특별 카드
  Widget _buildYesNoAnswerCard(Map<String, dynamic> section, int animationIndex) {
    final l10n = AppLocalizations.of(context)!;
    final content = section['content'] as String;
    
    // 답변 타입 판단
    final isYes = content.contains('⭕') || content.contains('예');
    final isNo = content.contains('❌') || content.contains('아니오');
    final isConditional = content.contains('⚠️') || content.contains('조건부');
    
    Color primaryColor = AppColors.fogGray;
    IconData answerIcon = Icons.help_outline;
    String answerText = content.trim();
    
    if (isYes && !isConditional) {
      primaryColor = AppColors.spiritGlow;
      answerIcon = Icons.check_circle;
      answerText = '⭕ ${l10n.yes}';
    } else if (isNo) {
      primaryColor = AppColors.crimsonGlow;
      answerIcon = Icons.cancel;
      answerText = '❌ ${l10n.no}';
    } else if (isConditional) {
      primaryColor = AppColors.omenGlow;
      answerIcon = Icons.warning;
      answerText = '⚠️ ${l10n.conditionalYes}';
    }
    
    return AnimatedBuilder(
      animation: _sectionAnimations[animationIndex],
      builder: (context, child) {
        final animationValue = _sectionAnimations[animationIndex].value.clamp(0.0, 1.0);
        
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animationValue)),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor.withAlpha(20),
                    primaryColor.withAlpha(10),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: primaryColor.withAlpha(100),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withAlpha(40),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      answerIcon,
                      size: 80,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      answerText,
                      style: AppTextStyles.displaySmall.copyWith(
                        color: primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildSectionContent(Map<String, dynamic> section, Map<String, dynamic> style) {
    final l10n = AppLocalizations.of(context)!;
    final content = section['content'] as String;
    
    // 특별한 포맷팅이 필요한 섹션 처리
    if ((section['title'] == l10n.practicalAdvice || 
         section['title'] == l10n.actionGuidelines ||
         section['title'] == l10n.stepByStepPlan ||
         section['title'] == l10n.adviceForLove ||
         section['title'] == l10n.judgmentBasis) && 
        (content.contains('•') || content.contains('1.') || content.contains('2.') || content.contains(':'))) {
      return _buildBulletPoints(content, style);
    } else if (content.contains('**')) {
      return _buildFormattedContent(content, style);
    }
    
    // 일반 텍스트 - 문단 자연스럽게 구분
    return _buildParagraphs(content);
  }
  
  Widget _buildParagraphs(String content) {
    // 문단 구분 개선 - 마침표 2개 이상 또는 줄바꿈으로 구분
    final paragraphs = content.split(RegExp(r'\n\n|\. \s*(?=[가-힣A-Z])'));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((paragraph) {
        final trimmed = paragraph.trim();
        if (trimmed.isEmpty) return const SizedBox.shrink();
        
        // 마침표가 없으면 추가
        final text = trimmed.endsWith('.') || trimmed.endsWith('?') || trimmed.endsWith('!') 
            ? trimmed 
            : '$trimmed.';
        
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Text(
            text,
            style: AppTextStyles.interpretation.copyWith(
              height: 1.85,
              color: AppColors.textPrimary,
              fontSize: 19,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFormattedContent(String content, Map<String, dynamic> style) {
    final parts = content.split('\n');
    final widgets = <Widget>[];
    
    for (final part in parts) {
      if (part.trim().isEmpty) {
        widgets.add(const SizedBox(height: 12));
      } else if (part.trim().startsWith('**') && part.trim().endsWith('**')) {
        final text = part.trim().replaceAll('**', '');
        widgets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 12, top: 8),
            child: Text(
              text,
              style: AppTextStyles.interpretationEmphasis.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.ghostWhite,
                fontSize: 20,
              ),
            ),
          ),
        );
      } else if (part.trim().startsWith('-') || part.trim().startsWith('•')) {
        final text = part.trim().substring(1).trim();
        widgets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: (style['color'] as Color).withAlpha(180),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: AppTextStyles.interpretation.copyWith(
                      fontSize: 18,
                      height: 1.7,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Text(
              part,
              style: AppTextStyles.interpretation.copyWith(
                height: 1.8,
                fontSize: 19,
                letterSpacing: 0.1,
              ),
            ),
          ),
        );
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildBulletPoints(String content, Map<String, dynamic> style) {
    // 다양한 형식의 리스트 처리
    final List<String> items;
    
    if (content.contains('•')) {
      items = content
          .split('•')
          .where((item) => item.trim().isNotEmpty)
          .toList();
    } else if (content.contains(RegExp(r'\d+\.'))) {
      // 숫자 리스트 처리
      items = content
          .split(RegExp(r'(?=\d+\.)'))
          .where((item) => item.trim().isNotEmpty)
          .toList();
    } else if (content.contains(':') && content.contains('\n')) {
      // 콜론으로 구분된 항목들 (예: "긍정 카드: 3장")
      items = content
          .split('\n')
          .where((item) => item.trim().isNotEmpty && item.contains(':'))
          .toList();
    } else {
      // 기타 경우 줄바꿈으로 분리
      items = content
          .split('\n')
          .where((item) => item.trim().isNotEmpty)
          .toList();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        final trimmedItem = item.trim();
        final hasNumber = RegExp(r'^\d+\.').hasMatch(trimmedItem);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.only(left: hasNumber ? 0 : 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!hasNumber) ...[
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: (style['color'] as Color).withAlpha(180),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (style['color'] as Color).withAlpha(60),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  trimmedItem,
                  style: AppTextStyles.interpretation.copyWith(
                    fontSize: 18,
                    height: 1.7,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> _getSectionStyle(String title) {
    final l10n = AppLocalizations.of(context)!;
    final sectionStyles = {
      l10n.cardMessage: {
        'icon': Icons.auto_awesome,
        'color': AppColors.mysticPurple,
      },
      l10n.currentSituation: {
        'icon': Icons.remove_red_eye,
        'color': AppColors.fogGray,
      },
      l10n.practicalAdvice: {
        'icon': Icons.lightbulb_outline,
        'color': AppColors.omenGlow,
      },
      l10n.futureForecast: {
        'icon': Icons.auto_fix_high_sharp,
        'color': AppColors.mysticPurple,
      },
      l10n.overallFlow: {
        'icon': Icons.timeline,
        'color': AppColors.spiritGlow,
      },
      l10n.timeBasedInterpretation: {
        'icon': Icons.schedule,
        'color': AppColors.evilGlow,
      },
      l10n.pastInfluence: {
        'icon': Icons.history,
        'color': AppColors.ashGray,
      },
      l10n.upcomingFuture: {
        'icon': Icons.trending_up,
        'color': AppColors.mysticPurple,
      },
      l10n.actionGuidelines: {
        'icon': Icons.directions_run,
        'color': AppColors.omenGlow,
      },
      l10n.coreAdvice: {
        'icon': Icons.star,
        'color': AppColors.spiritGlow,
      },
      l10n.coreSituationAnalysis: {
        'icon': Icons.analytics,
        'color': AppColors.spiritGlow,
      },
      l10n.innerConflict: {
        'icon': Icons.psychology,
        'color': AppColors.evilGlow,
      },
      l10n.timelineAnalysis: {
        'icon': Icons.schedule,
        'color': AppColors.fogGray,
      },
      l10n.externalFactors: {
        'icon': Icons.public,
        'color': AppColors.ashGray,
      },
      l10n.finalForecast: {
        'icon': Icons.visibility,
        'color': AppColors.mysticPurple,
      },
      l10n.stepByStepPlan: {
        'icon': Icons.format_list_numbered,
        'color': AppColors.omenGlow,
      },
      l10n.twoPersonEnergy: {
        'icon': Icons.favorite,
        'color': AppColors.crimsonGlow,
      },
      l10n.heartTemperatureDifference: {
        'icon': Icons.thermostat,
        'color': AppColors.evilGlow,
      },
      l10n.relationshipObstacles: {
        'icon': Icons.block,
        'color': AppColors.ashGray,
      },
      l10n.futurePossibility: {
        'icon': Icons.trending_up,
        'color': AppColors.spiritGlow,
      },
      l10n.adviceForLove: {
        'icon': Icons.tips_and_updates,
        'color': AppColors.mysticPurple,
      },
      l10n.oneLineAdvice: {
        'icon': Icons.format_quote,
        'color': AppColors.omenGlow,
      },
      l10n.yes: {
        'icon': Icons.check_circle,
        'color': AppColors.spiritGlow,
      },
      l10n.judgmentBasis: {
        'icon': Icons.fact_check,
        'color': AppColors.fogGray,
      },
      l10n.coreMessage: {
        'icon': Icons.message,
        'color': AppColors.evilGlow,
      },
      l10n.successConditions: {
        'icon': Icons.flag,
        'color': AppColors.omenGlow,
      },
      l10n.timingPrediction: {
        'icon': Icons.access_time,
        'color': AppColors.ashGray,
      },
      l10n.actionGuide: {
        'icon': Icons.explore,
        'color': AppColors.mysticPurple,
      },
    };
    
    return sectionStyles[title] ?? {
      'icon': Icons.info_outline,
      'color': AppColors.fogGray,
    };
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    
    _messageController.clear();
    
    // Haptic feedback
    await _triggerHapticFeedback(30);
    
    // Send message
    await ref.read(resultChatViewModelProvider.notifier).sendMessage(message);
    
    // Scroll to bottom
    _scrollToBottom();
  }

  Future<void> _triggerHapticFeedback(int duration) async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(duration: duration);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  String _getLocalizedSpreadName(TarotSpread? spread, AppLocalizations l10n) {
    if (spread == null) return '';
    
    switch (spread.type) {
      case SpreadType.oneCard:
        return l10n.spreadOneCard;
      case SpreadType.threeCard:
        return l10n.spreadThreeCard;
      case SpreadType.celticCross:
        return l10n.spreadCelticCross;
      case SpreadType.relationship:
        return l10n.spreadRelationship;
      case SpreadType.yesNo:
        return l10n.spreadYesNo;
    }
  }

  void _showAdPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AdPromptDialog(
        onAdWatch: () async {
          Navigator.pop(context);
          await ref.read(resultChatViewModelProvider.notifier).showAd();
        },
      ),
    );
  }

  double _getLayoutHeight(int cardCount) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    // 화면 크기에 따라 동적으로 높이 조정
    switch (cardCount) {
      case 1:
        return isSmallScreen ? 280 : 340;
      case 3:
        return isSmallScreen ? 320 : 380;
      case 5:
        return isSmallScreen ? 360 : 420;
      case 7:
        return isSmallScreen ? 400 : 460;
      case 10:
        return isSmallScreen ? 480 : 580;
      default:
        return isSmallScreen ? 380 : 440;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _layoutRevealController.dispose();
    _interpretationController.dispose();
    _cardFlipController.dispose();
    
    for (final controller in _sectionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(resultChatViewModelProvider);
    final selectedSpread = ref.watch(selectedSpreadProvider);
    final spreadName = _getLocalizedSpreadName(selectedSpread, l10n);
    final isOneCard = state.selectedCards.length == 1;
    
    return PopScope(
      canPop: false,  // 백 버튼 비활성화
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // 백 버튼 눌렀을 때 홈으로 이동
          context.go('/main');
        }
      },
      child: Scaffold(
        body: AnimatedGradientBackground(
          gradients: const [
            AppColors.bloodGradient,
            AppColors.darkGradient,
          ],
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(spreadName),
                Expanded(
                  child: _buildContent(state, selectedSpread, isOneCard),
                ),
                if (_showChat && !state.showAdPrompt)
                  _buildChatInput(context, state),
                if (state.showAdPrompt)
                  _buildAdPromptBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String spreadName) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.shadowGray.withAlpha(200),
            AppColors.shadowGray.withAlpha(0),
          ],
        ),
      ),
      child: Row(
        children: [
          _buildCloseButton(),
          Expanded(
            child: _buildSpreadNameBadge(spreadName),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteOverlay10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AccessibleIconButton(
        onPressed: () => context.go('/main'),
        icon: Icons.close,
        semanticLabel: l10n.close,
        color: AppColors.ghostWhite,
      ),
    );
  }

  Widget _buildSpreadNameBadge(String spreadName) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteOverlay10,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.whiteOverlay20,
          width: 1,
        ),
      ),
      child: Text(
        spreadName,
        style: AppTextStyles.displaySmall.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent(
    ResultChatState state,
    TarotSpread? selectedSpread,
    bool isOneCard,
  ) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      children: [
        if (selectedSpread != null)
          _buildCardLayout(state, selectedSpread),
        if (_showInterpretation)
          _buildInterpretationSection(state, isOneCard),
        const SizedBox(height: 20),
        if (_showChat) 
          ..._buildChatMessages(state),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildCardLayout(ResultChatState state, TarotSpread selectedSpread) {
    final l10n = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: _layoutFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _layoutFadeAnimation.value,
          child: Semantics(
            label: l10n.selectedCardsLayout,
            container: true,
            child: Container(
              height: _getLayoutHeight(state.selectedCards.length),
              margin: const EdgeInsets.only(bottom: 32),
              child: SpreadLayoutWidget(
                spread: selectedSpread,
                drawnCards: state.selectedCards,
                showCardNames: true,
                isInteractive: false,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInterpretationSection(ResultChatState state, bool isOneCard) {
    return AnimatedBuilder(
      animation: _interpretationFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _interpretationFadeAnimation.value,
          child: Column(
            children: [
              _buildInterpretationHeader(isOneCard),
              if (state.isLoadingInterpretation)
                _buildLoadingIndicator()
              else
                ..._buildInterpretationSections(
                  state.spreadInterpretation ?? '',
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInterpretationHeader(bool isOneCard) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mysticPurple.withAlpha(60),
            AppColors.deepViolet.withAlpha(40),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.mysticPurple.withAlpha(120),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            isOneCard ? l10n.cardMessage : l10n.cardsStory,
            style: AppTextStyles.displaySmall.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.specialInterpretation,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.fogGray,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          const CustomLoadingIndicator(
            size: 80,
            color: AppColors.evilGlow,
          ),
          const SizedBox(height: 32),
          Text(
            l10n.interpretingCards,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.fogGray,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChatMessages(ResultChatState state) {
    final widgets = <Widget>[];
    
    widgets.addAll(
      state.messages.map((message) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Semantics(
          label: message.isUser 
              ? '${AppLocalizations.of(context)!.yourQuestion}: ${message.message}'
              : '${AppLocalizations.of(context)!.tarotMasterResponse}: ${message.message}',
          container: true,
          child: ChatBubbleWidget(
            message: message.message,
            isUser: message.isUser,
            timestamp: message.timestamp,
          ).animate()
              .slideX(
                begin: message.isUser ? 0.1 : -0.1,
                duration: const Duration(milliseconds: 300),
              )
              .fadeIn(),
        ),
      )),
    );
    
    if (state.isTyping) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: TypingIndicator(),
        ),
      );
    }
    
    return widgets;
  }

  Widget _buildChatInput(BuildContext context, ResultChatState state) {
    final l10n = AppLocalizations.of(context)!;
    // 채팅 제한 도달 시
    if (state.chatLimitReached) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.shadowGray,
              AppColors.shadowGray.withAlpha(240),
            ],
          ),
          border: const Border(
            top: BorderSide(
              color: AppColors.crimsonGlow,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.blackOverlay40,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.crimsonGlow.withAlpha(100),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  color: AppColors.crimsonGlow,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.todaysChatEnded,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.crimsonGlow,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.shadowGray,
            AppColors.shadowGray.withAlpha(240),
          ],
        ),
        border: const Border(
          top: BorderSide(
            color: AppColors.whiteOverlay10,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: Row(
          children: [
            Expanded(
              child: _buildMessageField(context, state),
            ),
            const SizedBox(width: 16),
            _buildSendButton(state),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageField(BuildContext context, ResultChatState state) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: l10n.chatInputField,
      textField: true,
      enabled: !state.isLoading,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.blackOverlay40,
              AppColors.blackOverlay60,
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.whiteOverlay10,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _messageController,
          focusNode: _focusNode,
          style: AppTextStyles.chatUser.copyWith(
            fontSize: 17,
          ),
          decoration: InputDecoration(
            hintText: l10n.askQuestions,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.ashGray,
              fontSize: 17,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
          onSubmitted: (_) => _sendMessage(),
          enabled: !state.isLoading,
        ),
      ),
    );
  }

  Widget _buildSendButton(ResultChatState state) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: l10n.sendMessage,
      button: true,
      enabled: !state.isLoading,
      child: GestureDetector(
        onTap: state.isLoading ? null : _sendMessage,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: state.isLoading
                  ? [AppColors.ashGray, AppColors.fogGray]
                  : [AppColors.crimsonGlow, AppColors.evilGlow],
            ),
            shape: BoxShape.circle,
            boxShadow: state.isLoading
                ? []
                : [
                    BoxShadow(
                      color: AppColors.crimsonGlow.withAlpha(120),
                      blurRadius: 24,
                      spreadRadius: 3,
                    ),
                  ],
          ),
          child: const Icon(
            Icons.send_rounded,
            color: AppColors.ghostWhite,
            size: 24,
          ),
        ).animate()
            .scale(
              begin: const Offset(0.8, 0.8),
              duration: const Duration(milliseconds: 200),
            ),
      ),
    );
  }

  Widget _buildAdPromptBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.shadowGray,
            AppColors.shadowGray.withAlpha(240),
          ],
        ),
        border: const Border(
          top: BorderSide(
            color: AppColors.crimsonGlow,
            width: 2.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: GestureDetector(
          onTap: _showAdPrompt,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 36,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.crimsonGlow,
                  AppColors.evilGlow,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.crimsonGlow.withAlpha(120),
                  blurRadius: 36,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.remove_red_eye,
                  color: AppColors.ghostWhite,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Text(
                  l10n.continueConversation,
                  style: AppTextStyles.buttonLarge.copyWith(
                    color: AppColors.ghostWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }
}

/// 광고 프롬프트 다이얼로그
class _AdPromptDialog extends StatelessWidget {
  final VoidCallback onAdWatch;
  
  const _AdPromptDialog({
    required this.onAdWatch,
  });
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        child: GlassMorphismContainer(
          padding: const EdgeInsets.all(40),
          borderRadius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(),
              const SizedBox(height: 32),
              _buildTitle(context),
              const SizedBox(height: 20),
              _buildDescription(context),
              const SizedBox(height: 40),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.evilGlow, AppColors.crimsonGlow],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.evilGlow.withAlpha(120),
            blurRadius: 40,
            spreadRadius: 15,
          ),
        ],
      ),
      child: const Icon(
        Icons.remove_red_eye,
        size: 48,
        color: AppColors.ghostWhite,
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).scale(
      begin: const Offset(1, 1),
      end: const Offset(1.1, 1.1),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
  }
  
  Widget _buildTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.wantDeeperTruth,
      style: AppTextStyles.displaySmall.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _buildDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.watchAdToContinue,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.fogGray,
        height: 1.6,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCancelButton(context),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildWatchAdButton(context),
        ),
      ],
    );
  }
  
  Widget _buildCancelButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.ashGray,
            width: 2,
          ),
        ),
        child: Text(
          l10n.later,
          style: AppTextStyles.buttonMedium.copyWith(
            color: AppColors.ashGray,
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  
  Widget _buildWatchAdButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onAdWatch,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.crimsonGlow, AppColors.evilGlow],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.crimsonGlow.withAlpha(120),
              blurRadius: 24,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Text(
          l10n.watchAd,
          style: AppTextStyles.buttonMedium.copyWith(
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
      ).animate()
          .shimmer(
            duration: const Duration(seconds: 2),
            color: AppColors.whiteOverlay20,
          ),
    );
  }
}