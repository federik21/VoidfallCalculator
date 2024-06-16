//combatLog
//  ContentView.swift
//  Shared
//
//  Created by federico piccirilli on 11/11/2022.
//

import SwiftUI

struct ContentView: View {
  // TODO: inject
  @StateObject private var viewModel: CombatViewModel = CombatViewModel(attacker: Player(side: .invader), defender: Player(side: .defender), sectorDefenses: 0)

  @State private var showPopup = false
  @State private var showCombatResult = false
  @State private var activeSide = Player.Side.invader

  var body: some View {
    NavigationView {
      VStack {
        // Attacker view
        VStack {
          HStack {
            Text("Invader").fontWeight(.heavy)
              .foregroundColor(.white)

              .padding()
            Button("+") {
              activeSide = .invader
              showPopup.toggle()
            }.foregroundColor(.white)
            Spacer()
          }.frame(maxWidth: .infinity, alignment: .leading)
          ScrollView {
            FleetView(player: viewModel.attacker)
          }
          if !viewModel.attacker.technologies.isEmpty {
            TechnologyView(player: viewModel.attacker)
          } else {
            /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
          }
        }
        .background(                Color(#colorLiteral(red: 0.0, green: 0.5, blue: 0.5, alpha: 0.5)))

        // Defender view
        VStack {
          HStack {
            Text("Defender").fontWeight(.heavy).foregroundColor(.white)
              .padding()
            Button("+") {
              activeSide = .defender
              showPopup.toggle()
            }.foregroundColor(.white)
          }.frame(maxWidth: .infinity, alignment: .leading)
          Stepper(
            "Sector Defenses \(viewModel.sectorDefenses)",
            value: $viewModel.sectorDefenses,
            in: 0...3)
          .padding(.horizontal)
          .background(.gray)
          ScrollView {
            FleetView(player: viewModel.defender)
          }
          if !viewModel.defender.technologies.isEmpty {
            TechnologyView(player: viewModel.defender)
          } else {
              /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
            }
          }.background(Color(#colorLiteral(red: 0.0, green: 0.5, blue: 0.5, alpha: 0.5))
            )

          Button(action: {
            showCombatResult.toggle()
            viewModel.combat()
          }) {
            Text("Calculate")
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(10)
          }
          .padding()
        }
        .background(
          Image("bg")
            .resizable()
            .scaledToFill()
        )
        .navigationBarTitle("Voidfall Combat", displayMode: .inline)
        .sheet(isPresented: $showPopup) {
          TechnologyDialog(showPopup: $showPopup,
                           player: activeSide == .invader ? viewModel.attacker : viewModel.defender)
        }
        // to pass the object to every subview
      }.environmentObject(viewModel)
        .alert(isPresented: $showCombatResult) {
          Alert(
            title: Text("Result"),
            message: Text(viewModel.combatLog),
            dismissButton: .default(Text("OK"))
          )
        }
    }
  }

  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      return ContentView()
    }
  }

  struct TechnologyView: View {
    @EnvironmentObject var viewModel: CombatViewModel
    @ObservedObject var player: Player

    var body: some View {
      List {
        Section(header: TechnologyViewHeader(text: "TECHNOLOGIES")) {
          ForEach(player.getTech()) { tech in
            TechCell(tech: tech).frame(height: 12).background(.clear)
          }}
      }
      .listRowInsets(EdgeInsets())
      .listStyle(.plain)
      .background(                Color(#colorLiteral(red: 0.0, green: 0.5, blue: 0.5, alpha: 0.5))
      )
    }
  }

  struct TechnologyViewHeader: View {
    var text: String

    var body: some View {
      Text(text)
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(Color( #colorLiteral(red: 0.7119045854, green: 0.4088150859, blue: 0.4211392999, alpha: 1)))

    }
  }
