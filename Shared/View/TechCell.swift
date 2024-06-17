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
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(.callout)
          .foregroundColor(.gray)
      }
    }
    .background(.clear)
    .padding()
  }
}

struct CustomCell_Previews: PreviewProvider {
  static var previews: some View {
    TechCell(tech: TechnologyModel(name: "ahuto dornds", type: .autoDrones, improved: true)).previewLayout(.sizeThatFits)
  }
}
