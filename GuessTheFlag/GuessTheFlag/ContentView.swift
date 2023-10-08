//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alberto Peinado Santana on 12/8/23.
//

import SwiftUI

struct FlagImage: View {
    var imageName = ""
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct LargeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .bold()
            .padding()
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(LargeTitle())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var answerIsCorrect = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var selectedAnswer: Int? = nil
    @State private var showingFinalScore: Bool = false
    @State private var numberOfTries = 0
    
    let maxNumberOfTries = 8
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .yellow], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack () {
                Text("Guess the flag")
                    .titleStyle()
                
                // Text("Guess the flag")
                //  .modifier(LargeTitle())
                
                
                Spacer()
                
                VStack (spacing: 30){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                                .accessibilityLabel(labels[countries[number]] ?? "Unknown flag")
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    Text("Your score is \(score)")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                
                Spacer()
            }

        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if !answerIsCorrect {
                Text("You selected the flag of \(countries[selectedAnswer ?? 0])" )
            }
            Text("Your score is \(score)")
        }.alert("Game ended", isPresented: $showingFinalScore) {
            Button("Start new game", action: reset)
        } message: {
            Text("Your final score is \(score) out of \(maxNumberOfTries)")
        }
    }
    
    func flagTapped(_ number:Int) {
        selectedAnswer = number
        numberOfTries += 1
        
        if selectedAnswer == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            answerIsCorrect = true
        } else {
            scoreTitle = "Wrong"
            answerIsCorrect = false
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<2)
        showingScore = false
        
        if(numberOfTries == maxNumberOfTries) {
            showingFinalScore = true
        }
    }
    
    func reset () {
        score = 0
        showingScore = false
        selectedAnswer = nil
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
