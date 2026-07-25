import Foundation

struct QuizService {
    
    private let urlString =
        "https://opentdb.com/api.php?amount=10&type=multiple"
    
    func fetchQuestions() async throws -> [QuizQuestion] {
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(
            from: url
        )
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let quizResponse = try JSONDecoder().decode(
            QuizResponse.self,
            from: data
        )
        
        return quizResponse.results
    }
}
