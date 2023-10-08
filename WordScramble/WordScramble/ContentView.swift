//
//  ContentView.swift
//  WordScramble
//
//  Created by Alberto Peinado Santana on 15/8/23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords: Array<String> = []
    @State private var rootWord = ""
    @State private var newWord = ""
    
    // Alert state
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    // Challenge 3
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                ForEach(usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle.fill")
                            .foregroundColor(.cyan)
                            .padding(2)
                        Text(word)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(word)
                    .accessibilityHint("\(word.count) letters")  
                }
            }
            .navigationTitle(rootWord)
            .navigationBarTitleDisplayMode(.automatic)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Text("Your score is \(score)")
//                Button("Restart game") {
//                    startGame()
//                }
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.trimmingCharacters(in: .whitespaces).lowercased()
        
        // exit if the remaining string is empty
        guard answer.count > 0 else { return }
        
        print(isLarge(word: answer))
        // Challenge 1
        guard isLarge(word: answer) else {
            wordError(title: "Word must be have at least 3 letters", message: "Be more original")
            return
        }
        
        // Challenge 1
        guard isNotRootWord(word: answer) else {
            wordError(title: "You cant use the same word", message: "Be more original")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        score += answer.count
        newWord = ""
    }
    
    func startGame() {
        // Challenge 2
        usedWords = []
        newWord = ""
        errorTitle = ""
        errorMessage = ""
        showingError = false
        // Challenge 3
        score = 0
        
        if let fileURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // we found the file in our bundle!
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into a string!
                let words = fileContents.components(separatedBy: "\n")
                rootWord = words.randomElement() ?? "silkworm"
                
                return
            }
        }
        
        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    // Challenge 1
    func isNotRootWord(word: String) -> Bool {
        return word != rootWord
    }
    
    // Challenge 1
    func isLarge(word: String) -> Bool {
        return word.count >= 3
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
