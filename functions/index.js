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

// Helper function to get section titles by language
function getSectionTitles(language, spreadType = 'single') {
    const titles = {
        en: {
            single: {
                cardMessage: '[Card Message]',
                currentSituation: '[Current Situation]',
                practicalAdvice: '[Practical Advice]',
                futureOutlook: '[Future Outlook]'
            },
            threeCard: {
                overallFlow: '[Overall Flow]',
                timeBasedInterpretation: '[Time-based Interpretation]',
                actionGuidelines: '[Action Guidelines]',
                coreAdvice: '[Core Advice]'
            }
        },
        ko: {
            single: {
                cardMessage: '[카드의 메시지]',
                currentSituation: '[현재 상황]',
                practicalAdvice: '[실천 조언]',
                futureOutlook: '[앞으로의 전망]'
            },
            threeCard: {
                overallFlow: '[전체 흐름]',
                timeBasedInterpretation: '[시간대별 해석]',
                actionGuidelines: '[행동 지침]',
                coreAdvice: '[핵심 조언]'
            }
        },
        ja: {
            single: {
                cardMessage: '[カードのメッセージ]',
                currentSituation: '[現在の状況]',
                practicalAdvice: '[実践的なアドバイス]',
                futureOutlook: '[今後の展望]'
            },
            threeCard: {
                overallFlow: '[全体の流れ]',
                timeBasedInterpretation: '[時間軸の解釈]',
                actionGuidelines: '[行動指針]',
                coreAdvice: '[核心的なアドバイス]'
            }
        },
        zh: {
            single: {
                cardMessage: '[卡牌信息]',
                currentSituation: '[当前情况]',
                practicalAdvice: '[实践建议]',
                futureOutlook: '[未来展望]'
            },
            threeCard: {
                overallFlow: '[整体流程]',
                timeBasedInterpretation: '[时间轴解释]',
                actionGuidelines: '[行动指南]',
                coreAdvice: '[核心建议]'
            }
        },
        es: {
            single: {
                cardMessage: '[Mensaje de la Carta]',
                currentSituation: '[Situación Actual]',
                practicalAdvice: '[Consejo Práctico]',
                futureOutlook: '[Perspectiva Futura]'
            },
            threeCard: {
                overallFlow: '[Flujo General]',
                timeBasedInterpretation: '[Interpretación Temporal]',
                actionGuidelines: '[Pautas de Acción]',
                coreAdvice: '[Consejo Principal]'
            }
        },
        fr: {
            single: {
                cardMessage: '[Message de la Carte]',
                currentSituation: '[Situation Actuelle]',
                practicalAdvice: '[Conseils Pratiques]',
                futureOutlook: '[Perspectives Futures]'
            },
            threeCard: {
                overallFlow: '[Vue d\'ensemble]',
                timeBasedInterpretation: '[Interprétation Temporelle]',
                actionGuidelines: '[Directives d\'Action]',
                coreAdvice: '[Conseil Principal]'
            }
        },
        de: {
            single: {
                cardMessage: '[Kartenbotschaft]',
                currentSituation: '[Aktuelle Situation]',
                practicalAdvice: '[Praktischer Rat]',
                futureOutlook: '[Zukunftsaussichten]'
            },
            threeCard: {
                overallFlow: '[Gesamtfluss]',
                timeBasedInterpretation: '[Zeitbasierte Interpretation]',
                actionGuidelines: '[Handlungsrichtlinien]',
                coreAdvice: '[Kernratschlag]'
            }
        },
        pt: {
            single: {
                cardMessage: '[Mensagem da Carta]',
                currentSituation: '[Situação Atual]',
                practicalAdvice: '[Conselho Prático]',
                futureOutlook: '[Perspectiva Futura]'
            },
            threeCard: {
                overallFlow: '[Fluxo Geral]',
                timeBasedInterpretation: '[Interpretação Temporal]',
                actionGuidelines: '[Diretrizes de Ação]',
                coreAdvice: '[Conselho Principal]'
            }
        },
        hi: {
            single: {
                cardMessage: '[कार्ड संदेश]',
                currentSituation: '[वर्तमान स्थिति]',
                practicalAdvice: '[व्यावहारिक सलाह]',
                futureOutlook: '[भविष्य की संभावनाएं]'
            },
            threeCard: {
                overallFlow: '[समग्र प्रवाह]',
                timeBasedInterpretation: '[समय आधारित व्याख्या]',
                actionGuidelines: '[कार्य दिशानिर्देश]',
                coreAdvice: '[मुख्य सलाह]'
            }
        },
        vi: {
            single: {
                cardMessage: '[Thông Điệp Lá Bài]',
                currentSituation: '[Tình Hình Hiện Tại]',
                practicalAdvice: '[Lời Khuyên Thực Tiễn]',
                futureOutlook: '[Triển Vọng Tương Lai]'
            },
            threeCard: {
                overallFlow: '[Dòng Chảy Tổng Thể]',
                timeBasedInterpretation: '[Diễn Giải Theo Thời Gian]',
                actionGuidelines: '[Hướng Dẫn Hành Động]',
                coreAdvice: '[Lời Khuyên Cốt Lõi]'
            }
        },
        th: {
            single: {
                cardMessage: '[ข้อความจากไพ่]',
                currentSituation: '[สถานการณ์ปัจจุบัน]',
                practicalAdvice: '[คำแนะนำเชิงปฏิบัติ]',
                futureOutlook: '[แนวโน้มในอนาคต]'
            },
            threeCard: {
                overallFlow: '[ภาพรวม]',
                timeBasedInterpretation: '[การตีความตามเวลา]',
                actionGuidelines: '[แนวทางการปฏิบัติ]',
                coreAdvice: '[คำแนะนำหลัก]'
            }
        }
    };
    
    // Default to English if language not found
    const langTitles = titles[language] || titles.en;
    return langTitles[spreadType] || langTitles.single;
}

// Helper function to get Celtic Cross section titles by language
function getCelticCrossSectionTitles(language) {
    const titles = {
        en: {
            coreSituation: '[Core Situation Analysis]',
            innerConflict: '[Inner Conflict]',
            timelineAnalysis: '[Timeline Analysis]',
            externalFactors: '[External Factors]',
            finalForecast: '[Final Forecast]',
            actionPlan: '[Step-by-Step Action Plan]'
        },
        ko: {
            coreSituation: '[핵심 상황 분석]',
            innerConflict: '[내면의 갈등]',
            timelineAnalysis: '[시간축 분석]',
            externalFactors: '[외부 요인]',
            finalForecast: '[최종 전망]',
            actionPlan: '[단계별 행동 계획]'
        },
        ja: {
            coreSituation: '[核心状況分析]',
            innerConflict: '[内なる葛藤]',
            timelineAnalysis: '[タイムライン分析]',
            externalFactors: '[外的要因]',
            finalForecast: '[最終予測]',
            actionPlan: '[段階的行動計画]'
        },
        zh: {
            coreSituation: '[核心情况分析]',
            innerConflict: '[内心冲突]',
            timelineAnalysis: '[时间线分析]',
            externalFactors: '[外部因素]',
            finalForecast: '[最终预测]',
            actionPlan: '[分步行动计划]'
        },
        es: {
            coreSituation: '[Análisis de la Situación Central]',
            innerConflict: '[Conflicto Interior]',
            timelineAnalysis: '[Análisis Temporal]',
            externalFactors: '[Factores Externos]',
            finalForecast: '[Pronóstico Final]',
            actionPlan: '[Plan de Acción Paso a Paso]'
        },
        fr: {
            coreSituation: '[Analyse de la Situation Centrale]',
            innerConflict: '[Conflit Intérieur]',
            timelineAnalysis: '[Analyse Chronologique]',
            externalFactors: '[Facteurs Externes]',
            finalForecast: '[Prévision Finale]',
            actionPlan: '[Plan d\'Action Étape par Étape]'
        },
        de: {
            coreSituation: '[Kernsituationsanalyse]',
            innerConflict: '[Innerer Konflikt]',
            timelineAnalysis: '[Zeitlinienanalyse]',
            externalFactors: '[Externe Faktoren]',
            finalForecast: '[Endprognose]',
            actionPlan: '[Schrittweiser Aktionsplan]'
        },
        pt: {
            coreSituation: '[Análise da Situação Central]',
            innerConflict: '[Conflito Interior]',
            timelineAnalysis: '[Análise Temporal]',
            externalFactors: '[Fatores Externos]',
            finalForecast: '[Previsão Final]',
            actionPlan: '[Plano de Ação Passo a Passo]'
        },
        hi: {
            coreSituation: '[मुख्य स्थिति विश्लेषण]',
            innerConflict: '[आंतरिक संघर्ष]',
            timelineAnalysis: '[समयरेखा विश्लेषण]',
            externalFactors: '[बाहरी कारक]',
            finalForecast: '[अंतिम पूर्वानुमान]',
            actionPlan: '[चरणबद्ध कार्य योजना]'
        },
        vi: {
            coreSituation: '[Phân Tích Tình Huống Cốt Lõi]',
            innerConflict: '[Xung Đột Nội Tâm]',
            timelineAnalysis: '[Phân Tích Dòng Thời Gian]',
            externalFactors: '[Yếu Tố Bên Ngoài]',
            finalForecast: '[Dự Báo Cuối Cùng]',
            actionPlan: '[Kế Hoạch Hành Động Từng Bước]'
        },
        th: {
            coreSituation: '[การวิเคราะห์สถานการณ์หลัก]',
            innerConflict: '[ความขัดแย้งภายใน]',
            timelineAnalysis: '[การวิเคราะห์เส้นเวลา]',
            externalFactors: '[ปัจจัยภายนอก]',
            finalForecast: '[การคาดการณ์สุดท้าย]',
            actionPlan: '[แผนปฏิบัติการทีละขั้นตอน]'
        }
    };
    
    // Default to English if language not found
    return titles[language] || titles.en;
}

// Helper function to get Relationship spread section titles by language
function getRelationshipSectionTitles(language) {
    const titles = {
        en: {
            energyOfTwo: '[The Energy of Two People]',
            heartTemperature: '[Heart Temperature Difference]',
            obstacles: '[Relationship Obstacles]',
            futurePossibilities: '[Future Possibilities]',
            adviceForLove: '[Advice for Love]',
            oneLineAdvice: '[One-Line Advice]'
        },
        ko: {
            energyOfTwo: '[두 사람의 에너지]',
            heartTemperature: '[마음의 온도 차이]',
            obstacles: '[관계의 장애물]',
            futurePossibilities: '[미래의 가능성]',
            adviceForLove: '[사랑을 위한 조언]',
            oneLineAdvice: '[한 줄 조언]'
        },
        ja: {
            energyOfTwo: '[二人のエネルギー]',
            heartTemperature: '[心の温度差]',
            obstacles: '[関係の障害]',
            futurePossibilities: '[未来の可能性]',
            adviceForLove: '[愛のためのアドバイス]',
            oneLineAdvice: '[一言アドバイス]'
        },
        zh: {
            energyOfTwo: '[两人的能量]',
            heartTemperature: '[心温差异]',
            obstacles: '[关系障碍]',
            futurePossibilities: '[未来可能性]',
            adviceForLove: '[爱情建议]',
            oneLineAdvice: '[一句忠告]'
        },
        es: {
            energyOfTwo: '[La Energía de Dos Personas]',
            heartTemperature: '[Diferencia de Temperatura del Corazón]',
            obstacles: '[Obstáculos en la Relación]',
            futurePossibilities: '[Posibilidades Futuras]',
            adviceForLove: '[Consejo para el Amor]',
            oneLineAdvice: '[Consejo en Una Línea]'
        },
        fr: {
            energyOfTwo: '[L\'Énergie de Deux Personnes]',
            heartTemperature: '[Différence de Température du Cœur]',
            obstacles: '[Obstacles Relationnels]',
            futurePossibilities: '[Possibilités Futures]',
            adviceForLove: '[Conseils pour l\'Amour]',
            oneLineAdvice: '[Conseil en Une Ligne]'
        },
        de: {
            energyOfTwo: '[Die Energie Zweier Menschen]',
            heartTemperature: '[Herztemperaturunterschied]',
            obstacles: '[Beziehungshindernisse]',
            futurePossibilities: '[Zukünftige Möglichkeiten]',
            adviceForLove: '[Rat für die Liebe]',
            oneLineAdvice: '[Einzeiliger Rat]'
        },
        pt: {
            energyOfTwo: '[A Energia de Duas Pessoas]',
            heartTemperature: '[Diferença de Temperatura do Coração]',
            obstacles: '[Obstáculos do Relacionamento]',
            futurePossibilities: '[Possibilidades Futuras]',
            adviceForLove: '[Conselho para o Amor]',
            oneLineAdvice: '[Conselho em Uma Linha]'
        },
        hi: {
            energyOfTwo: '[दो लोगों की ऊर्जा]',
            heartTemperature: '[दिल के तापमान का अंतर]',
            obstacles: '[रिश्ते की बाधाएं]',
            futurePossibilities: '[भविष्य की संभावनाएं]',
            adviceForLove: '[प्रेम के लिए सलाह]',
            oneLineAdvice: '[एक पंक्ति की सलाह]'
        },
        vi: {
            energyOfTwo: '[Năng Lượng Của Hai Người]',
            heartTemperature: '[Chênh Lệch Nhiệt Độ Trái Tim]',
            obstacles: '[Rào Cản Trong Mối Quan Hệ]',
            futurePossibilities: '[Khả Năng Tương Lai]',
            adviceForLove: '[Lời Khuyên Cho Tình Yêu]',
            oneLineAdvice: '[Lời Khuyên Một Dòng]'
        },
        th: {
            energyOfTwo: '[พลังงานของคนสองคน]',
            heartTemperature: '[ความแตกต่างของอุณหภูมิหัวใจ]',
            obstacles: '[อุปสรรคในความสัมพันธ์]',
            futurePossibilities: '[ความเป็นไปได้ในอนาคต]',
            adviceForLove: '[คำแนะนำเพื่อความรัก]',
            oneLineAdvice: '[คำแนะนำหนึ่งบรรทัด]'
        }
    };
    
    // Default to English if language not found
    return titles[language] || titles.en;
}

// Helper function to get Yes/No spread section titles by language
function getYesNoSectionTitles(language) {
    const titles = {
        en: {
            finalAnswer: '[Final Answer]',
            judgmentBasis: '[Judgment Basis]',
            coreMessage: '[Core Message]',
            successConditions: '[Success Conditions]',
            timingPrediction: '[Timing Prediction]',
            actionGuide: '[Action Guide]'
        },
        ko: {
            finalAnswer: '[최종 답변]',
            judgmentBasis: '[판단 근거]',
            coreMessage: '[핵심 메시지]',
            successConditions: '[성공 조건]',
            timingPrediction: '[시기 예측]',
            actionGuide: '[행동 가이드]'
        },
        ja: {
            finalAnswer: '[最終回答]',
            judgmentBasis: '[判断根拠]',
            coreMessage: '[核心メッセージ]',
            successConditions: '[成功条件]',
            timingPrediction: '[時期予測]',
            actionGuide: '[行動ガイド]'
        },
        zh: {
            finalAnswer: '[最终答案]',
            judgmentBasis: '[判断依据]',
            coreMessage: '[核心信息]',
            successConditions: '[成功条件]',
            timingPrediction: '[时机预测]',
            actionGuide: '[行动指南]'
        },
        es: {
            finalAnswer: '[Respuesta Final]',
            judgmentBasis: '[Base del Juicio]',
            coreMessage: '[Mensaje Central]',
            successConditions: '[Condiciones de Éxito]',
            timingPrediction: '[Predicción de Tiempo]',
            actionGuide: '[Guía de Acción]'
        },
        fr: {
            finalAnswer: '[Réponse Finale]',
            judgmentBasis: '[Base du Jugement]',
            coreMessage: '[Message Central]',
            successConditions: '[Conditions de Réussite]',
            timingPrediction: '[Prédiction de Timing]',
            actionGuide: '[Guide d\'Action]'
        },
        de: {
            finalAnswer: '[Endgültige Antwort]',
            judgmentBasis: '[Urteilsgrundlage]',
            coreMessage: '[Kernbotschaft]',
            successConditions: '[Erfolgsbedingungen]',
            timingPrediction: '[Zeitvorhersage]',
            actionGuide: '[Handlungsleitfaden]'
        },
        pt: {
            finalAnswer: '[Resposta Final]',
            judgmentBasis: '[Base do Julgamento]',
            coreMessage: '[Mensagem Central]',
            successConditions: '[Condições de Sucesso]',
            timingPrediction: '[Previsão de Tempo]',
            actionGuide: '[Guia de Ação]'
        },
        hi: {
            finalAnswer: '[अंतिम उत्तर]',
            judgmentBasis: '[निर्णय का आधार]',
            coreMessage: '[मुख्य संदेश]',
            successConditions: '[सफलता की शर्तें]',
            timingPrediction: '[समय पूर्वानुमान]',
            actionGuide: '[कार्य मार्गदर्शिका]'
        },
        vi: {
            finalAnswer: '[Câu Trả Lời Cuối Cùng]',
            judgmentBasis: '[Cơ Sở Phán Đoán]',
            coreMessage: '[Thông Điệp Cốt Lõi]',
            successConditions: '[Điều Kiện Thành Công]',
            timingPrediction: '[Dự Đoán Thời Gian]',
            actionGuide: '[Hướng Dẫn Hành Động]'
        },
        th: {
            finalAnswer: '[คำตอบสุดท้าย]',
            judgmentBasis: '[เหตุผลในการตัดสิน]',
            coreMessage: '[ข้อความหลัก]',
            successConditions: '[เงื่อนไขความสำเร็จ]',
            timingPrediction: '[การคาดการณ์เวลา]',
            actionGuide: '[คู่มือการดำเนินการ]'
        }
    };
    
    // Default to English if language not found
    return titles[language] || titles.en;
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
            const languageInstruction = getLanguageInstruction(language);
            const sectionTitles = getSectionTitles(language, 'single');
            
            console.log(`Generating interpretation for language: ${language}`);
            
            if (data.interpretationType === 'single') {
                prompt = `
You are a tarot master with 50 years of experience. Be concise and deliver only the essence.

User mood: ${data.userMood}
Card drawn: ${data.cardName}

Please interpret in the following format:

${sectionTitles.cardMessage}
The core message this card conveys (1-2 sentences)

${sectionTitles.currentSituation}
The cause of your ${data.userMood} mood and current state (2-3 sentences)

${sectionTitles.practicalAdvice}
• What to do today
• Goals for this week
• Changes within a month

${sectionTitles.futureOutlook}
Prediction of positive changes (1-2 sentences)

Rules:
- Keep within 8-10 sentences total
- Use simple words only
- Suggest specific actions
- Use the exact section headers as provided above in square brackets

${languageInstruction}
`;
            } else {
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
            
            switch (spreadType) {
                case 'threeCard':
                    const threeCardTitles = getSectionTitles(language, 'threeCard');
                    prompt = `
You are a tarot expert. Clearly interpret the past-present-future flow.

User mood: ${userMood}

Cards:
Past: ${cards[0].name}
Present: ${cards[1].name}
Future: ${cards[2].name}

Concisely in the following format:

${threeCardTitles.overallFlow}
The connection between the three cards (1-2 sentences)

${threeCardTitles.timeBasedInterpretation}
• Past: The influence left by ${cards[0].name}
• Present: Current situation as seen through ${cards[1].name}
• Future: Possibilities shown by ${cards[2].name}

${threeCardTitles.actionGuidelines}
• What to learn from the past
• What to focus on now
• Preparation for the future

${threeCardTitles.coreAdvice}
The first thing you should do (1-2 sentences)

Rules:
- Keep within 15 sentences total
- Emphasize temporal flow
- Provide actionable advice
- Use the exact section headers as provided above in square brackets

${languageInstruction}
`;
                    break;
                    
                case 'celticCross':
                    const celticCrossTitles = getCelticCrossSectionTitles(language);
                    prompt = `
You are a tarot master. Systematically analyze the 10-card Celtic Cross.
Do not use markdown syntax. No asterisks, hashtags, or special characters except for the section headers in square brackets.

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

${celticCrossTitles.coreSituation}
The key issue seen through ${cards[0].name} and ${cards[1].name} in 2-3 sentences

${celticCrossTitles.innerConflict}
Conscious: ${cards[2].name} - What you outwardly want
Unconscious: ${cards[3].name} - Your true desire
My Attitude: ${cards[6].name} - Actual behavior pattern

${celticCrossTitles.timelineAnalysis}
Past: ${cards[4].name} - Impact on present
Present: ${cards[0].name} - Current choice faced
Future: ${cards[5].name} - Development within 3 months

${celticCrossTitles.externalFactors}
The environmental influence shown by ${cards[7].name} specifically

${celticCrossTitles.finalForecast}
${cards[8].name}: Inner expectations and anxieties
${cards[9].name}: Expected outcome (70% probability)

${celticCrossTitles.actionPlan}
1. This week: One specific action
2. This month: Intermediate goal
3. After 3 months: Final goal

Rules:
- Use the exact section headers as provided above in square brackets
- Keep each section to 2-3 sentences
- Repeatedly mention card names

${languageInstruction}
`;
                    break;
                    
                case 'relationship':
                    const relationshipTitles = getRelationshipSectionTitles(language);
                    prompt = `
You are a tarot expert and relationship counselor. Delicately analyze relationship dynamics.
Do not use markdown syntax. Absolutely no asterisks or special characters except for the section headers in square brackets.

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

${relationshipTitles.energyOfTwo}
You (${cards[0].name}): Your role and characteristics in the relationship
Partner (${cards[1].name}): Their tendencies and attitudes
Chemistry (${cards[2].name}): The synergy when you two meet

${relationshipTitles.heartTemperature}
Your True Feelings (${cards[3].name}): Hidden emotions
Partner's Heart (${cards[4].name}): Expected emotions (Temperature: 70 degrees)

${relationshipTitles.obstacles}
Core problem and solution direction indicated by ${cards[5].name}

${relationshipTitles.futurePossibilities}
Relationship development probability seen through ${cards[6].name}: 75%

${relationshipTitles.adviceForLove}
1. Communication: "To open their heart..."
2. Dating: Activities to do together this week
3. Mindset: Attitude for relationship improvement

${relationshipTitles.oneLineAdvice}
💕 A warm word that penetrates the core of the relationship

Rules:
- Use the exact section headers as provided above in square brackets
- Emotional and empathetic tone
- Specific action suggestions
- Balance both perspectives

${languageInstruction}
`;
                    break;
                    
                case 'yesNo':
                    const yesNoTitles = getYesNoSectionTitles(language);
                    prompt = `
You are a tarot expert. Make a clear yes/no judgment.
Do not use markdown syntax like asterisks or hashtags or special characters except for the section headers in square brackets.

User mood: ${userMood}

5 cards drawn:
${cards.map(c => c.name).join(', ')}

Answer exactly in the format below:

${yesNoTitles.finalAnswer}
Analyze the drawn cards comprehensively and choose only one of these three:
⭕ Yes
❌ No
⚠️ Conditional Yes

${yesNoTitles.judgmentBasis}
Count positive and negative cards specifically.
Example: Positive cards: 3 (The Sun, The Star, The World)
Negative cards: 1 (The Tower)
Neutral cards: 1 (The Hermit)

${yesNoTitles.coreMessage}
The key message from the cards in 1-2 sentences

${yesNoTitles.successConditions}
To become "Yes": 1-2 specific conditions

${yesNoTitles.timingPrediction}
Possible realization period: 2 weeks ~ 2 months

${yesNoTitles.actionGuide}
1-2 things to do now regardless of the answer

Rules:
- Use the exact section headers as provided above in square brackets
- Choose only one final answer
- Show probability as percentage (75%)
- Be clear without ambiguity
- Suggest alternatives or workarounds

${languageInstruction}
`;
                    break;
                    
                default:
                    prompt = `
Tarot cards: ${cards.map(c => c.name).join(', ')}
User mood: ${userMood}
Spread type: ${spreadType}

Please provide a comprehensive interpretation of these cards.
${languageInstruction}
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

            // 언어 설정
            const language = data.language || 'en';
            const languageInstruction = getLanguageInstruction(language);
            
            console.log(`Generating chat response for language: ${language}`);
            
            // 컨텍스트 추가
            const spreadContext = data.spreadType ? `\nSpread used: ${data.spreadType}` : '';
                
            const contextMessage = `
Tarot card: ${data.cardName}${spreadContext}
Interpretation summary: ${data.interpretationSummary}

Please provide a friendly and helpful response to the user's new question.
Response style:
- Core message in 2-3 sentences
- Warm and friendly tone
- Include specific examples
- End positively

${languageInstruction}
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
                            text: 'I understand. Feel free to ask me anything about your tarot cards!' 
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