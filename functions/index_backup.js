const { onCall } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const admin = require('firebase-admin');
const { GoogleGenerativeAI } = require('@google/generative-ai');

admin.initializeApp();

// 시크릿 정의
const geminiApiKey = defineSecret('GEMINI_API_KEY');

// Gemini API 초기화
let genAI;

// Helper function to get language instruction
function getLanguageInstruction(language) {
    const languageInstructions = {
        en: 'Please respond in English.',
        ko: 'Please respond in Korean. 한국어로 답변해주세요.',
        ja: 'Please respond in Japanese. 日本語で回答してください。',
        zh: 'Please respond in Chinese. 请用中文回答。',
        es: 'Please respond in Spanish. Por favor responde en español.',
        fr: 'Please respond in French. Veuillez répondre en français.',
        de: 'Please respond in German. Bitte antworten Sie auf Deutsch.',
        pt: 'Please respond in Portuguese. Por favor, responda em português.',
        hi: 'Please respond in Hindi. कृपया हिंदी में उत्तर दें।',
        vi: 'Please respond in Vietnamese. Vui lòng trả lời bằng tiếng Việt.',
        th: 'Please respond in Thai. กรุณาตอบเป็นภาษาไทย'
    };
    
    return languageInstructions[language] || languageInstructions.en;
}

// 타로 해석 함수
exports.generateTarotInterpretation = onCall(
    { secrets: [geminiApiKey] },
    async (request) => {
        const data = request.data;
        
        try {
            // Gemini API 초기화 (처음 호출 시에만)
            if (!genAI) {
                const apiKey = geminiApiKey.value();
                if (!apiKey) {
                    console.error('Gemini API key not configured');
                    throw new Error('서비스 설정 오류가 발생했습니다.');
                }
                genAI = new GoogleGenerativeAI(apiKey);
            }

            // 입력값 확인
            if (!data.cardName || !data.userMood) {
                throw new Error('필수 입력값이 누락되었습니다.');
            }

            const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });

            let prompt = '';
            const language = data.language || 'en';
            
            console.log(`Generating interpretation for language: ${language}`);
            
            // Language-specific section titles
            const sectionTitles = {
                en: {
                    cardMessage: '[Card Message]',
                    currentSituation: '[Current Situation]',
                    practicalAdvice: '[Practical Advice]',
                    futureOutlook: '[Future Outlook]'
                },
                ko: {
                    cardMessage: '[카드의 메시지]',
                    currentSituation: '[현재 상황]',
                    practicalAdvice: '[실천 조언]',
                    futureOutlook: '[앞으로의 전망]'
                },
                ja: {
                    cardMessage: '[カードのメッセージ]',
                    currentSituation: '[現在の状況]',
                    practicalAdvice: '[実践的なアドバイス]',
                    futureOutlook: '[今後の展望]'
                },
                zh: {
                    cardMessage: '[卡牌信息]',
                    currentSituation: '[当前情况]',
                    practicalAdvice: '[实践建议]',
                    futureOutlook: '[未来展望]'
                },
                es: {
                    cardMessage: '[Mensaje de la Carta]',
                    currentSituation: '[Situación Actual]',
                    practicalAdvice: '[Consejo Práctico]',
                    futureOutlook: '[Perspectiva Futura]'
                },
                fr: {
                    cardMessage: '[Message de la Carte]',
                    currentSituation: '[Situation Actuelle]',
                    practicalAdvice: '[Conseils Pratiques]',
                    futureOutlook: '[Perspectives Futures]'
                },
                de: {
                    cardMessage: '[Kartenbotschaft]',
                    currentSituation: '[Aktuelle Situation]',
                    practicalAdvice: '[Praktischer Rat]',
                    futureOutlook: '[Zukunftsaussichten]'
                },
                pt: {
                    cardMessage: '[Mensagem da Carta]',
                    currentSituation: '[Situação Atual]',
                    practicalAdvice: '[Conselho Prático]',
                    futureOutlook: '[Perspectiva Futura]'
                },
                hi: {
                    cardMessage: '[कार्ड संदेश]',
                    currentSituation: '[वर्तमान स्थिति]',
                    practicalAdvice: '[व्यावहारिक सलाह]',
                    futureOutlook: '[भविष्य की संभावनाएं]'
                },
                vi: {
                    cardMessage: '[Thông Điệp Lá Bài]',
                    currentSituation: '[Tình Hình Hiện Tại]',
                    practicalAdvice: '[Lời Khuyên Thực Tiễn]',
                    futureOutlook: '[Triển Vọng Tương Lai]'
                },
                th: {
                    cardMessage: '[ข้อความจากไพ่]',
                    currentSituation: '[สถานการณ์ปัจจุบัน]',
                    practicalAdvice: '[คำแนะนำเชิงปฏิบัติ]',
                    futureOutlook: '[แนวโน้มในอนาคต]'
                }
            };
            
            // Default to English if language not supported
            const titles = sectionTitles[language] || sectionTitles.en;
            const isEnglish = language === 'en';
            
            if (data.interpretationType === 'single') {
                if (isEnglish) {
                    prompt = `
You are a tarot master with 50 years of experience. Be concise and deliver only the essence.

User mood: ${data.userMood}
Card drawn: ${data.cardName}

Please interpret in the following format:

[Card Message]
The core message this card conveys (1-2 sentences)

[Current Situation]
The cause of your ${data.userMood} mood and current state (2-3 sentences)

[Practical Advice]
• What to do today
• Goals for this week
• Changes within a month

[Future Outlook]
Prediction of positive changes (1-2 sentences)

Rules:
- Keep within 8-10 sentences total
- Use simple words only
- Suggest specific actions
`;
                } else {
                    // For non-English languages, instruct to respond in that language
                    const languageInstruction = getLanguageInstruction(language);
                    prompt = `
You are a tarot master with 50 years of experience. Be concise and deliver only the essence.
${languageInstruction}

User mood: ${data.userMood}
Card drawn: ${data.cardName}

Please interpret in the following format:

${titles.cardMessage}
The core message this card conveys (1-2 sentences)

${titles.currentSituation}
The cause of the ${data.userMood} mood and current state (2-3 sentences)

${titles.practicalAdvice}
• What to do today
• Goals for this week
• Changes within a month

${titles.futureOutlook}
Prediction of positive changes (1-2 sentences)

Rules:
- Keep within 8-10 sentences total
- Use simple words only
- Suggest specific actions
`;
                }
            } else {
                const languageInstruction = getLanguageInstruction(language);
                prompt = `
Tarot card: ${data.cardName}
User mood: ${data.userMood}

Please interpret the meaning of this card.
${languageInstruction}
`;
            }

            const result = await model.generateContent(prompt);
            const interpretation = result.response.text();

            return {
                interpretation: interpretation,
                usage: 1  // 임시값
            };

        } catch (error) {
            console.error('Gemini API Error:', error);
            throw new Error('AI 해석 중 오류가 발생했습니다.');
        }
    }
);

// 스프레드 해석 함수
exports.generateSpreadInterpretation = onCall(
    { secrets: [geminiApiKey] },
    async (request) => {
        const data = request.data;
        
        try {
            if (!genAI) {
                const apiKey = geminiApiKey.value();
                if (!apiKey) {
                    throw new Error('서비스 설정 오류가 발생했습니다.');
                }
                genAI = new GoogleGenerativeAI(apiKey);
            }

            const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
            
            let prompt = '';
            const { spreadType, cards, userMood } = data;
            const language = data.language || 'en';
            const languageInstruction = getLanguageInstruction(language);
            
            console.log(`Generating spread interpretation for language: ${language}`);
            
            // For all languages, use English prompt with language instruction
            switch (spreadType) {
                case 'threeCard':
                        prompt = `
You are a tarot expert. Clearly interpret the past-present-future flow.

User mood: ${userMood}

Cards:
Past: ${cards[0].name}
Present: ${cards[1].name}
Future: ${cards[2].name}

Concisely in the following format:

[Overall Flow]
The connection between the three cards (1-2 sentences)

[Time-based Interpretation]
• Past: The influence left by ${cards[0].name}
• Present: Current situation as seen through ${cards[1].name}
• Future: Possibilities shown by ${cards[2].name}

[Action Guidelines]
• What to learn from the past
• What to focus on now
• Preparation for the future

[Core Advice]
The first thing you should do (1-2 sentences)

Rules:
- Keep within 15 sentences total
- Emphasize temporal flow
- Provide actionable advice
`;
                    } else {
                        prompt = `
너는 타로 전문가야. 과거-현재-미래의 흐름을 명확히 해석해.

사용자 기분: ${userMood}

카드:
과거: ${cards[0].nameKr}
현재: ${cards[1].nameKr}
미래: ${cards[2].nameKr}

다음 형식으로 간결하게:

[전체 흐름]
세 카드의 연결점 (1-2문장)

[시간대별 해석]
• 과거: ${cards[0].nameKr}가 남긴 영향
• 현재: ${cards[1].nameKr}로 본 지금 상황
• 미래: ${cards[2].nameKr}가 보여주는 가능성

[행동 지침]
• 과거에서 배울 점
• 현재 집중할 일
• 미래를 위한 준비

[핵심 조언]
당신이 가장 먼저 해야 할 일 (1-2문장)

규칙:
- 전체 15문장 이내
- 시간의 흐름 강조
- 실천 가능한 조언
`;
                    }
                    break;
                    
                case 'celticCross':
                    if (language === 'en') {
                        prompt = `
You are a tarot master. Systematically analyze the 10-card Celtic Cross.
Do not use markdown syntax. No asterisks, hashtags, or brackets.

User mood: ${userMood}

Card Layout:
1. Current Situation: ${cards[0].name}
2. Challenge/Obstacle: ${cards[1].name}
3. Conscious Goal: ${cards[2].name}
4. Unconscious Foundation: ${cards[3].name}
5. Recent Past: ${cards[4].name}
6. Near Future: ${cards[5].name}
7. Your Attitude: ${cards[6].name}
8. External Influences: ${cards[7].name}
9. Hopes and Fears: ${cards[8].name}
10. Final Outcome: ${cards[9].name}

Interpret cleanly in the following format:

Core Situation Analysis
The key issue seen through ${cards[0].name} and ${cards[1].name} in 2-3 sentences

Inner Conflict
Conscious: ${cards[2].name} - What you outwardly want
Unconscious: ${cards[3].name} - Your true desire
My Attitude: ${cards[6].name} - Actual behavior pattern

Timeline Analysis
Past: ${cards[4].name} - Impact on present
Present: ${cards[0].name} - Current choice faced
Future: ${cards[5].name} - Development within 3 months

External Factors
The environmental influence shown by ${cards[7].name} specifically

Final Forecast
${cards[8].name}: Inner expectations and anxieties
${cards[9].name}: Expected outcome (70% probability)

Step-by-Step Action Plan
1. This week: One specific action
2. This month: Intermediate goal
3. After 3 months: Final goal

Rules:
- Use only subheadings without special characters
- Keep each section to 2-3 sentences
- Repeatedly mention card names
`;
                    } else {
                        prompt = `
너는 타로 마스터야. 10장 켈틱 크로스를 체계적으로 분석해.
마크다운 문법 절대 사용하지 마. 별표나 샵 기호, 대괄호도 쓰지 마.

사용자 기분: ${userMood}

카드 배치:
1. 현재 상황: ${cards[0].nameKr}
2. 도전/장애물: ${cards[1].nameKr}
3. 의식적 목표: ${cards[2].nameKr}
4. 무의식 기반: ${cards[3].nameKr}
5. 최근 과거: ${cards[4].nameKr}
6. 가까운 미래: ${cards[5].nameKr}
7. 자신의 태도: ${cards[6].nameKr}
8. 외부 영향: ${cards[7].nameKr}
9. 희망과 두려움: ${cards[8].nameKr}
10. 최종 결과: ${cards[9].nameKr}

다음 형식으로 깔끔하게 해석:

핵심 상황 분석
${cards[0].nameKr}와 ${cards[1].nameKr}로 본 현재의 핵심 이슈를 2-3문장으로 설명

내면의 갈등
의식: ${cards[2].nameKr} - 겉으로 원하는 것
무의식: ${cards[3].nameKr} - 진짜 욕구
내 태도: ${cards[6].nameKr} - 실제 행동 패턴

시간축 분석
과거: ${cards[4].nameKr} - 현재에 미친 영향
현재: ${cards[0].nameKr} - 지금 직면한 선택
미래: ${cards[5].nameKr} - 3개월 내 전개

외부 요인
${cards[7].nameKr}가 보여주는 주변 환경의 영향을 구체적으로

최종 전망
${cards[8].nameKr}: 내면의 기대와 불안
${cards[9].nameKr}: 예상되는 결과 (70% 확률)

단계별 실천 계획
1. 이번 주: 구체적 행동 한 가지
2. 이번 달: 중간 목표
3. 3개월 후: 최종 목표

규칙:
- 소제목만 사용하고 특수문자 없이
- 각 섹션 2-3문장으로 간결하게
- 카드 이름 반복해서 언급
`;
                    }
                    break;
                    
                case 'relationship':
                    if (language === 'en') {
                        prompt = `
You are a tarot expert and relationship counselor. Delicately analyze relationship dynamics.
Do not use markdown syntax. Absolutely no asterisks.

User mood: ${userMood}

Relationship Card Layout:
1. My Role: ${cards[0].name}
2. Partner's Role: ${cards[1].name}
3. Relationship Essence: ${cards[2].name}
4. My True Feelings: ${cards[3].name}
5. Partner's Heart: ${cards[4].name}
6. Problem to Solve: ${cards[5].name}
7. Relationship Future: ${cards[6].name}

Interpret emotionally and warmly:

The Energy of Two People
You (${cards[0].name}): Your role and characteristics in the relationship
Partner (${cards[1].name}): Their tendencies and attitudes
Chemistry (${cards[2].name}): The synergy when you two meet

Heart Temperature Difference
Your True Feelings (${cards[3].name}): Hidden emotions
Partner's Heart (${cards[4].name}): Expected emotions (Temperature: 70 degrees)

Relationship Obstacles
Core problem and solution direction indicated by ${cards[5].name}

Future Possibilities
Relationship development probability seen through ${cards[6].name}: 75%

Advice for Love
1. Communication: "To open their heart..."
2. Dating: Activities to do together this week
3. Mindset: Attitude for relationship improvement

One-Line Advice
💕 A warm word that penetrates the core of the relationship

Rules:
- Emotional and empathetic tone
- Specific action suggestions
- Balance both perspectives
`;
                    } else {
                        prompt = `
너는 타로 전문가이자 연애 상담사야. 관계의 역학을 섬세하게 분석해.
마크다운 문법 쓰지 마. 별표 기호 절대 금지.

사용자 기분: ${userMood}

관계 카드 배치:
1. 나의 역할: ${cards[0].nameKr}
2. 상대의 역할: ${cards[1].nameKr}
3. 관계의 본질: ${cards[2].nameKr}
4. 내 진심: ${cards[3].nameKr}
5. 상대의 마음: ${cards[4].nameKr}
6. 해결할 문제: ${cards[5].nameKr}
7. 관계의 미래: ${cards[6].nameKr}

감성적이고 따뜻하게 해석:

두 사람의 에너지
당신(${cards[0].nameKr}): 관계에서의 역할과 특징
상대(${cards[1].nameKr}): 상대방의 성향과 태도  
케미(${cards[2].nameKr}): 둘이 만났을 때 시너지

마음의 온도차
당신의 진심(${cards[3].nameKr}): 숨겨진 감정
상대의 마음(${cards[4].nameKr}): 예상되는 감정 (온도: 70도)

관계의 걸림돌
${cards[5].nameKr}가 암시하는 핵심 문제와 해결 방향

미래 가능성
${cards[6].nameKr}로 본 관계 발전 확률: 75%

사랑을 위한 조언
1. 대화법: "상대방의 마음을 열려면..."
2. 데이트: 이번 주 함께하면 좋을 활동
3. 마음가짐: 관계 개선을 위한 태도

한 줄 조언
💕 관계의 핵심을 꿰뚫는 따뜻한 한마디

규칙:
- 감성적이고 공감적인 톤
- 구체적인 행동 제안
- 양쪽 입장 균형있게
`;
                    }
                    break;
                    
                case 'yesNo':
                    if (language === 'en') {
                        prompt = `
You are a tarot expert. Make a clear yes/no judgment.
Do not use markdown syntax like asterisks or hashtags.

User mood: ${userMood}

5 cards drawn:
${cards.map(c => c.name).join(', ')}

Answer exactly in the format below:

Final Answer
Analyze the drawn cards comprehensively and choose only one of these three:
⭕ Yes
❌ No
⚠️ Conditional Yes

Judgment Basis
Count positive and negative cards specifically.
Example: Positive cards: 3 (The Sun, The Star, The World)
Negative cards: 1 (The Tower)
Neutral cards: 1 (The Hermit)

Core Message
The key message from the cards in 1-2 sentences

Success Conditions
To become "Yes": 1-2 specific conditions

Timing Prediction
Possible realization period: 2 weeks ~ 2 months

Action Guide
1-2 things to do now regardless of the answer

Rules:
- Choose only one final answer
- Show probability as percentage (75%)
- Be clear without ambiguity
- Suggest alternatives or workarounds
`;
                    } else {
                        prompt = `
너는 타로 전문가야. 예/아니오를 명확히 판단해.
별표나 샵 같은 마크다운 문법 사용 금지.

사용자 기분: ${userMood}

뽑은 5장:
${cards.map(c => c.nameKr).join(', ')}

아래 형식대로 정확히 답변해:

최종 답변
뽑힌 카드들을 종합 분석하여 다음 세 가지 중 하나만 선택해서 답해:
⭕ 예
❌ 아니오  
⚠️ 조건부 예

판단 근거
긍정적인 카드와 부정적인 카드를 세어서 구체적으로 적어.
예시: 긍정 카드: 3장 (태양, 별, 세계)
부정 카드: 1장 (탑)
중립 카드: 1장 (은둔자)

핵심 메시지
카드들이 말하는 핵심을 1-2문장으로

성공 조건
"예"가 되려면: 구체적 조건 1-2개

시기 예측
실현 가능 시기: 2주 ~ 2개월

행동 가이드
답변과 관계없이 지금 해야 할 일 1-2가지

규칙:
- 최종 답변은 반드시 하나만 선택
- 퍼센트로 확률 표시 (75%)
- 애매모호함 없이 명확하게
- 대안이나 우회로 제시
`;
                    }
                    break;
                    
                default:
                    if (language === 'en') {
                        prompt = `
Tarot cards: ${cards.map(c => c.name).join(', ')}
User mood: ${userMood}
Spread type: ${spreadType}

Please provide a comprehensive interpretation of these cards in English.
`;
                    } else {
                        prompt = `
타로 카드들: ${cards.map(c => c.nameKr).join(', ')}
사용자 기분: ${userMood}
배열법: ${spreadType}

이 카드들의 의미를 종합적으로 해석해주세요. 한국어로 답변해주세요.
`;
                    }
            }

            const result = await model.generateContent(prompt);
            const interpretation = result.response.text();

            return {
                interpretation: interpretation
            };

        } catch (error) {
            console.error('Spread interpretation error:', error);
            throw new Error('스프레드 해석 중 오류가 발생했습니다.');
        }
    }
);

// 채팅 응답 함수
exports.generateChatResponse = onCall(
    { secrets: [geminiApiKey] },
    async (request) => {
        const data = request.data;
        
        try {
            if (!genAI) {
                const apiKey = geminiApiKey.value();
                if (!apiKey) {
                    throw new Error('서비스 설정 오류가 발생했습니다.');
                }
                genAI = new GoogleGenerativeAI(apiKey);
            }

            const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });

            // 대화 히스토리 변환
            const history = data.previousMessages?.map(msg => ({
                role: msg.role === 'user' ? 'user' : 'model',
                parts: [{ text: msg.content }]
            })) || [];

            // 언어 설정
            const language = data.language || 'en'; // 기본값을 영어로 변경
            
            console.log(`Generating chat response for language: ${language}`);
            
            // 컨텍스트 추가
            const spreadContext = data.spreadType 
                ? language === 'en' 
                    ? `\nSpread used: ${data.spreadType}`
                    : `\n사용한 배열: ${data.spreadType}`
                : '';
                
            const contextMessage = language === 'en' ? `
Tarot card: ${data.cardName}${spreadContext}
Interpretation summary: ${data.interpretationSummary}

Please provide a friendly and helpful response to the user's new question.
Response style:
- Core message in 2-3 sentences
- Warm and friendly tone
- Include specific examples
- End positively
` : `
타로 카드: ${data.cardName}${spreadContext}
해석 요약: ${data.interpretationSummary}

사용자의 새로운 질문에 대해 친근하고 도움이 되는 답변을 해주세요.
답변 스타일:
- 2-3문장으로 핵심만
- 따뜻하고 친근한 톤
- 구체적 예시 포함
- 긍정적 마무리
`;

            // 대화 시작
            const chat = model.startChat({
                history: [
                    {
                        role: 'user',
                        parts: [{ text: contextMessage }]
                    },
                    {
                        role: 'model',
                        parts: [{ 
                            text: language === 'en' 
                                ? 'I understand. Feel free to ask me anything about your tarot cards!'
                                : '네, 타로 카드에 대해 궁금한 점을 편하게 물어보세요!' 
                        }]
                    },
                    ...history
                ]
            });

            const result = await chat.sendMessage(data.userMessage);
            const response = result.response.text();

            return { response };

        } catch (error) {
            console.error('Chat Error:', error);
            throw new Error('채팅 응답 생성 중 오류가 발생했습니다.');
        }
    }
);