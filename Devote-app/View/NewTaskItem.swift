//
//  NewTaskItem.swift
//  Devote-app
//
//  Created by TI Digital on 13/07/21.
//

import SwiftUI

struct NewTaskItem: View {
    
    //MARK : - Property
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var task: String = ""
    @Binding var isShowing: Bool
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    // MARK : - Function
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hiddenKeyboard()
            isShowing = false
        }
    }
    
    // MARK : - Body
    var body: some View {
        VStack{
            Spacer()
            
            VStack(spacing: 16){
                TextField("New Task", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                Button(action: {
                    addItem()
                }, label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                })
                .disabled(isButtonDisabled)
                .padding()
                .font(.headline)
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color.blue : Color.pink)
                .cornerRadius(10)
            }//: VStack
            .padding(.horizontal)
            .padding(.vertical,20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.65), radius: 24)
            .frame(maxWidth: 640)
        }//:VStack
        .padding()
    }
}

struct NewTaskItem_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItem(isShowing: .constant(true))
            .previewDevice("iPhone 11")
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
