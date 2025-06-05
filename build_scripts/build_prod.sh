#!/bin/bash

# Production 빌드 스크립트
# 사용법: ./build_scripts/build_prod.sh

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Production Build...${NC}"

# 환경 변수 설정 (실제 프로덕션 ID로 교체 필요)
ADMOB_INTERSTITIAL_ID="ca-app-pub-YOUR-REAL-ID/YOUR-INTERSTITIAL-ID"
ADMOB_REWARDED_ID="ca-app-pub-YOUR-REAL-ID/YOUR-REWARDED-ID"
FIREBASE_PROJECT_ID="your-firebase-project-id"

# 빌드 전 정리
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean

# pub get
echo -e "${YELLOW}📦 Getting dependencies...${NC}"
flutter pub get

# Android 프로덕션 빌드
echo -e "${GREEN}🤖 Building Android Release...${NC}"
flutter build apk --release \
  --dart-define=ENV=production \
  --dart-define=ADMOB_INTERSTITIAL_ID=$ADMOB_INTERSTITIAL_ID \
  --dart-define=ADMOB_REWARDED_ID=$ADMOB_REWARDED_ID \
  --dart-define=FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID \
  --obfuscate \
  --split-debug-info=build/debug-info

# iOS 프로덕션 빌드
echo -e "${GREEN}🍎 Building iOS Release...${NC}"
flutter build ios --release \
  --dart-define=ENV=production \
  --dart-define=ADMOB_INTERSTITIAL_ID=$ADMOB_INTERSTITIAL_ID \
  --dart-define=ADMOB_REWARDED_ID=$ADMOB_REWARDED_ID \
  --dart-define=FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID \
  --obfuscate \
  --split-debug-info=build/debug-info

echo -e "${GREEN}✅ Production build completed!${NC}"
echo -e "${YELLOW}📍 APK Location: build/app/outputs/flutter-apk/app-release.apk${NC}"