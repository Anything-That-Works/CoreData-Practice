//
//  ContentView.swift
//  CoreData Practice
//
//  Created by Promal on 23/8/21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)], predicate: NSPredicate(format: "name == %@", "Shirt"))
    var items: FetchedResults<Item>
    @FetchRequest(entity: Catagory.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Catagory.name, ascending: true)])
    var catagories: FetchedResults<Catagory>
    
    @State private var isActionSheetPresented = false
    @State private var isAlertPresentated = false
    
    
    
    var body: some View {
        VStack{
            Button(action: {
                let catagory = Catagory(context: managedObjectContext)
                catagory.name = "Cloths"
                PersistanceController.shared.save()
            }, label: {
                Text("Add catagory")
            })
            
            Button(action: {
                if (catagories.count == 0 ){
                    isAlertPresentated.toggle()
                }
                else{
                    isActionSheetPresented.toggle()
                }
            }, label: {
                Text("Add item")
            }).actionSheet(isPresented: $isActionSheetPresented, content: {
                var buttons = [ActionSheet.Button]()
                catagories.forEach { (catagory) in
                    let button = ActionSheet.Button.default(Text("\(catagory.name ?? "Unknown")")){
                        let item = Item(context: managedObjectContext)
                        item.name = "Shirt"
                        PersistanceController.shared.save()
                    }
                    buttons.append(button)
                }
                buttons.append(.cancel())
                return ActionSheet(title: Text("Please select a catagory"), message: nil, buttons: buttons)
            })
            .alert(isPresented: $isAlertPresentated, content: {
                Alert(title: Text("Please add a catagory"), message: nil, dismissButton: .cancel(Text("Ok")))
            })
            List{
                ForEach(items, id: \.self){item in
                    Text("\(item.name ?? "Unknown") - \(item.toCatagory?.name ?? "Unknown")")
                }.onDelete(perform: removeItem)
            }
        }
    }
    
    func removeItem (at offsets: IndexSet){
        for index in offsets {
            let item = items[index]
            PersistanceController.shared.delete(item)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
