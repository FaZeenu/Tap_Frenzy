import SwiftUI

struct QuizRushView: View {
    @StateObject private var viewModel = QuizViewModel()

    var body: some View {
        ZStack {
            Color.orange
                .ignoresSafeArea()

            switch viewModel.viewState {
            case .loading:
                loadingView

            case .failed:
                errorView

            case .loaded:
                quizView

            case .finished:
                resultsView
            }
        }
        .task {
            if viewModel.questions.isEmpty {
                await viewModel.loadQuestions()
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)

            Text("Loading Quiz...")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }

    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 60))
                .foregroundStyle(.white)

            Text("Unable to Load Quiz")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text(viewModel.errorMessage)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.9))

            Button("Retry") {
                Task {
                    await viewModel.loadQuestions()
                }
            }
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.orange)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }

    private var quizView: some View {
        VStack(spacing: 24) {
            Text("Quiz Rush")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            HStack {
                Text(viewModel.questionProgress)
                Spacer()
                Text("Score: \(viewModel.score)")
                Spacer()
                Text("Streak: \(viewModel.streak)")
            }
            .font(.headline)
            .foregroundStyle(.white)

            if let question = viewModel.currentQuestion {
                Text(question.question)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(spacing: 14) {
                    ForEach(question.allAnswers, id: \.self) { answer in
                        Button {
                            viewModel.selectAnswer(answer)
                        } label: {
                            Text(answer)
                                .font(.headline)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 12)
                                )
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }

    private var resultsView: some View {
        VStack(spacing: 24) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 70))
                .foregroundStyle(.yellow)

            Text("Quiz Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text("Final Score")
                .font(.title2)
                .foregroundStyle(.white.opacity(0.9))

            Text("\(viewModel.score)")
                .font(.system(size: 55, weight: .bold))
                .foregroundStyle(.yellow)

            Text("Final Streak: \(viewModel.streak)")
                .font(.title2)
                .foregroundStyle(.white)

            Button("Play Again") {
                Task {
                    await viewModel.restartQuiz()
                }
            }
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.orange)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }
}

#Preview {
    QuizRushView()
}
