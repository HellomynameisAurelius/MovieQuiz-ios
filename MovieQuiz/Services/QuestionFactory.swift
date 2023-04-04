

import Foundation

private var questionDescription = "Рейтинг этого фильма больше чем 6?"

final class QuestionFactory: QuestionFactoryProtocol {

    private weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: questionDescription,
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: questionDescription,
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: questionDescription,
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: questionDescription,
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: questionDescription,
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: questionDescription,
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: questionDescription,
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: questionDescription,
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: questionDescription,
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: questionDescription,
            correctAnswer: false)
    ]
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}
