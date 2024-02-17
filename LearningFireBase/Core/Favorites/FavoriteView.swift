//
//  FavoriteView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 1/4/24.
//

import SwiftUI
import Combine


struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()
    
    var body: some View {
        List{
            ForEach(viewModel.userFavoriteProducts, id: \.id.self) {item in
                ProductCellViewBuilder(productId: String(item.productId))
                    .contextMenu {
                        Button("Remove from favorites") {
                            viewModel.removeFromFavorites(favoriteProductId: item.id)
                        }
                    }
            
            }
        }
        .navigationTitle("Favorites")
        .onFirstAppear{
            viewModel.addListenerForFavorites()
        }
    }
}

#Preview {
    NavigationStack{
        FavoriteView()
    }
}

