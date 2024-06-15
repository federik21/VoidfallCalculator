//
//  TechCell.swift
//  VoidfallCombat (iOS)
//
//  Created by federico piccirilli on 14/06/2024.
//

import Foundation
import SwiftUI

struct TechCell: View {
  var tech: TechnologyModel

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(tech.name)
          .font(.callout)
      }
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundColor(.gray)
    }
    .padding()
  }
}

struct CustomCell_Previews: PreviewProvider {
  static var previews: some View {
    TechCell(tech: TechnologyModel(type: .autoDrones)).previewLayout(.sizeThatFits)
  }
}
