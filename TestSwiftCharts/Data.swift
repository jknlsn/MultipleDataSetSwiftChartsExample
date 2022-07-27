//
//  Data.swift
//  TestSwiftCharts
//
//  Created by Jake Nelson on 27/07/2022.
//

import Foundation


struct HourWeatherStruct {
    var date: Date
    var pressure: Double
    var temperature: Double
    var windSpeed: Double
}

let hours: [HourWeatherStruct] = [
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600),
                      pressure: 1015.0,
                      temperature: 18.2,
                      windSpeed: 6.1),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 2),
                      pressure: 1015.3,
                      temperature: 18.2,
                      windSpeed: 8.1),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 3),
                      pressure: 1015.9,
                      temperature: 18.2,
                      windSpeed: 9.4),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 4),
                      pressure: 1016.3,
                      temperature: 18.2,
                      windSpeed: 5.2),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 5),
                      pressure: 1016.3,
                      temperature: 18.2,
                      windSpeed: 12.1),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 6),
                      pressure: 1016.3,
                      temperature: 18.2,
                      windSpeed: 11.1),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 7),
                      pressure: 1017.3,
                      temperature: 18.2,
                      windSpeed: 10.1),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 8),
                      pressure: 1018.3,
                      temperature: 18.2,
                      windSpeed: 11.1),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 9),
                      pressure: 1018.3,
                      temperature: 18.2,
                      windSpeed: 9.1),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 10),
                      pressure: 1018.3,
                      temperature: 18.2,
                      windSpeed: 8.1),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 11),
                      pressure: 1017.3,
                      temperature: 18.2,
                      windSpeed: 19.9),
    HourWeatherStruct(date: Date(timeIntervalSinceNow: 3600 * 12),
                      pressure: 1018.3,
                      temperature: 18.2,
                      windSpeed: 7.1),
]
