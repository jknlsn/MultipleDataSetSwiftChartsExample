//
//  MinimalChart.swift
//  TestSwiftCharts
//
//  Created by Jake Nelson on 26/07/2022.
//

import Charts
import SwiftUI
import WeatherKit

struct InteractiveLollipopChartMinimal: View {
    
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
        }
        .chartForegroundStyleScale([
            "Pressure": .purple,
            "Wind": .teal
        ])
        .chartXAxis {
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
    }
}

struct InteractiveLollipopMinimal: View {
    
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
                
                InteractiveLollipopChartMinimal()
                    .frame(height: 200)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationBarTitle("Interactive Lollipop", displayMode: .inline)
    }
}

