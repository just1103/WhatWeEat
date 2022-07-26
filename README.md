# 우리뭐먹지 

## 목차
- [🍙 프로젝트 소개](#-프로젝트-소개)
- [🗺 Architecture](#-architecture)
- [🗂 파일 디렉토리 구조](#-파일-디렉토리-구조)
- [📱 주요 화면 및 기능](#-주요-화면-및-기능)
- [1️⃣ STEP1. `Onboarding 화면` 구현](#-step1.-onboarding-화면-구현)
    + [관련 PR](#1-1-관련-pr) 
    + [고민한 점](#1-2-고민한-점) 
    + [Trouble Shooting](#1-3-trouble-shooting)
    + [키워드](#1-4-키워드)
- [2️⃣ STEP2. 네트워크 및 `TabBar 화면`/`설정 화면` 구현](#-step2.-네트워크-및-`tabbar-화면`/`설정-화면`-구현)
    + [관련 PR](#2-1-관련-pr) 
    + [고민한 점](#2-2-고민한-점)
    + [Trouble Shooting](#2-3-trouble-shooting)
    + [키워드](#2-4-키워드)
- [3️⃣ STEP3. `게임 화면` 및 애니메이션 구현](#-step3.-`게임-화면`-및-애니메이션-구현)
    + [관련 PR](#3-1-관련-pr) 
    + [고민한 점](#3-2-고민한-점) 
    + [Trouble Shooting](#3-3-trouble-shooting)
    + [키워드](#3-4-키워드)
- [4️⃣ STEP4. `게임결과 화면` 구현](#-step4.-`게임결과-화면`-구현)
    + [관련 PR](#4-1-관련-pr) 
    + [고민한 점](#4-2-고민한-점) 
    + [Trouble Shooting](#4-3-trouble-shooting)
    + [키워드](#4-4-키워드)
- [🌙 업데이트 및 리팩토링 계획](#-업데이트-및-리팩토링-계획)

## 🍙 프로젝트 소개
- 미니게임으로 사용자의 취향을 분석하여 혼자 또는 여럿이서 먹을 식사메뉴를 추천하는 iOS 앱  
   🔗 [앱 다운로드 링크](https://apps.apple.com/app/1632157845)
   <img width="1152" alt="image" src="https://user-images.githubusercontent.com/70856586/178147195-49f6ccd8-1972-44aa-8abf-8e054bdc8839.png">

- 팀원
   - iOS : [호댕](https://github.com/yanghojoon), [애플사이다](https://github.com/just1103)
   - 서버 : [핸손](https://github.com/handsone-u)
   - 디자인 : 윤또
- 진행 기간
    - 기획 : 2022.03.27 ~ 2022.04.18 (2주)
    - 개발 : 2022.05.19 ~ 2022.07.07 (9주)
    - 출시 : 2022.07.07
- 기술 스택
    - 개발 환경 
       - iOS : swift 5, xcode 13.4
       - 서버 : Java 17, IntelliJ IDEA
    - 라이브러리 
       - iOS : RxSwift, Firebase, Realm, SwiftLint, Lottie 
       - 서버 : Spring boot
    - Deployment Target : iOS 14.0
    
## 🗺 Architecture
### MVVM-C 
<img width="1152" src="https://i.imgur.com/dHvlARE.jpg"> 

> MVVM   
- `ViewController` (View)는 화면을 그리는 역할을 담당하고, `ViewModel`은 데이터 및 비즈니스 로직 관리, 화면 전환 요청 등을 담당하도록 역할을 분리했습니다.
- 추후 ViewModel에 대한 테스트 코드를 추가하여 안정성을 개선할 예정입니다.
- 프로그램의 복잡도가 높아질 경우 Clean Architecture를 도입할 예정입니다.

> Input/Output Modeling
- `ViewModel`의 Nested Type으로 Input 및 Output을 추가했습니다.
- View로부터 전달된 이벤트는 `Input`을 통해, View로 전달할 데이터는 `Output`을 통해 Binding 했습니다.
- 일관성 있는 구조를 통해 직관적인 이해가 가능하며 코드 가독성을 개선할 수 있었습니다.

> Coordinator
- 화면 전환 역할을 전담하고, 의존성 관리를 위해 Coordinator를 활용했습니다. 
- `ChildCoordinators`를 통해 하위 화면을 관리하는 Coordinator가 메모리에서 해제되는 것을 방지합니다.


## 🗂 파일 디렉토리 구조
```
─── WhatWeEat
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

## 📱 주요 화면 및 기능
> 🍖 Onboarding 화면 - 못먹는 음식을 알려주시면 추천 메뉴에서 제외해요

<img src="https://i.imgur.com/TPSBQzd.png" width="200">  <img src="https://user-images.githubusercontent.com/70856586/180999107-38eb6fc9-f990-4dd8-8fa5-6c4e801d6d91.png" width="200">

> 🙌 함께메뉴결정 탭의 그룹생성하기 시나리오 - 팀원들에게 PIN 번호를 알려주세요. 인원 제한 없이 누구나 참여할 수 있어요

<img src="https://user-images.githubusercontent.com/70856586/181000270-69df24c9-2766-46d5-8cfe-28b1217cbb4b.png" width="200">  <img src="https://user-images.githubusercontent.com/70856586/181000286-6e5a7fcd-7c2f-436d-b057-b9a3b52663eb.png" width="200">  <img src="https://user-images.githubusercontent.com/70856586/181000299-5726bcaf-3675-4250-969c-66e516b67f78.png" width="200">  

> 🔢 함께메뉴결정 탭의 PIN으로 입장하기 시나리오 - Host가 알려준 PIN 번호를 입력하여 간단히 참여해봐요

<img src="https://user-images.githubusercontent.com/70856586/181001529-c6543d3b-cad2-461b-a057-1e68baa94e7a.png" width="200">  <img src="https://user-images.githubusercontent.com/70856586/181004631-aa30a955-bc23-45f4-b26a-f772140ca3d6.jpeg" width="200">

> 🕹️ 게임 / 게임결과대기 / 게임결과 화면 - Host가 결과확인 버튼을 탭할 때까지 게임을 진행해주세요

<img src="https://user-images.githubusercontent.com/70856586/180999044-280ec6cf-de94-4feb-ac03-27fae4f4320c.png" width="200">  <img src="https://user-images.githubusercontent.com/70856586/180999083-47b8ec93-89c1-46df-8989-91f5471f5f5b.png" width="200">  <img src="https://user-images.githubusercontent.com/70856586/180998997-a768d43b-e12e-40ec-8a4d-3179f0831512.png" width="200">  <img src="https://user-images.githubusercontent.com/70856586/181001824-fdff64c3-f907-4e59-b0b9-737048c4ed68.png" width="200">

> 🎲 Home 탭 - 게임을 하기 귀찮다면 랜덤메뉴도 있어요   

<img src="https://user-images.githubusercontent.com/70856586/180999171-7f385198-9a7f-46e6-9906-313f133410c0.png" width="200">

> ⚙️ 설정 화면 - 못먹는 음식을 수정하거나, 개발자에게 피드백을 남길 수 있어요

<img src="https://user-images.githubusercontent.com/70856586/180999640-403792b1-8bfc-4187-9a1e-f209b6b2fb1a.png" width="200">  <img src="https://user-images.githubusercontent.com/70856586/181000085-0a99afb5-cd2a-480f-acb5-789c785370fe.png" width="200">

> ⚠️ 오류 화면 - 네트워크 연결이 불안정하면 알려드려요

<img src="https://user-images.githubusercontent.com/70856586/181002265-b1452d35-ef81-4b52-b629-1d6d7d2b00d5.jpeg" width="200">  <img src="https://user-images.githubusercontent.com/70856586/181002251-9d041ff3-8352-42c3-9c65-6d4a183e3449.jpeg" width="200">


## 1️⃣ STEP1. Onboarding 화면 구현
### 1-1 관련 PR
- [PR-1. Feature/landing: 앱을 처음 실행하는 경우 온보딩 페이지를 실행하도록 합니다](https://github.com/just1103/WhatWeEat/pull/1)
- [PR-2. Realm을 연동하여 못먹는음식 데이터를 Local DB에 저장합니다](https://github.com/just1103/WhatWeEat/pull/2)

### 1-2 고민한 점
#### 1) `못먹는음식 화면`의 UI 및 Model 구성   
사용자가 앱을 최초 실행한 경우, 앱의 기능과 사용 방법을 소개하기 위해 `PageViewController`를 활용하여 `OnboardingPage`를 구현했습니다. 1~2페이지는 앱에 대한 설명을 나타내고, 3페이지에는 사용자가 못먹는음식을 제출하도록 했습니다.

|1~2페이지|3페이지|
|---|---|
|<img src="https://i.imgur.com/TPSBQzd.png" width="200">   <img src="https://i.imgur.com/XM8MfZy.png" width="200">|<img src="https://i.imgur.com/3X4y7hX.png" width="200">|

3페이지(못먹는음식 화면)의 경우, 못먹는음식 목록을 `CollectionView`로 구현했습니다. 향후 데이터가 늘어나거나 필터링 기능을 추가할 것에 대비하여 데이터 변동에 유연한 `DiffableDataSource` 및 `Compositional Layout`을 활용했습니다.

못먹는음식 데이터를 관리하기 위한 Model로 `DislikedFood` 타입을 생성했고, 해당 타입의`ischecked` 프로퍼티 (Bool 타입)를 통해 사용자의 check 여부를 저장합니다. 이때 못먹는음식 목록 데이터를 관리하는 역할은 `ViewModel`이 담당하도록 했습니다. ViewModel에서 음식별 이미지와 타이틀을 지정하고, 데이터 목록을 `배열` 타입으로 저장했습니다.

#### 2) 못먹는음식 화면의 Tap 이벤트 처리시 역할 분리
사용자는 Cell을 Tap하여 못먹는음식을 다중 선택할 수 있습니다. Tap 이벤트가 발생하면 `ViewController`에서 RxCocoa를 통해 selectedCell의 indexPath를 전달하고, `ViewModel`은 해당 Food의 isChecked를 toggle하고, 다시 `ViewController`를 통해 해당 `Cell`의 배경색이 toggle 되도록 했습니다.

명확한 역할 분리를 위해 `ViewModel`은 Food 데이터를 관리하고, `Cell`은 View를 그리도록 했습니다. 따라서 Cell은 자신의 check 여부를 알 수 없습니다.

#### 3) Realm 연동으로 못먹는음식 데이터를 Loacl DB에 저장
싱글톤 패턴의 `RealmManager` 타입을 생성하고, Realm 객체를 가지도록 했습니다. 그리고 OnboardingPage의 `못먹는음식 화면`에서 `확인 버튼`을 Tap할 때마다, Realm 데이터를 업데이트 (기존 데이터 전체삭제, 새로운 데이터 추가)하도록 구현했습니다.

`RealM Studio` 맥앱을 활용해 RealM 데이터가 정상적으로 저장되는지 확인했습니다. 

### 1-3 Trouble Shooting
#### 1) 못먹는음식 화면에서 버튼 isHidden 처리
OnboardingPage 중 못먹는음식 화면에서만 `PageControl`과 `skip` 버튼이 사라지고 `확인` 버튼이 보이도록 했습니다.

기존에는 PageViewController의 메서드 `pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted)`를 활용해 버튼이 사라지도록 했지만, 버튼이 Scroll된 이후 뒤늦게 사라져 UX가 나빠지는 문제가 발생했습니다.

따라서 기존 메서드에서는 버튼이 다시 보이도록 하는 기능만 담당하도록 하고, `pageViewController(_:willTransitionTo pendingViewControllers:)` 메서드를 추가하여 화면 전환 직전에 버튼이 사라지도록 기능을 분리하여 해결했습니다.

### 1-4 키워드
- 라이브러리 : Realm, SPM
- UI : Build UI Programmatically, PageViewController, CollectionView (DiffableDataSource, Snapshot, Compositional Layout)

## 2️⃣ STEP2. 네트워크 및 TabBar 화면/설정 화면 구현
### 2-1 관련 PR
- [PR-3. 앱 최초실행 시 OnboardingPage, 그 이후에는 MainTabBarController의 Home 화면을 보여줍니다](https://github.com/just1103/WhatWeEat/pull/3)
- [PR-4. 함께메뉴결정 탭 및 혼밥메뉴결정 탭의 미니게임 준비 화면을 보여줍니다](https://github.com/just1103/WhatWeEat/pull/4)
- [PR-5. 네트워크를 구현하여 홈 탭 및 함께메뉴결정 탭에 서버 데이터를 반영합니다](https://github.com/just1103/WhatWeEat/pull/5)
- [PR-6. Main 화면의 NavigationBar 우상단의 설정 버튼을 탭하면 설정 화면이 나타납니다](https://github.com/just1103/WhatWeEat/pull/6)

### 2-2 고민한 점
#### 1) 네트워크 구현 및 API 추상화
`RxSwift`를 활용하여 비동기 작업을 처리했습니다. 서버에서 받아온 데이터는 `Observable` 타입으로 반환하고, ViewModel에서 ViewController에 전달 (Binding)하여 화면에 나타내도록 구현했습니다. 이때 데이터를 화면에 나타내는 최말단 시점에만 `Subscribe`하여 Stream이 끊기지 않는 구조를 유지했습니다. 

또한 API를 `열거형`으로 관리하는 경우, API를 추가할 때마다 새로운 case를 생성하여 열거형이 비대해지고, 열거형 관련 switch문을 매번 수정해야 하는 번거로움이 있었습니다. 
따라서 API마다 독립적인 `구조체` 타입으로 관리되도록 변경하고, URL 프로퍼티 외에도 `HttpMethod` 프로퍼티를 추가한 APIProtocol 타입을 채택하도록 개선했습니다. 이로써 코드유지 보수가 용이하며, 협업 시 각자 담당한 API 구조체 타입만 관리하면 되기 때문에 충돌을 방지할 수 있습니다.

#### 2) Coordinator를 통한 MVVM-C 구현
`Coordinator`를 통해 의존성 주입을 관리하고, 화면전환 역할을 전담하도록 했습니다. 이를 위해 `navigationController`를 `생성자 주입`으로 하위 ChildCoordinator에 전달하고, 화면전환 시 해당 `navigationController`가 다음 화면을 push 하도록 했습니다.

이때 화면전환 정보는 `ViewModel`이 알고 있는 게 적절하다고 판단했습니다. 따라서 화면전환 동작을 `Coordinator`의 메서드로 생성하고, `ViewModel`의 생성자 주입으로 coordinator를 전달한 뒤 ViewModel에서 해당 메서드를 호출하도록 했습니다.

#### 3) TabBar마다 개별적인 Coordinator 및 NavigationController를 가지도록 구현
HIG 문서의 `Tab bars` 내용 ("They also let people quickly switch between sections of the view while preserving the current navigation state within each section.")과 같이 TabBar 마다 독립적으로 화면이 바뀌도록 해야 한다고 판단했습니다. 

따라서 TabBarViewController를 띄우는 `Coordinator` 및 `NavigationController` (이하 부모 Coordinator 및 Navigation), 그리고 특정 TabBar 내부에서 화면을 이동하는 `Coordinator` 및 `NavigationController` (이하 자식 Coordinator 및 Navigation)을 분리했습니다. 또한 부모 Coordinator 및 자식 Coordinator는 `Delegate Pattern`을 활용하여 소통하도록 했습니다.

Coordinator 구조는 아래와 같습니다.
<img width="1152" src="https://i.imgur.com/95G5tLo.jpg">

또한 사용자가 게임중일 때 몰입할 수 있도록 Game 화면에서는 `부모 Coordinator`를 통해 NavigationBar 및 TabBar가 숨겨지도록 했고, 게임 대기/결과 화면에서 다시 보이도록 구현했습니다. 그리고 `함께/혼밥메뉴확인 탭`의 `자식 Coordinator`에는 Game 관련 화면을 관리하는 별도의 `GameCoordinator`를 추가하여 중복 코드를 최소화하고, 코드 재사용성을 개선했습니다.

#### 4) UserDefault를 활용하여 앱의 최초 실행 여부 확인
앱을 최초 실행한 경우 (정확히는 못먹는음식 데이터를 제출한 시점)에만 OnboardingPage를 보여주고, 이후에는 곧바로 Home 화면이 나타나도록 했습니다.

이를 위해 `FirstLaunchChecker`를 생성하고, UserDefault `isFirstLaunched 문자열` Key에 해당하는 값의 존재하는지 확인하여 최초 실행 여부를 판단하도록 구현했습니다. 

#### 5) ActivityView를 커스텀하여 `공유하기` 기능 구현
`함께메뉴결정` 탭에서 Host가 `그룹 만들기 버튼`을 탭한 경우, Host가 팀원들에게 PIN 번호를 공유할 수 있도록 `공유하기` 버튼을 구현했습니다. ActivityView의 Title과 Content를 커스텀하기 위해 `UIActivityItemSource`를 준수하는 `SharePinNumberActivityItemSource`를 구현했습니다. 이때 `iPad`를 지원하기 위해 `popoverPresentationController`를 활용했습니다.

### 2-3 Trouble Shooting
#### 1) `TabBarController`의 Lifecycle Methods 오작동
`TabBarController`를 초기화하는 과정에서 일부 프로퍼티가 `viewDidLoad` 호출 이후에 초기화되는 문제가 발생했습니다. 확인 결과, `TabBarController` 이니셜라이저 내부에서 `super.init`이 호출되면서 비정상적인 side-effect가 발생하는 것이 원인이었습니다.
따라서 일반적으로 `viewDidLoad`에 배치했던 메서드를 부득이 `viewWillAppear`에서 호출하여 문제를 해결했습니다.

#### 2) 3개 Section과 2개 Cell Type으로 구성된 `설정 화면`의 TableView Binding 문제
설정 화면의 항상 List 형태이므로 `TableView`를 활용했고, 컨텐츠가 고정적이므로 Diffable DataSource를 사용하지 않았습니다. Section 종류는 `dislikedFood`, `commom`, `version` 3가지로 구분했습니다. 하지만 이처럼 TableView에 여러 개의 Section이 있는 경우 `viewModelData.bind(to: tableView.rx.items)` 형태로 binding을 할 수 없는 문제가 발생했습니다. 

따라서 Rx 기능 대신 `UITableViewDataSource` 메서드를 사용했습니다. 또한 Section마다 다른 Cell Type을 적용하기 위해 Cell Item의 경우 추상 타입인 `SettingItem` 프로토콜로 지정하고, 이를 준수하는 `CommonSettingItem` (못먹는음식 Cell과 일반설정 Cell) 및 `VersionSettingItem` (버전정보 Cell) 타입을 추가했습니다.

이후 rx를 통해 ViewModel로부터 `SettingItem 배열`을 전달받고, `cellForRowAt` 메서드의 indexPath를 통해 각 section에 맞는 Cell Item을 `filter` 및 `다운캐스팅`하여 TableView에 나타냈습니다.

### 2-4 키워드
- Network : URLSession, REST-ful API
- 비동기 처리 : RxSiwft/RxCocoa
- DB : UserDefault, JSON Parsing
- UI : TabBarController/NavigationController, TableView, ActivityView, Alert, TextField

## 3️⃣ STEP3. 게임 화면 및 애니메이션 구현
### 3-1 관련 PR
- [PR-7. 게임시작하기 버튼을 탭하면 Game 화면 및 Game 결과대기 화면을 보여줍니다](https://github.com/just1103/WhatWeEat/pull/7)

### 3-2 고민한 점
#### 1) 게임 화면의 Card 구현
사용자가 게임을 통해 9가지 질문에 대답하는 기능을 구현했습니다.
[UI 애니메이션 예시](https://www.pinterest.co.kr/pin/538250592968066913/)를 참고하여 질문은 Card 형태로 띄우고, 7개 질문은 YES/NO 버튼을 통한 `좋아요/싫어요`, 2개 질문은 CollectionView를 통한 `다중선택` 형태로 답변하도록 했습니다. 

카드는 Custom View 타입으로 구현했고, UI 요소이므로 `CardGameViewController`가 가지도록 했으며, 애니메이션을 위해 `CGRect` 값을 설정하여 위치를 잡았습니다. 

<img src="https://user-images.githubusercontent.com/70856586/180957905-e33a33b6-1639-4113-88da-160543ba0a5a.gif" width=250> 

#### 2) 게임 화면의 애니메이션 구현
위 애니메이션처럼 `답변 버튼`을 탭하면 답변 종류 (좋아요, 싫어요, 상관 없음)에 따라 카드가 특정 방향으로 날아가고, `이전 질문 버튼`을 탭하면 카드가 날아간 방향에서 다시 돌아오도록 구현했습니다. 

카드 위치의 경우 먼저 화면에 보이는 1/2/3번째 카드의 위치를 `CGRect` 값으로 고정해두었고, 답변을 제출하거나, 이전 질문으로 되돌렸을 때 특정 카드의 위치를 바꿔주도록 했습니다. (예를 들어 다음 버튼을 탭하면 4번째 카드는 3번째로, 3번째 카드는 2번째로, 2번째 카드는 1번째로, 1번째 카드는 날아가도록 했습니다.)

카드가 제출되어 날아가는 경우 `CGAffineTransform(translateX:y)`와 `CGAffineTransform(rotationAngle:)`을 사용했고, 카드가 다시 돌아오는 경우 카드가 날아갔던 마지막 위치를 기억하고 있으므로 `CGAffineTransform(rotationAngle:)`을 사용해서 1번째 위치로 돌아오도록 했습니다. 

#### 3) `결과제출 버튼`을 누르면 게임 답변을 취합하여 서버에 전송
`혼자메뉴결정`, `함께메뉴결정` 모두 마지막 질문에서 다음 버튼을 누르는 경우, 게임 답변과 사용자 토큰, 못먹는음식, PIN번호 등의 데이터를 취합하여 서버에 POST 하도록 구현했습니다. 

결과제출 API의 경우 현재 ViewModel에 PIN번호가 있는지 확인하여 있으면 `함께메뉴결정`, 없으면 `혼자메뉴결정`에 해당하는 URL로 데이터를 전송하도록 했습니다. 또한 `httpMethod`가 Post인 경우 `httpBody`에 인코딩한 JSON 데이터를 넣도록 했습니다.

### 3-3 Trouble Shooting
#### 1) `게임 다시 시작 버튼` 구현 
`함께메뉴결정 탭`의 `게임결과 대기 화면`에서 `게임 다시 시작 버튼`을 탭하면, PUT 메서드를 통해 서버에 제출한 기존 개인 데이터를 삭제하고, 해당 탭의 초기화면으로 돌아가도록 구현했습니다.

초기화면으로 돌아갈 때는 현재 본인인 `자식 Coordinator` (GameCoordinator)를 통해 현재 화면을 Pop하고, delegate 패턴으로 `부모 Coordinator` (TogetherMenuCoordinator)를 통해 초기화면에 필요한 ViewModel 및 ViewController를 재생성하여 화면에 띄우도록 구현했습니다. 

#### 2) `결과 확인 버튼` 구현 
서버 로직상 Host가 `결과 확인 버튼`을 탭하면, 해당 PIN 번호에 해당하는 팀은 게임답변 제출을 마감하고 `게임결과 화면`을 나타내도록 구현했습니다. 하지만 해당 버튼을 Host만 볼 수 있고, 팀원들은 볼 수 없어서 팀원들은 결과를 확인할 수 없는 문제가 발생했습니다.

따라서 `ScheduledTimer`를 통해 10초 간격으로 서버로부터 제출인원수 (SubmissionCount)와 Host가 결과확인 버튼을 탭했는지 여부 (isGameClosed)를 받아오도록 했습니다. 

이를 통해 isGameClosed가 true가 되면 Host의 화면에만 보이던 버튼을 팀원들도 볼 수 있도록 처리하여 모두가 추천 메뉴를 확인할 수 있도록 개선했습니다.

### 3-4 키워드
- Pattern : Factory Pattern, Singleton Pattern
- Graphics : animate, CGAffineTransform
- UI : UIProgressView, Auto Layout, Frame/Bounds, StackView
- Timer

## 4️⃣ STEP4. 게임결과 화면 구현
### 4-1 관련 PR
- [PR-8. 결과확인하기 버튼을 탭하면 게임결과 화면을 보여줍니다](https://github.com/just1103/WhatWeEat/pull/8)
- [PR-9. 일부 앱사용 로직 및 디자인을 수정했습니다](https://github.com/just1103/WhatWeEat/pull/9)

### 4-2 고민한 점
#### 1) 추천메뉴 데이터 처리
게임답변제출 API 및 게임결과 API를 통해 서버로부터 3개 메뉴와 총 참여인원수를 받아서 나타냈습니다. 사용자의 의사결정을 돕기 위해 `다음순위메뉴보기` 횟수를 2번으로 제한하였고, `다음순위메뉴보기` 버튼을 탭하면 ViewModel로부터 다음 메뉴 정보를 받아와서 ViewController에서 메뉴이름과 키워드를 수정하도록 했습니다.   
<img src="https://user-images.githubusercontent.com/70856586/178150169-ba9a22c2-5bc0-45b3-a3e4-d0ada3bba270.png" width=250>

이때 서버의 효율성을 높이기 위해 서버개발자와 협의하여 게임답변을 제출할 때 (`ResultSubmissionAPI`) `함께메뉴결정 탭`이라면 response로 nil을 받고, `혼밥메뉴결정 탭`이라면 게임결과를 받도록 구분했습니다. 이를 통해 혼밥메뉴결정은 별도의 게임결과 요청을 할 필요가 없게 개선했습니다.

#### 2) Firebase 연동 및 사용자 토큰을 통해 서버에서 Host를 파악하도록 구현
프로그램 로직상 `Host` (`함께메뉴결정 탭`에서 `그룹 만들기 버튼`을 탭한 사용자)를 서버에서 누구인지 파악할 수 있도록 해야 했습니다. 따라서 `FireBase (FirebaseMessaging)`를 연동하여 `사용자 토큰`을 활용했습니다. 토큰은 메모리에 올라가는 경우 앱이 종료될 때까지 메모리에서 해제되지 않도록 타입 프로퍼티로 선언했습니다. 

처리 과정은 아래와 같습니다.
1. `그룹 만들기 버튼`을 탭한 경우 Host의 토큰을 서버에 POST 합니다.
2. `결과제출 버튼`을 탭한 경우 사용자의 게임 답변과 함께 토큰을 서버에 POST 합니다.
3. 서버는 위 1/2번을 비교하여 해당 사용자가 Host에 해당하는지 여부를 판단합니다.
4. `결과대기 화면`에서 서버로부터 Host 해당 여부 (Bool 타입)를 받습니다.
   - True이면 Host이므로 `결과확인하기 버튼`이 보이도록 합니다.
   - False이면 팀원이므로 Host가 `결과확인하기 버튼`을 누를 때까지 버튼을 Hidden 처리합니다. 

#### 3) 네트워크 연결상태 확인
`Network`를 import하고, `NetworkConnectionManager` 를 싱글톤으로 구현했습니다. 각 화면에서 네트워크 연결상태를 확인하고, 이상이 있는 경우 오류화면을 나타내어 사용자가 인터넷에 재접속하도록 안내했습니다. 

오류 화면에서 `Refresh 버튼`을 누르면, 네트워크 연결상태에 따라 오류화면을 유지하거나, 서버로부터 다시 데이터를 Fetch하여 정상 화면이 보이도록 했습니다. 이때 오류화면을 pop 하면서 정상 화면을 보여주므로`viewWillAppear` 메서드를 호출해 데이터를 Fetch 하도록 했습니다.

#### 4) 다양한 사용자 시나리오를 반영하여 UX 개선
아래처럼 `결과대기 화면`에서 앱을 강제종료한 경우, 재접속하면 기존의 대기화면을 자동으로 보여주는 등의 시나리오를 반영했습니다.
이를 위해 `TogetherGameSubmittedChecker`를 추가하고, UserDefault를 활용하여 답변제출 여부와 가장 최근의 PIN Number를 저장하도록 구현했습니다. 
(결과제출 버튼을 탭했을 때 isTogetherGameSubmitted를 true로 바꾸고, 게임시작/게임다시시작/결과확인 버튼을 눌렀을 때 false로 바꾸도록 했습니다.
앱을 재실행했을 때에는 MainTabBarCoordinator에서 UserDefault를 확인하여 true이면 기존의 `결과대기 화면`을 보여줍니다.)   

<img src="https://user-images.githubusercontent.com/70856586/175905149-1f9a8475-c602-4c0f-a73e-59eef7678420.gif" width="200">

이외에도 `결과대기 화면`에서 `게임다시시작하기 버튼`을 탭한 경우, 해당 사용자의 제출 데이터를 삭제하고 초기화면을 보여줍니다.

### 4-3 Trouble Shooting
#### 1) 홈 화면에서 Label의 텍스트가 잘리는 문제
"육회/육회비빔밥 어때요?"와 같이 메뉴 이름이 긴 경우, `홈 화면`에서 Label의 텍스트가 잘리는 문제가 발생했습니다.
따라서 메뉴 이름의 count에 따라 6자 이상이면 텍스트를 두 줄로 나누고, 10자 이상이면 텍스트 크기를 줄이도록 Layout을 조정했습니다.

### 4-4 키워드
- 라이브러리 : Firebase, Lottie
- Layout : Deactivate/activate Constraints
- Network Connection Manager
   
## 🌙 업데이트 및 리팩토링 계획
### 1. 게임결과 대기 화면의 게임다시시작 버튼
`함께메뉴결정 탭`의 `게임결과 대기 화면`에서 `게임 다시 시작 버튼`을 탭했을 때, `GameCoordinator`는 메모리에서 정상적으로 해제되지만, `핀넘버 공유 (SharePinNumber) 화면` 및 `게임결과 대기 (Submission) 화면`의 ViewModel이 해제되지 않는 문제가 발생했습니다. 추후 리팩토링을 통해 해결할 예정입니다.

### 2. 주변 식당 안내 기능
지도 SDK를 활용하여 추천메뉴 이름을 키워드로 주변 식당을 보여주는 기능을 추가할 예정입니다.

### 3. Firebase를 통한 Push Notification 기능
`함께메뉴결정 탭`에서 Host가 `결과확인하기 버튼`을 탭한 경우, 팀원들에게 알려주는 기능을 추가할 예정입니다.   

### 4. ViewModel 테스트 코드 추가
View와 별개로 ViewModel에 대한 Unit Test를 추가하여 안전성 및 개발 속도를 개선할 예정입니다.
<br/>
<br/>

### 🍙 보다 자세한 내용이 궁금하시다면 🌐 [우리뭐먹지 Wiki](https://github.com/just1103/WhatWeEat/wiki)를 확인해주세요.
