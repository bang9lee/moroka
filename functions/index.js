const { onCall } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const admin = require('firebase-admin');
const { GoogleGenerativeAI } = require('@google/generative-ai');

admin.initializeApp();

// 시크릿 정의
const geminiApiKey = defineSecret('GEMINI_API_KEY');

// Gemini API 초기화
let genAI;

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
            
            if (data.interpretationType === 'single') {
                prompt = `
너는 50년 경력의 타로 마스터야. 단순명료하게 핵심만 전달해.

사용자 기분: ${data.userMood}
뽑은 카드: ${data.cardName}

다음 형식으로 짧게 해석해줘:

[카드의 메시지]
이 카드가 전하는 핵심 메시지 (1-2문장)

[현재 상황]
${data.userMood} 기분의 원인과 현재 상태 (2-3문장)

[실천 조언]
• 오늘 당장 할 일
• 이번 주 목표
• 한 달 내 변화

[앞으로의 전망]
긍정적 변화 예측 (1-2문장)

규칙:
- 전체 8-10문장 이내
- 쉬운 단어만 사용
- 구체적 행동 제시
`;
            } else {
                prompt = `
타로 카드: ${data.cardName}
사용자 기분: ${data.userMood}

이 카드의 의미를 해석해주세요. 한국어로 답변해주세요.
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
            
            switch (spreadType) {
                case 'threeCard':
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
                    break;
                    
                case 'celticCross':
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
                    break;
                    
                case 'relationship':
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
                    break;
                    
                case 'yesNo':
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
                    break;
                    
                default:
                    prompt = `
타로 카드들: ${cards.map(c => c.nameKr).join(', ')}
사용자 기분: ${userMood}
배열법: ${spreadType}

이 카드들의 의미를 종합적으로 해석해주세요. 한국어로 답변해주세요.
`;
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

            // 컨텍스트 추가
            const spreadContext = data.spreadType 
                ? `\n사용한 배열: ${data.spreadType}`
                : '';
                
            const contextMessage = `
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
                        parts: [{ text: '네, 타로 카드에 대해 궁금한 점을 편하게 물어보세요!' }]
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