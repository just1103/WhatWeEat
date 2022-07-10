# 우리뭐먹지 

## 목차
- [🍙 프로젝트 소개](#🍙-프로젝트-소개)
- [📱 구현 화면](#📱-구현-화면)
- [🗺 Architecture](#🗺-Architecture)
- [🗂 파일 디렉토리 구조](#🗂-파일-디렉토리-구조)
- [🍙 프로젝트 명세서 및 관련 PR](#🍙-프로젝트-명세서-및-관련-PR)
- [🍙 고민한 점 및 Trouble Shooting](#🍙-고민한-점-및-Trouble-Shooting) 
   - [STEP1. `Onboarding` 화면 구현](#STEP1.-`Onboarding`-화면-구현)
    + [고민한 점](#1-1-고민한-점) 
    + [Trouble Shooting](#1-2-Trouble-Shooting)
    + [키워드](#1-3-키워드)
   - [STEP2. Tab Bar의 `Home` 화면 및 `설정` 화면 구현](#STEP2.-Tab-Bar의-`Home`-화면-및-`설정`-화면-구현)
    + [고민한 점](#2-1-고민한-점)
    + [Trouble Shooting](#2-2-Trouble-Shooting)
    + [키워드](#2-3-키워드)
   - [STEP3. `미니게임` 화면 및 애니메이션 구현](#STEP3.-`미니게임`-화면-및-애니메이션-구현)
    + [고민한 점](#3-1-고민한-점) 
    + [Trouble Shooting](#3-2-Trouble-Shooting)
    + [키워드](#3-3-키워드)
   - [STEP4. `미니게임 결과` 화면 구현 및 리팩토링](#STEP4.-`미니게임-결과`-화면-구현-및-리팩토링)
    + [고민한 점](#4-1-고민한-점) 
    + [Trouble Shooting](#4-2-Trouble-Shooting)
    + [키워드](#4-3-키워드)

## 🍙 프로젝트 소개
- 미니게임으로 사용자의 취향을 분석하여 혼자 또는 여럿이서 먹을 식사메뉴를 추천해주는 iOS 앱   
   🔗 [앱 다운로드 링크](https://apps.apple.com/app/1632157845)
   <img width="1152" alt="image" src="https://user-images.githubusercontent.com/70856586/178147195-49f6ccd8-1972-44aa-8abf-8e054bdc8839.png">

- 팀원
   - iOS : [호댕](https://github.com/yanghojoon), [애플사이다](https://github.com/just1103)
   - 서버 : [핸손](https://github.com/handsone-u)  
   - 앱 디자인 : 윤또
   - 로고 디자인 : [geg_ole](https://www.instagram.com/geg_ole)
- 진행 기간
    - 기획 : 2022.03.27 ~ 2022.04.18 (약 2주)
    - 개발 : 2022.05.19 ~ 2022.07.07 (약 9주)
    - 출시 : 2022.07.07
- Architecture : MVVM-C (ViewModel 복잡도 증가 시 CleanArchitecture 적용 예정)
- ⚙️ 기술 스택    
    - 개발 환경 
        - iOS : swift 5, xcode 13.4
        - 서버 : Java 17, IntelliJ IDEA
    - 라이브러리 : RxSwift, Firebase, Realm, SwiftLint, Lottie / Spring boot
    - Deployment Target : iOS 14.0   
    
## 📱 구현 화면
- 추가 예정

## 🗺 Architecture
- 추가 예정

## 🗂 파일 디렉토리 구조
```
├── WhatWeEat
│   ├── App
│   ├── Presentation
│   │   ├── OnboardingScene
│   │   ├── DislikedFoodSurveyScene
│   │   ├── MainTabBarScene
│   │   │   ├── Home
│   │   │   ├── SoloMenu
│   │   │   ├── TogetherMenu
│   │   ├── GameScene
│   │   ├── ResultWaitingScene
│   │   ├── GameResultScene
│   │   ├── SettingScene
│   │   ├── NetworkErrorScene
│   ├── Model
│   ├── Data
│   │   ├── RemoteDB
│   │   │   ├── Entity
│   │   ├── LocalDB
│   │   │   ├── UserDefaults
│   │   │   ├── Realm
│   ├── Utility
│   ├── Protocol
│   ├── Extension
│   └── Resource
│   │   ├── Font
│   │   ├── Term
└── WhatWeEatTests
    └──Mock
```

## 🍙 프로젝트 명세서 및 관련 PR
### STEP1. `Onboarding` 화면 구현
- [PR-1. Feature/landing: 앱을 처음 실행하는 경우 온보딩 페이지를 실행하도록 합니다](https://github.com/just1103/WhatWeEat/pull/1)
- [PR-2. Realm을 연동하여 못먹는음식 데이터를 Local DB에 저장합니다](https://github.com/just1103/WhatWeEat/pull/2)
### STEP2. Tab Bar의 `Home` 화면 및 `설정` 화면 구현
- [PR-3. 앱 최초실행 시 OnboardingPage, 그 이후에는 MainTabBarController의 Home 화면을 보여줍니다](https://github.com/just1103/WhatWeEat/pull/3)
- [PR-4. 함께메뉴결정 탭 및 혼밥메뉴결정 탭의 미니게임 준비 화면을 보여줍니다](https://github.com/just1103/WhatWeEat/pull/4)
- [PR-5. 네트워크를 구현하여 홈 탭 및 함께메뉴결정 탭에 서버 데이터를 반영합니다](https://github.com/just1103/WhatWeEat/pull/5)
- [PR-6. Main 화면의 NavigationBar 우상단의 설정 버튼을 탭하면 설정 화면이 나타납니다](https://github.com/just1103/WhatWeEat/pull/6)
### STEP3. `미니게임` 화면 및 애니메이션 구현
- [PR-7. Game 화면 및 Game 결과대기 화면을 구현했습니다](https://github.com/just1103/WhatWeEat/pull/7)
### STEP4. `미니게임 결과` 화면 구현 및 리팩토링
- [PR-8. 결과확인하기 버튼을 탭하면 게임결과 화면을 보여줍니다](https://github.com/just1103/WhatWeEat/pull/8)
- [PR-9. 일부 앱사용 로직 및 디자인을 수정했습니다](https://github.com/just1103/WhatWeEat/pull/9)

## 고민한 점 및 Trouble Shooting
### STEP1. `Onboarding` 화면 구현
### 1-1 고민한 점
### 1-2 Trouble Shooting
### 1-3 키워드

### STEP2. Tab Bar의 `Home` 화면 및 `설정` 화면 구현
### 2-1 고민한 점
### 2-2 Trouble Shooting
### 2-3 키워드

### STEP3. `미니게임` 화면 및 애니메이션 구현
### 3-1 고민한 점
### 3-2 Trouble Shooting
### 3-3 키워드

### STEP4. `미니게임 결과` 화면 구현 및 리팩토링
### 4-1 고민한 점
### 4-2 Trouble Shooting
### 4-3 키워드

## 🍙 주간 일정
|일정|주제|내용|
|-|-|-|
|3월 Week-5|💡 아이디어 회의|브레인 스토밍, 와이어프레임 및 Figma 작성|
|4월 Week-1|💡 기술 난이도 및 구현 방향 설정|서버 관련 피드백 요청|
|4월 Week-2|🌐  DB 및 서버 API 설계|메뉴 DB 및 메뉴 추천로직 개발, 서버개발자 합류|
|4월 Week-3|🤖  비즈니스 로직 설계|iOS 관련 피드백 요청, MVP 설정|
|4월 Week-4|사전학습|객사오, MVVM, RxSwift를 적용한 사전 프로젝트 구현|
|5월 Week-1|사전학습 및 서버 개발|MVVM, RxSwift 스터디, 서버 개발|
|5월 Week-2|사전학습 및 서버 개발|MVVM, RxSwift 스터디, 서버 개발|
|5월 Week-3|🍎 iOS 개발 착수|그라운드 룰 재설정, Figma 구체화, STEP 명세서 작성|
|5월 Week-4|iOS STEP 1 완료|Launch Screen 및 Onboarding 페이지 구현, 디자이너 합류 및 디자인 컨셉 설정|
|6월 Week-1|iOS STEP 2 완료, 🎨 디자인 구체화|Home 및 설정 화면 구현, 디자인 구체화|
|6월 Week-2|iOS STEP 3 완료|게임 화면 (혼밥메뉴결정 탭) 구현, 로컬 서버 테스트|
|6월 Week-3|iOS STEP 4 완료|게임 화면 (함께메뉴결정 탭) 구현, 리모트 서버 테스트|
|6월 Week-4|디자인 개선 및 코드 리팩토링|디자인 개선, 앱 사용 시나리오 수정 및 디버깅|
|7월 Week-1|🚀 AppStore 앱 심사신청 및 출시|AppStore 서비스 소개 문구 및 화면 제작|
