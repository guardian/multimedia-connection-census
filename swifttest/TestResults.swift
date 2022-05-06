//
//  TestResults.swift
//  swifttest
//
//  Created by Andy Gallagher on 06/05/2022.
//

import SwiftUI

struct TestResultsView<Content>: View where Content : View  {
    @Binding var iconColour:Color
    @Binding var testWasRun:Bool
    
    let labelColumnWidth:CGFloat = 100.0
    
    var label:String = "Test"
    @State var content:Content
    
    var body: some View {
        HStack(alignment: .top, spacing: 10, content: {
            Circle().size(
                CGSize(width: 18, height: 18))
                .foregroundColor(iconColour)
                .frame(width:20, height:20)
            Text(label).multilineTextAlignment(.leading)
                .frame(width:labelColumnWidth, height:20)
            if testWasRun {
                content
            } else {
                Text("Run test to see results")
            }
        }).padding(.all, 20)
    }
}

struct TestResults_Previews: PreviewProvider {
    @State static var iconColour:Color = .yellow
    @State static var testWasRun = true
    
    static var previews: some View {
        TestResultsView(iconColour: $iconColour, testWasRun: $testWasRun, content: Text("Results go here"))
    }
}
