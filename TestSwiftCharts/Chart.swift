//
//  Chart.swift
//  TestSwiftCharts
//
//  Created by Jake Nelson on 27/07/2022.
//

import SwiftUI
import Charts


struct InteractiveLollipopChart: View {
    
    @Binding var selectedElement: HourWeatherStruct?
    
    func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> HourWeatherStruct? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            
            for salesDataIndex in hours.indices {
                let nthSalesDataDistance = hours[salesDataIndex].date.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = salesDataIndex
                }
            }
            if let index = index {
                return hours[index]
            }
        }
        return nil
    }
    
    let colors: [Color] = [.red, .green, .purple, .teal, .orange]
    var randomGradient: AnyGradient {
        if let color = colors.randomElement() {
            return color.gradient
        }
        else {
            return Color.red.gradient
        }
    }
    
    var testGradient: LinearGradient {
        return LinearGradient(colors: [.yellow.opacity(0.6), .blue.opacity(0.6)], startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        Chart {
            ForEach(hours, id: \.date) {
                LineMark(
                    x: .value("Date", $0.date, unit: .hour),
                    y: .value("Wind Speed", $0.windSpeed)
                )
                .foregroundStyle(by: .value("Value", "Wind"))
                
                LineMark(
                    x: .value("Date", $0.date, unit: .hour),
                    y: .value("Pressure", ($0.pressure - 1014) * 4)
                )
                .foregroundStyle(by: .value("Value", "Pressure"))
            }
            .lineStyle(StrokeStyle(lineWidth: 4.0))
            .interpolationMethod(.catmullRom)
            
            if let selectedElement = selectedElement {
                PointMark(
                    x: .value("Date", selectedElement.date, unit: .hour),
                    y: .value("Pressure", (selectedElement.pressure - 1014) * 4)
                )
                .symbolSize(100.0)
                .foregroundStyle(
                    Color.purple
                )
                PointMark(
                    x: .value("Date", selectedElement.date, unit: .hour),
                    y: .value("Wind Speed", selectedElement.windSpeed)
                )
                .symbolSize(100.0)
                .foregroundStyle(
                    Color.teal
                )
            }
        }
        .chartForegroundStyleScale([
            "Pressure": .purple,
            "Wind": .teal
        ])
        .chartXAxis {
            //            AxisMarks(position: .top, values: .stride(by: .hour, count: 2)) {
            //                _ in
            //                AxisValueLabel("🌊", centered: true)
            //            }
            AxisMarks(position: .bottom, values: .stride(by: .hour, count: 2)) {
                _ in
                AxisTick()
                AxisGridLine()
                AxisValueLabel(format: .dateTime.hour(), centered: true)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: Array(stride(from: 0, through: 24, by: 4))){
                axis in
                AxisTick()
                AxisGridLine()
                AxisValueLabel("\(1014 + (axis.index * 1))", centered: false)
            }
            AxisMarks(position: .trailing, values: Array(stride(from: 0, through: 24, by: 4))){
                axis in
                AxisTick()
                AxisGridLine()
                AxisValueLabel("\(axis.index * 4)", centered: false)
            }
        }
        .chartOverlay { proxy in
            GeometryReader { nthGeometryItem in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElement(location: value.location, proxy: proxy, geometry: nthGeometryItem)
                                if selectedElement?.date == element?.date {
                                    // If tapping the same element, clear the selection.
                                    selectedElement = nil
                                } else {
                                    selectedElement = element
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElement = findElement(location: value.location, proxy: proxy, geometry: nthGeometryItem)
                                    }
                            )
                    )
            }
        }
    }
}

struct InteractiveLollipop: View {
    
    @State private var selectedElement: HourWeatherStruct? = nil
    @Environment(\.layoutDirection) var layoutDirection
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Windspeed and Pressure")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text("\(hours.first?.date ?? Date(), format: .dateTime)")
                        .font(.title2.bold())
                }
                .opacity(selectedElement == nil ? 1 : 0)
                
                InteractiveLollipopChart(selectedElement: $selectedElement)
                    .frame(height: 200)
            }
            .chartBackground { proxy in
                ZStack(alignment: .topLeading) {
                    GeometryReader { nthGeoItem in
                        if let selectedElement = selectedElement {
                            let dateInterval = Calendar.current.dateInterval(of: .hour, for: selectedElement.date)!
                            let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                            let startPositionX2 = proxy.position(forX: dateInterval.end) ?? 0
                            let midStartPositionX = (startPositionX1 + startPositionX2) / 2 + nthGeoItem[proxy.plotAreaFrame].origin.x
                            
                            let lineX = layoutDirection == .rightToLeft ? nthGeoItem.size.width - midStartPositionX : midStartPositionX
                            let lineHeight = nthGeoItem[proxy.plotAreaFrame].maxY
                            let boxWidth: CGFloat = 150
                            let boxOffset = max(0, min(nthGeoItem.size.width - boxWidth, lineX - boxWidth / 2))
                            
                            Rectangle()
                                .fill(.quaternary)
                                .frame(width: 2, height: lineHeight)
                                .position(x: lineX, y: lineHeight / 2)
                            
                            VStack(alignment: .leading) {
                                Text("\(selectedElement.date, format: .dateTime.hour())")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                Text("\(selectedElement.windSpeed, format: .number)km/h\n\(selectedElement.pressure, format: .number)kpa")
                                    .font(.body.bold())
                                    .foregroundColor(.primary)
                            }
                            .frame(width: boxWidth, alignment: .leading)
                            .background {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.background)
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.quaternary.opacity(0.7))
                                }
                                .padding([.leading, .trailing], -8)
                                .padding([.top, .bottom], -4)
                            }
                            .offset(x: boxOffset)
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationBarTitle("Interactive Lollipop", displayMode: .inline)
    }
}
