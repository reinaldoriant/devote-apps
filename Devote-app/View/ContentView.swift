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
    @State private var showNewTaskItem: Bool = false
   
    // Fetching Data
    @Environment(\.managedObjectContext) private var viewContext// Inject data
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)// fetch request (1. entity, 2. sort descriptopr, 3. ascennding, 4. animation)
    private var items: FetchedResults<Item>
    
    // MARK : - Function
    
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
            ZStack {
                // MARK : - MainView
                VStack {
                    // MARK : - Header
                    
                    Spacer(minLength: 80)
                    
                    // MARK : - New task but
                    
                    Button(action: {showNewTaskItem = true}, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal,20)
                    .padding(.vertical,15)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/).clipShape(Capsule()))
                    .shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.25), radius: 8, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 4.0)
                    
                    // MARK : - tasks
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
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                }//: VStack
                
                // MARK : - New task item
                
                if showNewTaskItem{
                    BlankView()
                        .onTapGesture{
                            showNewTaskItem = false
                        }
                    NewTaskItem(isShowing: $showNewTaskItem)
                }
                
            }//: ZSTACK
            .onAppear(){
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationBarTitle("Daily Task",displayMode: .large)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                #endif
            }//: Toolbar
            .background(BackgroundImageView())
            .background(backgroundGradient.ignoresSafeArea(.all))
        }//: Navigation
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



// MARK : - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
