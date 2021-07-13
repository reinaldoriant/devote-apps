//
//  ContentView.swift
//  Devote-app
//
//  Created by TI Digital on 13/07/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK : - Property
    @State var task: String = ""
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    // Fetching Data
    @Environment(\.managedObjectContext) private var viewContext// Inject data
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)// fetch request (1. entity, 2. sort descriptopr, 3. ascennding, 4. animation)
    private var items: FetchedResults<Item>
    
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
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    // MARK : - Body
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 16){
                    TextField("New Task", text: $task)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    Button(action: {
                        addItem()
                    }, label: {
                        Spacer()
                        Text("SAVE")
                        Spacer()
                    })
                    .disabled(isButtonDisabled)
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(isButtonDisabled ? Color.gray : Color.pink)
                    .cornerRadius(10)
                }//: VStack
                .padding()
                List {
                    ForEach(items) { item in
                        VStack (alignment: .leading) {
                            Text(item.task ?? "")
                                .font(.headline)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }//: List ITem
                    }
                    .onDelete(perform: deleteItems)
                }//: List
                .navigationBarTitle("Daily Task",displayMode: .large)
                .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    #endif
                }//: Toolbar
            }//: VStack
        }//: Navigation
    }
}



// MARK : - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
