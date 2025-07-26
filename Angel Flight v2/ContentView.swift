//
//  ContentView.swift
//  Angel Flight v2
//
//  Created by Philip Casey on 7/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
    ZStack {
        Color.gray
            .edgesIgnoringSafeArea(.all)
        VStack {
            HStack {
                VStack {
                    VStack {
                        Text("Monday")
                        
                    }
                    VStack {
                        Text("July 28, 2025")
                            .font(.title)
                    }
                    VStack {
                        HStack {
                            Text("Departing")
                            Text("8:00 AM")
                        }
                        .font(.footnote)
                    }
                }
            }
            HStack {
               VStack {
                   HStack {
                       Text("Savannah, GA")
                           .font(.callout)
                   }
                    HStack {
                        Text("SAV")
                            .font(.title)
                    }
                   

                }
                Spacer()
                VStack{
                    HStack{
                        VStack{
                            Image(systemName: "airplane")
                                .font(.title)
                        }
                    }
                }
                Spacer()
                VStack{
                    HStack {
                        Text("Atlanta, GA")
                            .font(.callout)
                    }
                    HStack{
                        Text("PDK")
                            .font(.title)
                    }
                }
            }
            .padding()
                HStack{
                    VStack{
                        HStack{
                            Text("Transplant-Heart")
                                .font(.headline)
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "person.fill")
                            Text("230")
                            Image(systemName: "person.fill")
                            Text("146")
                            Image(systemName: "suitcase.fill")
                            Text("20")
                            Spacer()
                        }
                    }
                    Spacer()
                    HStack {
                        Button("View Mission") {
                            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(4)

        }
        
        .padding()
        .background(Color.white, in: RoundedRectangle(cornerRadius: 18))
        .padding()
        }
    }
    
}


#Preview {
    ContentView()
}
