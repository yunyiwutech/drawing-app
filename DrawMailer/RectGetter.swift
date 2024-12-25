//
//  RectGetter.swift
//  DrawMailer
//
//  Created by Yunyi Wu on 15.12.2024..
//

import SwiftUI

struct RectGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        GeometryReader { proxy in
            createView(proxy: proxy)
        }
    }
    
    private func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            rect = proxy.frame(in: .global)
        }
        return Rectangle().fill(Color.clear)
    }
}
