

import Foundation

//private var questionDescription = "Рейтинг этого фильма больше чем 6?"

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
            guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
        }
    }
    
    
    /*
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
    ]*/
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data() // по умолчанию у нас будут просто пустые данные
            
            do {
                 imageData = try Data(contentsOf: movie.resizedImageURL)
             } catch {
                 print("Failed to load image")
             }
            
            let rating = Float(movie.rating) ?? 0 // превращаем строку в число
            let randomRaiting = Int.random(in: 4...9) // делаем разный рейтинг для каждого вопроса
            
            let text = "Рейтинг этого фильма больше чем \(randomRaiting)?"
            let correctAnswer = rating > Float(randomRaiting)
            
            let question = QuizQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
