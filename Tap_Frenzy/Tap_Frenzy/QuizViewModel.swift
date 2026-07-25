import Foundation
import Combine

enum QuizViewState {
    case loading
    case loaded
    case failed
    case finished
}

@MainActor
final class QuizViewModel: ObservableObject {

    @Published var questions: [QuizQuestion] = []
    @Published var currentIndex = 0
    @Published var score = 0
    @Published var streak = 0
    @Published var viewState: QuizViewState = .loading
    @Published var errorMessage = ""

    private let service = QuizService()

    var currentQuestion: QuizQuestion? {
        guard questions.indices.contains(currentIndex) else {
            return nil
        }

        return questions[currentIndex]
    }

    var questionProgress: String {
        "\(currentIndex + 1) of \(questions.count)"
    }

    func loadQuestions() async {
        viewState = .loading
        errorMessage = ""
        currentIndex = 0
        score = 0
        streak = 0

        do {
            questions = try await service.fetchQuestions()

            if questions.isEmpty {
                errorMessage = "No questions were received."
                viewState = .failed
            } else {
                viewState = .loaded
            }
        } catch {
            errorMessage = "Unable to load questions. Please try again."
            viewState = .failed
        }
    }

    func selectAnswer(_ answer: String) {
        guard let question = currentQuestion else {
            return
        }

        if answer == question.correctAnswer {
            streak += 1
            score += 10 + streak
        } else {
            streak = 0
            score = max(0, score - 2)
        }

        moveToNextQuestion()
    }

    private func moveToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            viewState = .finished
        }
    }

    func restartQuiz() async {
        await loadQuestions()
    }
}
