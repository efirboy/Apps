//
//  WeatherCategory.swift
//  WeatherApp
//
//  Created by Alexandr Garkalin on 29.05.2025.
//

import Foundation
import UIKit

enum WeatherCondition: String, CaseIterable {
    
    // Ясно, солнечно
    case clear = "Ясно"
    case sunny = "Солнечно"

    // Облака
    case partlyCloudy = "Переменная облачность"
    case cloudy = "Облачно"
    case overcast = "Пасмурно"
    case haze = "Дымка"

    // Дождь
    case patchyRain = "Местами дождь"
    case lightRain = "Небольшой дождь"
    case moderateRain = "Умеренный дождь"
    case heavyRain = "Сильный дождь"
    case lightRainShowers = "Небольшой ливневый дождь"
    case heavyRainShowers = "Умеренный или сильный ливневый дождь"
    case torrentialRain = "Сильные ливни"

    // Морось
    case patchyDrizzle = "Местами слабая морось"
    case lightDrizzle = "Слабая морось"
    case freezingDrizzle = "Замерзающая морось"
    case heavyFreezingDrizzle = "Сильно замерзающая морось"

    // Переохлажденный дождь
    case lightFreezingRain = "Слабый переохлажденный дождь"
    case moderateOrHeavyFreezingRain = "Умеренный или сильный переохлажденный дождь"

    // Снег
    case patchySnow = "Местами снег"
    case patchyLightSnow = "Местами небольшой снег"
    case lightSnow = "Небольшой снег"
    case moderateSnow = "Умеренный снег"
    case heavySnow = "Сильный снег"
    case snowShowers = "Небольшой ливневый дождь со снегом"
    case heavySnowShowers = "Умеренные или сильные ливневые дожди со снегом"
    
    // Дождь со снегом
    case patchySleet = "Местами дождь со снегом"
    case lightSleet = "Небольшой дождь со снегом"
    case moderateOrHeavySleet = "Умеренный или сильный дождь со снегом"

    // Ледяной дождь
    case iceRain = "Ледяной дождь"
    case lightIceRain = "Небольшой ледяной дождь"
    case moderateOrHeavyIceRain = "Умеренный или сильный ледяной дождь"

    // Гроза
    case patchyThunderRain = "В отдельных районах местами небольшой дождь с грозой"
    case moderateOrHeavyThunderRain = "В отдельных районах умеренный или сильный дождь с грозой"
    case patchyThunderSnow = "В отдельных районах местами небольшой снег с грозой"
    case moderateOrHeavyThunderSnow = "В отдельных районах умеренный или сильный снег с грозой"
    case thunder = "Местами грозы"

    // Туман и метель
    case fog = "Туман"
    case freezingFog = "Переохлажденный туман"
    case blizzard = "Метель"
    case blowingSnow = "Поземок"

    // По умолчанию
    case unknown = "Неизвестно"

    /// Сопоставление строки с enum
    static func from(description: String) -> WeatherCondition {
        let lowered = description.lowercased()
        
        for condition in WeatherCondition.allCases {
            if lowered.contains(condition.rawValue.lowercased()) {
                return condition
            }
        }

        return .unknown
    }

    /// Имя виедофайла с фоном
    var videoName: String {
        switch self {
        case .clear, .sunny:
            return "sunny"
        case .partlyCloudy, .cloudy, .overcast, .haze:
            return "cloudy"
        case .patchyRain, .lightRain, .moderateRain, .heavyRain,
             .lightRainShowers, .heavyRainShowers, .torrentialRain,
             .patchyDrizzle, .lightDrizzle, .freezingDrizzle, .heavyFreezingDrizzle,
             .lightFreezingRain, .moderateOrHeavyFreezingRain,
             .lightSleet, .moderateOrHeavySleet:
            return "rain"
        case .patchySnow, .patchyLightSnow, .lightSnow, .moderateSnow, .heavySnow,
             .snowShowers, .heavySnowShowers,
             .iceRain, .lightIceRain, .moderateOrHeavyIceRain:
            return "snow"
        case .patchyThunderRain, .moderateOrHeavyThunderRain,
                .patchyThunderSnow, .blizzard, .blowingSnow, .moderateOrHeavyThunderSnow, .thunder:
            return "storm"
        case .fog, .freezingFog:
            return "fog"
        default:
            return "cloudy"
        }
    }
    
    // Цвет фона для ячейки
    var backgroundColor: UIColor {
        switch self {
        case .clear, .sunny:
            return UIColor.systemYellow.withAlphaComponent(0.07)
        case .partlyCloudy, .cloudy, .overcast, .haze:
            return UIColor.systemGray.withAlphaComponent(0.07)
        case .patchyRain, .lightRain, .moderateRain, .heavyRain,
                .lightRainShowers, .heavyRainShowers, .torrentialRain:
            return UIColor.systemBlue.withAlphaComponent(0.07)
        case .patchyDrizzle, .lightDrizzle, .freezingDrizzle, .heavyFreezingDrizzle,
                .lightFreezingRain, .moderateOrHeavyFreezingRain:
            return UIColor.systemTeal.withAlphaComponent(0.07)
        case .patchySnow, .patchyLightSnow, .lightSnow, .moderateSnow, .heavySnow,
                .snowShowers, .heavySnowShowers:
            return UIColor.systemIndigo.withAlphaComponent(0.07)
        case .iceRain, .lightIceRain, .moderateOrHeavyIceRain,
                .patchySleet, .lightSleet, .moderateOrHeavySleet:
            return UIColor.systemPurple.withAlphaComponent(0.07)
        case .patchyThunderRain, .moderateOrHeavyThunderRain,
                .patchyThunderSnow, .moderateOrHeavyThunderSnow, .thunder:
            return UIColor.systemOrange.withAlphaComponent(0.07)
        case .fog, .freezingFog:
            return UIColor.systemGray2.withAlphaComponent(0.07)
        case .blizzard, .blowingSnow:
            return UIColor.systemGray3.withAlphaComponent(0.07)
        case .unknown:
            return UIColor.systemBackground
        }
        }
}

