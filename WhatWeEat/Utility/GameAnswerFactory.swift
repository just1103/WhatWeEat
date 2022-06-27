import Foundation

struct GameAnswerFactory {
    func createFinalGameAnswerWith(
        gameAnswers: [Bool?],
        mainIngredients: [MainIngredient],
        menuNations: [MenuNation]
    ) -> GameAnswer {
        guard
            let hangoverGameAnswer = gameAnswers[safe: 0],
            let greasyGameAnswer = gameAnswers[safe: 1],
            let healthGameAnswer = gameAnswers[safe: 2],
            let alcoholGameAnswer = gameAnswers[safe: 3],
            let instantGameAnswer = gameAnswers[safe: 4],
            let spicyGameAnswer = gameAnswers[safe: 5],
            let richGameAnswer = gameAnswers[safe: 6]
        else {
            return GameAnswer(
                hangover: false,
                greasy: false,
                health: false,
                alcohol: false,
                instant: false,
                spicy: false,
                rich: false,
                rice: false,
                noodle: false,
                soup: false,
                nation: []
            )
        }
        
        let selectedMainIngredient = mainIngredients.filter { $0.isChecked }
            .map { $0.kind }
        let selectedNations = menuNations.filter { $0.isChecked }
            .map { $0.kind }
        
        // 서버에서 로직 처리 (좋아=true, 싫어=false, 상관없음=nil)
        // 향후 "면 싫어 Cell" 등이 추가될 수 있음
        var isRiceChecked = selectedMainIngredient.contains(.rice) ? true : nil
        var isNoodleChecked = selectedMainIngredient.contains(.noodle) ? true : nil
        var isSoupChecked = selectedMainIngredient.contains(.soup) ? true : nil
        let isAllHateChecked = selectedMainIngredient.contains(.hateAll)
        
        if isAllHateChecked {
            isRiceChecked = false
            isNoodleChecked = false
            isSoupChecked = false
        }
        
        let gameAnswer = GameAnswer(
            hangover: hangoverGameAnswer,
            greasy: greasyGameAnswer,
            health: healthGameAnswer,
            alcohol: alcoholGameAnswer,
            instant: instantGameAnswer,
            spicy: spicyGameAnswer,
            rich: richGameAnswer,
            rice: isRiceChecked,
            noodle: isNoodleChecked,
            soup: isSoupChecked,
            nation: selectedNations
        )
        
        return gameAnswer
    }
}
