//
//  ContentView.swift
//  MVVM test
//
//  Created by addin on 29/12/20.
//

import SwiftUI

let apiUrl = "https://api.letsbuildthatapp.com/static/courses.json"

struct Course: Identifiable, Decodable {
    var id = UUID()
    let name: String
}

class CoursesViewModel: ObservableObject {
    
    @Published var msg = "ini msg"
    @Published var courses: [Course] = [
        .init(name: "course 1"),
        .init(name: "course 2"),
        .init(name: "course 3")

    ]
    
    func FetchData() {
        guard let url = URL(string: apiUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
     
                DispatchQueue.main.async {
                    self.courses = try! JSONDecoder().decode([Course].self, from: data!)
                
            }
        }.resume()
    }
    
    func change() {
        msg = "NANI"
    }
}

struct ContentView: View {
    @ObservedObject var coursesVM = CoursesViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(coursesVM.courses) { course in
                    Text(course.name)
                }
            }
            .navigationBarTitle("Courses")
            .navigationBarItems(trailing: Button(action:{
                print("refresh")
                coursesVM.FetchData()
            }) {
                Text("Refresh")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
