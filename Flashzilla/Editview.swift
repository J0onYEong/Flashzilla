//
//  Editview.swift
//  Flashzilla
//
//  Created by 최준영 on 2023/02/14.
//

import SwiftUI

struct Editview: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ContentViewViewModel
    // TextField
    @State private var question = ""
    @State private var answer = ""
    
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
                    ForEach(viewModel.cards) { card in
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
        } // viewmModel.cards는 현재 게임에 사용되는 중임으로 저장된 모든카드가 포함되있지 않다 따라서 로드해준다.
        .onAppear(perform: viewModel.loadData)
    }
    func checkInput() -> Bool {
        return question.count>0 && answer.count>0
    }

    func addCard() {
        let question = self.question.trimmingCharacters(in: .whitespaces)
        let answer = self.answer.trimmingCharacters(in: .whitespaces)
        viewModel.appendCard(Card(question: question, answer: answer))
        viewModel.saveData()
        self.question = ""
        self.answer = ""
    }
    
    func removeCard(at offset: IndexSet) {
        viewModel.removeCard(at: offset)
        viewModel.saveData()
    }
}
