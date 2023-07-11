//
//  ContentView.swift
//  NightWatch
//
//  Created by Tochi Onyeamah on 7/4/23.
//

import SwiftUI
struct ContentView: View {
    @ObservedObject var nightWatchTasks: NightWatchTasks
    @State private var focusModeOn = false
    @State private var resetAlertShowing = false
    var body: some View {
        VStack {
            NavigationView {
                List {
                    // MARK: NIGHTLY TASKS
                    Section(header: TaskSectionHeader(symbolSystemName: "moon.stars", headerText: "Nightly Tasks")
                            ) {

                        ForEach(nightWatchTasks.nightlyTasks.indices,id: \.self, content: {
                            task in
                            if focusModeOn == false || (focusModeOn && $nightWatchTasks.nightlyTasks[task].isComplete.wrappedValue == false){
                                NavigationLink(destination: DetailsView(task: $nightWatchTasks.nightlyTasks[task]), label: {
                                    TaskRow(task: nightWatchTasks.nightlyTasks[task])
                                }).foregroundColor(.gray)

                            }


                        }).onDelete(perform: {indexSet in
                            nightWatchTasks.nightlyTasks.remove(atOffsets: indexSet)
                        }).onMove(perform: {
                            indices, newOffSet in
                            nightWatchTasks.nightlyTasks.move(fromOffsets: indices, toOffset: newOffSet)
                        })
                    }
                    // MARK: WEEKLY TASKS
                    Section(header: TaskSectionHeader(symbolSystemName: "sunset", headerText: "Weekly Tasks")

                            ) {
                        ForEach(nightWatchTasks.weeklyTasks.indices,id:\.self, content: {
                            task in
                            if focusModeOn == false || (focusModeOn && $nightWatchTasks.weeklyTasks[task].isComplete.wrappedValue == false){
                                NavigationLink(destination: DetailsView(task: $nightWatchTasks.weeklyTasks[task]), label: {
                                    TaskRow(task: nightWatchTasks.weeklyTasks[task])
                                }).foregroundColor(.gray)

                            }


                        }).onDelete(perform: {indexSet in
                            nightWatchTasks.weeklyTasks.remove(atOffsets: indexSet)
                        }).onMove(perform: {
                            indices, newOffSet in
                            nightWatchTasks.weeklyTasks.move(fromOffsets: indices, toOffset: newOffSet)
                        })
                    }
                    // MARK: MONTHLY TASKS
                    Section(header: TaskSectionHeader(symbolSystemName: "calendar", headerText: "Monthly Tasks")

                            ) {
                        ForEach(nightWatchTasks.monthlyTasks.indices,id:\.self, content: {
                            task in
                            if focusModeOn == false || (focusModeOn && $nightWatchTasks.monthlyTasks[task].isComplete.wrappedValue == false){
                                NavigationLink(destination: DetailsView(task: $nightWatchTasks.monthlyTasks[task]), label: {
                                    TaskRow(task: nightWatchTasks.monthlyTasks[task])
                                }).foregroundColor(.gray)

                            }

                        }).onDelete(perform: {indexSet in
                            nightWatchTasks.monthlyTasks.remove(atOffsets: indexSet)
                        }).onMove(perform: {
                            indices, newOffSet in
                            nightWatchTasks.monthlyTasks.move(fromOffsets: indices, toOffset: newOffSet)
                        })
                    }



                }.listStyle(GroupedListStyle()).navigationTitle("Home")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading){
                            EditButton().foregroundColor(.accentColor)
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button("Reset"){
                                resetAlertShowing = true
                            }.foregroundColor(.accentColor)
                        }

                        ToolbarItem(placement: .bottomBar) {
                            Toggle(isOn: $focusModeOn, label: {Text("Focus Mode")}).toggleStyle(.switch)
                    }
                    }
            }.alert(isPresented: $resetAlertShowing, content: {
                Alert(title: Text("Reset List"),message: Text("Are you sure?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Yes, reset it"),action: {
                    let refreshedNightWatchTasks = NightWatchTasks()
                    self.nightWatchTasks.nightlyTasks = refreshedNightWatchTasks.nightlyTasks
                    self.nightWatchTasks.weeklyTasks = refreshedNightWatchTasks.weeklyTasks
                    self.nightWatchTasks.monthlyTasks = refreshedNightWatchTasks.monthlyTasks
                }))
            })

        }



    }
}

struct TaskSectionHeader: View {
    let symbolSystemName:String
    let headerText:String
    var body: some View {
        HStack {
            Text(Image(systemName: symbolSystemName)).foregroundColor(.accentColor).font(.title3).fontWeight(.heavy)
            Text(headerText).font(.title3).fontWeight(.heavy).foregroundColor(.accentColor).underline().textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
        }
    }
}


struct TaskRow: View {
    let task:Task
    var body: some View {
        VStack {
            if task.isComplete {
                HStack {
                    Image(systemName: "checkmark.square")
                    Text(task.name)
                        .foregroundColor(.gray)
                    .strikethrough()
                }

            } else {
                HStack {
                    Image(systemName: "square")
                    Text(task.name)
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let nightWatchTasks = NightWatchTasks()
        ContentView(nightWatchTasks: nightWatchTasks)
            .preferredColorScheme(.dark)
    }
}





