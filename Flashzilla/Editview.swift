//
//  Editview.swift
//  Flashzilla
//
//  Created by 최준영 on 2023/02/14.
//

import SwiftUI

struct Editview: View {
    @Environment(\.dismiss) var dismiss
    @State private var question = ""
    @State private var answer = ""
    @State private var cards: [Card] = []
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        VStack {
                            TextField("Enter question", text: $question)
                            Divider()
                            TextField("Enter answer", text: $answer)
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        Divider()
                        Button {
                            addCard()
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                                .foregroundColor((checkInput() ? Color.indigo.opacity(0.7) : Color.red))
                                .padding(.leading, 10)
                        }
                        .disabled(!checkInput())
                    }
                }
                Section {
                    ForEach(cards, id: \.self) { card in
                        VStack(alignment: .leading) {
                            Text(card.question)
                                .font(.headline)
                            Text(card.answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCard)
                }
            }
            .listStyle(.inset)
            .navigationTitle("Edit cards")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
            .onAppear(perform: loadData)
        }
    }
    func checkInput() -> Bool {
        return question.count>0 && answer.count>0
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: Card.key) {
            guard let decoded = try? JSONDecoder().decode([Card].self, from: data) else {
                print("error in decoding process")
                return
            }
            cards = decoded
        }
    }
    
    func saveData() throws {
        let encoded = try JSONEncoder().encode(cards)
        UserDefaults.standard.set(encoded, forKey: Card.key)
    }
    
    func addCard() {
        let question = self.question.trimmingCharacters(in: .whitespaces)
        let answer = self.answer.trimmingCharacters(in: .whitespaces)
        cards.append(Card(question: question, answer: answer))
        do {
            try saveData()
            self.question = ""
            self.answer = ""
        } catch {
            print("error in saving process, \(error.localizedDescription)")
        }
    }
    
    func removeCard(at offset: IndexSet) {
        cards.remove(atOffsets: offset)
    }
}

struct Editview_Previews: PreviewProvider {
    static var previews: some View {
        Editview()
    }
}
