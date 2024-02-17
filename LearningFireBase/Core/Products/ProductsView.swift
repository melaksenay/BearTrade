//
//  ProductsView.swift
//  LearningFireBase
//
//  Created by Melak Senay (π-tix) on 12/29/23.
//

import SwiftUI
import FirebaseFirestore



struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    var body: some View {
        List{
            ForEach(viewModel.products) {product in
                ProductCellView(product: product)
                    .contextMenu(menuItems: {
                        Button("Add to favorites"){
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        }
                    })
                
                if  product == viewModel.products.last {
                    
                        ProgressView()
                            .onAppear {
                                print("fetching more products")
                                viewModel.getProducts()
                            }
                    
                }
                
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Menu("Filter: \( viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { filterOption in
                        Button(filterOption.rawValue){
                            Task{
                                try? await viewModel.filterSelected(option: filterOption)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Category: \( viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { categoryOption in
                        Button(categoryOption.rawValue){
                            Task{
                                try? await viewModel.categorySelected(option: categoryOption)
                            }
                        }
                    }
                }
            }
        })
        .onAppear {
//            viewModel.getProductsCount()
            viewModel.getProducts()
        }
    }
}

#Preview {
    NavigationStack{
        ProductsView()
    }
}
