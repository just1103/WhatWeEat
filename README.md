# 우리뭐먹지 

## 목차
- [🍙 프로젝트 소개](#🍙-프로젝트-소개)
- [📱 구현 화면](#📱-구현-화면)
- [🗺 Architecture](#🗺-Architecture)
- [🗂 파일 디렉토리 구조](#🗂-파일-디렉토리-구조)
- [🍙 iOS 파트 명세서 및 관련 PR](#🍙-iOS-파트-명세서-및-관련-PR)
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
- Architecture : MVVM-C 
- ⚙️ 기술 스택    
    - 개발 환경 
        - iOS : swift 5, xcode 13.4
        - 서버 : Java 17, IntelliJ IDEA
    - 라이브러리 : RxSwift, Firebase, Realm, SwiftLint, Lottie / Spring boot
    - Deployment Target : iOS 14.0   
    
## 📱 구현 화면
- 추가 예정
|Onboarding 화면|홈탭 화면|설정 화면|혼자메뉴결정 탭 화면|함께메뉴결정 탭 화면|PIN번호공유 화면|게임 화면|게임결과대기 화면|게임결과 화면|
|-|-|-|-|-|-|-|-|-|
|||||||||

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

## 🍙 iOS 파트 명세서 및 관련 PR
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
#### 못먹는음식 화면의 UI
사용자가 앱을 처음 사용하는 경우, 앱의 기능과 사용 방법을 소개하기 위해 `OnboardingPage`를 구현했습니다.
1~2페이지는 앱에 대한 설명을 나타내고, 3페이지에는 사용자가 못먹는음식을 제출하도록 했습니다. 

|3페이지|1~2페이지|
|---|---|
|<img src="https://i.imgur.com/hpgMHll.png" width="200">|<img src="https://i.imgur.com/zt0E3or.png" width="200">|

3번째 페이지(못먹는음식 화면)의 경우, 못먹는음식을 CollectionView로 구현했습니다. 향후 데이터가 추가되거나 필터링 기능을 추가할 것에 대비하여 데이터 변동에 유연한 `DiffableDataSource` 및 `Compositional Layout`을 활용했습니다.

못먹는음식 데이터를 관리하기 위한 Model 타입으로  `DislikedFoodCell`의 중첩타입으로 `DislikedFood`를 생성했습니다. `DislikedFood` 타입의 `ischecked` 프로퍼티 (Bool 타입)를 통해 사용자의 check 여부를 저장합니다.
해당 데이터를 관리하는 역할은 ViewModel이 담당하도록 했습니다.

못먹는음식 데이터의 이미지는 Asset에 저장하고, ViewModel에서 해당 이미지와 음식별 타이틀을 지정하여 데이터를 배열 타입으로 가지도록 했습니다.

#### 못먹는음식 화면의 Tap 이벤트 처리
사용자는 Cell을 Tap하여 못먹는음식을 다중 선택할 수 있습니다. 
이때 `ViewController`에서 RxCocoa를 통해 selectedCell의 indexPath를 전달하고, `ViewModel`은 해당 Food의 isChecked를 toggle하고, 다시 해당 `Cell`의 배경색이 toggle 되도록 했습니다.

명확한 역할 분리를 위해 `ViewModel`은 Food 데이터를 관리하고, `Cell`은 View를 그리도록 했습니다. 따라서 Cell은 자신의 check 여부를 알 수 없습니다.

#### Realm 연동으로 못먹는음식 데이터를 Loacl DB에 저장
싱글톤 패턴을 적용하여 RealmManager 타입을 생성하고, realm 객체를 가지도록 했습니다. 또한 RealM 데이터 저장을 위한 객체 타입으로 `DislikedFoodForRealM` 타입을 추가했습니다.

`OnboardingPage`의 못먹는음식 화면에서 `확인 버튼`을 Tap하는 이벤트를 받을 때마다, RealM에 못먹는음식 데이터를 업데이트 (기존 데이터 전체삭제, 새로운 데이터 추가)하도록 구현했습니다.

`RealM Studio` 맥앱을 활용해 RealM 데이터가 정상적으로 저장되는지 확인했습니다. 

### 1-2 Trouble Shooting
#### 못먹는음식 화면에서 버튼 isHidden 처리
Onboarding 화면 중 못먹는음식 화면에선 `PageControl`과 `skip` 버튼이 사라지고 `확인` 버튼만 보이도록 했습니다.

기존에는 `pageViewController(_:didFinishAnimating:previousViewControllers:transitionCompleted)` 메서드를 활용해 버튼이 사라지도록 했지만, 이 경우 버튼이 Scroll 이후 뒤늦게 사라져 UX에 좋지 않다고 판단했습니다. 

따라서 `pageViewController(_:willTransitionTo pendingViewControllers:)` 메서드에서 `pendingViewControllers`를 통해 화면이 전환되려할 때 버튼이 사라지도록 했습니다. 
또한 기존 메서드에선 버튼이 다시 보이도록 하는 기능만 담당하도록 분리했습니다.

### 1-3 키워드
- DB : Realm
- PageViewController
- CollectionView, DiffableDataSource, Compositional Layout

### STEP2. Tab Bar의 `Home` 화면 및 `설정` 화면 구현
### 2-1 고민한 점
#### FlowCoordinator를 통한 MVVM-C 구현
`FlowCoordinator`를 통해 의존성 주입을 관리하고, 화면전환 역할을 담당하도록 했습니다. 
`생성자 주입`을 통해 `navigationController`를 주입받고, 화면전환 시 해당 `navigationController`가 다음 화면을 push 하도록 했습니다.
이때 화면전환 관련 정보는 `ViewModel`이 알고 있는 것이 적절하다고 판단했습니다. 따라서 화면전환 동작을 클로저 타입으로 `actions`에 저장하고, actions를 `ViewModel`의 생성자 주입으로 전달했습니다.

#### 네트워크 구현 및 API 추상화
`RxSwift`를 활용하여 비동기 작업을 처리했습니다. 서버에서 받아온 데이터는 `Observable` 타입으로 반환하고, ViewModel에서 ViewController에 전달하여 화면에 나타내는 구조로 구현했습니다.

API를 열거형으로 관리하는 경우, API를 추가할 때마다 새로운 case를 생성하여 열거형이 비대해지고, 열거형 관련 switch문을 매번 수정해야 하는 번거로움이 있었습니다. 따라서 API마다 독립적인 구조체 타입으로 관리되도록 변경하고, URL 프로퍼티 외에도 HttpMethod 프로퍼티를 추가한 APIProtocol 타입을 채택하도록 개선했습니다. 이로써 코드유지 보수가 용이하며, 협업 시 각자 담당한 API 구조체 타입만 관리하면 되기 때문에 충돌을 방지할 수 있습니다.

#### UserDefault를 활용하여 앱이 처음 실행되었는지 확인
앱을 처음 설치하여 실행한 경우에만 OnboardingPage를 보여주고 이후에는 Home 화면을 바로 보여주도록 했습니다.

`FirstLaunchChecker`를 생성하여 UserDefault가 `"isFirstLaunched"`를 키로 값을 가지고 있는지에 따라 Bool 타입을 반환하도록 구현했습니다. 
이를 통해 첫 실행일 경우 OnboardingPage를, 첫 실행이 아니면 `MainTabBarController`를 보여주도록 했습니다.

#### ActivityView를 커스텀하여 공유 기능 구현
`함께메뉴결정` 탭에서 Host가 `그룹생성 버튼`을 탭한 경우, 해당 화면에서 PIN 번호를 공유할 수 있는 버튼을 구현했습니다. 이때 ActivityView의 Title과 Content를 커스텀하기 위해 `UIActivityItemSource`를 준수하는 `SharePinNumberActivityItemSource`를 구현했습니다. 
ActivityView를 화면에 띄울 때에는, Rx를 활용하여 `공유하기` 버튼을 눌렀을 경우 화면에 present할 수 있도록 했습니다. 

### 2-2 Trouble Shooting
#### MainTabBarController를 통한 Tab Bar 구현
`생성자 주입`을 통해 `Tab Bar`에 반영할 화면정보를 전달했습니다. Home 화면에서 `Tab Bar`와 `Navigation Bar`가 모두 존재합니다.

`MainTabBarController`를 초기화하는 과정에서 일부 프로퍼티가 `viewDidLoad` 호출 이후에 초기화되는 문제가 발생했습니다.
확인 결과, `UITabBarController` 이니셜라이저 내부에 `super.init`이 호출되면서 비정상적인 side-effect가 발생하는 것이 원인이었습니다.
따라서 일반적으로 `viewDidLoad`에 배치했던 메서드를 부득이 `viewWillAppear`에서 호출하여 문제를 해결했습니다.

#### UITableView를 통한 설정 화면 구현
설정의 목록은 고정적이므로 Diffable DataSource를 사용하지 않았습니다. 
Section은 `dislikedFood`, `ordinary`, `version` 3가지로 구분했습니다. 
하지만 이처럼 TableView에 여러 개의 Section이 있는 경우 viewModelData.bind(to: tableView.rx.items) 형태로 binding이 불가능한 문제가 발생했습니다. 따라서 UITableViewDataSource 메서드를 사용했습니다. 
또한 설정 화면에 필요한 Item의 경우 `SettingItem` 프로토콜을 준수하는 `OrdinarySettingItem`과 `VersionSettingItem`을 두어 `SettingViewModel`이 가지고 있도록 했습니다. 
이후 rx를 통해 SettingItem을 전달받아, UITableViewDataSource 메서드를 사용하여 TableView를 구성했습니다.

### 2-3 키워드
- Architecture : MVVM-C
- Network : 비동기 처리, URLSession, MultipartFormData, REST-ful API
- 비동기 처리 : RxSiwft/RxCocoa
- TabBarController, NavigationController
- TableView, ActivityView
- View Lifecycle
- DB : UserDefault

### STEP3. `미니게임` 화면 및 애니메이션 구현
### 3-1 고민한 점
#### Game 화면 및 애니메이션 구현
<img src="https://user-images.githubusercontent.com/90880660/174042033-ece76bf8-e89f-42a4-bbf7-768b1a8b7b07.gif" width=250>
사용자가 Game을 통해 9가지 질문에 대답하는 기능을 구현했습니다.
질문은 Card 형태로 띄우고, 7개 질문은 버튼을 통한 `좋아요/싫어요`, 2개 질문은 CollectionView를 통한 `다중선택`로 답변하도록 했습니다. 이때 사용자가 Game에 집중할 수 있도록 NavigationBar 및 TabBar가 숨겨지도록 했습니다.

위 애니메이션처럼 `답변 버튼`을 탭하면 답변 종류 (좋아요, 싫어요, 상관 없음)에 따라 카드가 날아가고, `이전 질문 버튼`을 탭하면 카드가 날아간 방향에서 다시 돌아오도록 구현했습니다. 
카드는 별도의 Custom View 타입을 생성하여 구현했고, UI요소인 만큼 `CardGameViewController`가 가지고 있도록 했으며, 애니메이션을 위해 `CGRect`로 위치를 잡았습니다. 따라서 `translatesAutoresizingMaskIntoConstraints`를 true로 설정했습니다. 

카드 위치의 경우 화면에 보이는 1, 2, 3번째 카드의 위치를 고정해두었고, 답변을 제출하거나, 이전 질문으로 되돌렸을 때 특정 카드의 위치를 바꿔주도록 했습니다.

카드가 제출되어 날라가는 경우 `CGAffineTransform(translateX:y)`와 `CGAffineTransform(rotationAngle:)`을 사용했고, 카드가 다시 돌아오는 경우 날라갔던 위치를 기억하고 있었기 때문에 `CGAffineTransform(rotationAngle:)`만 사용해서 다시 원래대로 돌아오도록 했습니다. 

#### TabBar마다 개별적인 Coordinator 및 NavigationController를 가지도록 구현
HIG 문서의 `Tab bars` 내용 (They also let people quickly switch between sections of the view while preserving the current navigation state within each section.)과 같이 
TabBar 마다 독립적으로 화면이 작동하도록 해야 하므로 TabBarViewController를 띄우는 `Coordinator` 및 `NavigationController` (이하 부모 Coordinator 및 Navigation), 그리고 특정 TabBar 내부에서 화면을 이동하는 `Coordinator` 및 `NavigationController` (이하 자식 Coordinator 및 Navigation)을 분리했습니다. 또한 부모 Coordinator 및 자식 Coordinator는 `Delegate Pattern`을 활용하여 소통하도록 했습니다.

Coordinator 구조는 아래와 같습니다.
![](https://i.imgur.com/OiD4Qvs.png)

사용자가 게임을 할 때 게임에 몰입할 수 있도록 Game 화면에서는 `부모 Coordinator`를 통해 NavigationBar 및 TabBar가 숨겨지도록 했고, 게임 대기/결과 화면에서 다시 보여지도록 구현했습니다.
또한 `자식 Coordinator`에는 Game 화면에 필요한 별도의 Coordinator를 추가하여 코드 재사용성을 개선했습니다.

#### 결과 제출 버튼을 누르면 서버에 결과를 취합하여 전송하도록 구현
`혼자메뉴결정`, `함께메뉴결정` 모두 마지막 질문에서 다음 버튼을 누르는 경우, 게임 답변을 서버에 전송하도록 구현했습니다. 

결과 전송 API의 경우 PIN번호가 있으면 `함께메뉴결정`, 없으면 `혼자메뉴결정`에 해당하는 URL로 데이터를 Post 도록 했으며, `httpMethod`가 Post인 경우 `httpBody`에 인코딩한 JSON 데이터를 넣도록 했습니다.

### 3-2 Trouble Shooting
#### `게임 다시 시작 버튼` 구현 
`함께메뉴결정 탭`의 `Game 결과대기 화면`에서 `게임 다시 시작 버튼`을 탭하면, 서버에 제출한 개인 데이터를 삭제하고, 해당 탭의 초기화면으로 돌아가도록 구현했습니다.
초기화면으로 돌아갈 때는 메모리 관리를 위해 `부모 Coordinator`의 `childCoordinators` 프로퍼티에서 기존의 `자식 Coordinator`를 삭제하고, 새롭게 생성한 `자식 Coordinator`를 추가하도록 했습니다.
- 이때 핀넘버 공유 (SharePinNumber) 화면 및 게임결과 대기 (Submission) 화면의 ViewModel이 메모리에서 해제되지 않는 문제가 발생했습니다. 원인을 파악하지 못하여 추후 리팩토링하면서 해결할 예정입니다.

### 3-3 키워드
- Graphics : UIView, CGAffineTransform
- Auto Layout, Frame/Bounds, StackView
- UIProgressView
- ScheduledTimer

### STEP4. `미니게임 결과` 화면 구현 및 리팩토링
### 4-1 고민한 점
#### 최종메뉴 처리
개인/팀 게임답변을 서버에서 POST 형태로 제출하고, 게임결과로 3개 메뉴와 총 참여인원수를 받아서 나타냈습니다. 사용자의 의사결정을 돕기 위해 `다음메뉴보기` 횟수를 3번으로 제한하였고, `다음메뉴보기` 버튼을 탭하면 ViewModel로부터 다음 메뉴 정보를 받아와서 ViewController에서 메뉴이름과 해당 메뉴의 키워드를 수정하도록 했습니다.
<img src="https://user-images.githubusercontent.com/70856586/178150169-ba9a22c2-5bc0-45b3-a3e4-d0ada3bba270.png" width=250>

서버의 효율성을 높이기 위해 서버개발자와 협의하여 게임결과를 제출할 때 (`ResultSubmissionAPI`, POST 메서드) `함께메뉴결정 탭`이라면 response로 nil을 받고, `혼밥메뉴결정 탭`이라면 게임결과를 받도록 구분했습니다. 이를 통해 혼밥메뉴결정은 별도의 게임결과 요청 API가 필요하지 않게 되었습니다.

#### Firebase를 통해 기기별 토큰을 받아 Host를 서버에서 알 수 있도록 구현
Group으로 게임을 생성할 때 사용자의 토큰을 통해 서버에서 게임을 만든 `Host`가 누구인지 알 수 있도록 해야 했습니다. 따라서 FireBase를 연동했고 그 중 `FirebaseMessaging`을 사용했습니다. 토큰은 메모리에 올라가는 경우 앱이 종료될 때까지 메모리에서 해제되지 않도록 타입 프로퍼티로 선언했습니다. 

결과처리 과정은 아래와 같습니다.
1. `PIN Number 생성하기 버튼`을 탭한 사용자를 서버에서 Host로 인식하도록 처리했습니다.
2. 결과대기 화면에서 호스트의 토큰과 기기의 토큰이 동일한지 비교하여 Bool 타입을 받도록 합니다.
3. 서버에서 받은 Bool 타입이 True인 경우 Host이므로 `결과확인하기` 버튼이 보이도록 합니다.
4. False인 경우 Host가 `결과확인하기` 버튼을 누를 때까지 버튼을 Hidden 처리합니다. 

#### 네트워크 연결상태 확인
`Network`를 import하고, `NetworkConnectionManager` 타입을 싱글톤으로 구현했습니다. 각 화면에서 네트워크 연결상태를 확인하고, 이상이 있는 경우 오류화면을 나타내어 사용자가 인터넷에 재접속하도록 안내했습니다. 오류 화면에서 `refresh` 버튼을 누르면, 네트워크 연결 상태에 따라 다시 오류 화면을 보여주거나, Data를 Fetch하여 정상 화면이 보이도록 했습니다. 
오류화면을 pop하면서 정상 화면을 보여주기 때문에 `viewWillAppear`를 사용해 화면이 다시 보이는 경우 데이터를 fetch해서 화면에 띄울 수 있도록 했습니다. 

### 4-2 Trouble Shooting
- 추가 예정 

### 4-3 키워드
- DB : Firebase
- Network 프레임워크
