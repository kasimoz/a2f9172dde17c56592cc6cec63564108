//
//  CustomSlider.swift
//  a2f9172dde17c56592cc6cec63564108
//
//  Created by KasimOzdemir on 21.11.2021.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var properties : [Property]
    @Binding var property : Property
    @Binding var sharedValue: Int
    var body: some View {
        VStack{
            HStack {
                Text(property.name)
                    .font(Font.Atures(.bold, size: 14))
                    .foregroundColor(Colors.orange)
                Spacer()
                Text("\(property.value)")
                    .font(Font.Atures(.black, size: 14))
                    .foregroundColor(Colors.orange).padding()
            }
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
                Capsule()
                    .fill(Colors.sliderColor)
                    .frame(height: 20)
                Capsule()
                    .fill(property.color)
                    .frame(width : property.offset + 16, height: 20)
                Circle()
                    .fill(Colors.yellow)
                    .frame(width: 24, height: 24)
                    .background(Circle().stroke(.white, lineWidth: 6))
                    .offset(x: property.offset)
                    .gesture(DragGesture().onChanged({ value in
                        if value.location.x >= 12 && value.location.x <= getRect().width - 44 {
                            let result = calculate(offset: value.location.x - 12)
                            property.offset = CGFloat(result)
                            switch property.type {
                            case .capacity:
                                let f1 = (properties[2].offset + properties[0].offset)
                                let f2 = properties[1].offset
                                if  f1 + f2  > getRect().width - 44 {
                                    property.offset = CGFloat(calculate(offset: getRect().width - 44 - (properties[0].offset + properties[1].offset)))
                                }
                                break
                            case .durability:
                                let f1 = (properties[0].offset + properties[1].offset)
                                let f2 = properties[2].offset
                                if  f1 + f2  > getRect().width - 44 {
                                    property.offset = CGFloat(calculate(offset: getRect().width - 44 - (properties[1].offset + properties[2].offset)))
                                }
                                break
                            case .speed:
                                let f1 = (properties[1].offset + properties[0].offset)
                                let f2 = properties[2].offset
                                if  f1 + f2  > getRect().width - 44 {
                                    property.offset = CGFloat(calculate(offset: getRect().width - 44 - (properties[0].offset + properties[2].offset)))
                                }
                                break
                            }
                            if let index = index(offset: Int(property.offset)) {
                                property.value = index
                                sharedValue = 15 - properties.map({$0.value}).reduce(0, +)
                            }
                        }
                        
                    }))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 32)
    }
    
    func calculate(offset : CGFloat) -> Int{
        let array: Array<Int> = Array(0...Int(getRect().width - 44)).filter({$0 % Int((getRect().width - 32) / 15) == 0 })
        return array.reduce(100, { x, y in
            abs(Double(x) - offset) > abs(Double(y) - offset) ? y : x
        })
    }
    
    func index(offset : Int) -> Int?{
        let array: Array<Int> = Array(0...Int(getRect().width - 44)).filter({$0 % Int((getRect().width - 32) / 15) == 0 })
        return array.firstIndex(of: offset)
    }
}
