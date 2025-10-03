//
//  SuccessPaymentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Анна Рыкунова on 26.09.2025.
//

import SwiftUI

struct SuccessPaymentView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var paymentMethodIsOpen: Bool
    @Binding var cartViewModel: CartViewModel?
    
    var body: some View {
        VStack {
            Image("SuccessPayment")
                .resizable()
                .scaledToFit()
                .frame(width: 278, height: 278)
                .padding()
            Text("CartFlow.SuccessPayment.title")
                .font(.appBold22)
                .foregroundColor(.blackAndWhite)
                .multilineTextAlignment(.center)
                .frame(width: 304)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        Button(String(localized: "CartFlow.SuccessPayment.backToCart")) {
            paymentMethodIsOpen = false
            dismiss()
            Task {
                await cartViewModel?.cleanCart()
            }
        }
        .buttonStyle(BlackButton())
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
    }
}

#Preview {
    SuccessPaymentView(paymentMethodIsOpen: .constant(true), cartViewModel: .constant(nil))
}
