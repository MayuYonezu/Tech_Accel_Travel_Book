// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// 予定の詳細
  internal static let appointmentDetails = L10n.tr("Localizable", "appointment_details", fallback: "予定の詳細")
  /// 日程選択
  internal static let dateSelect = L10n.tr("Localizable", "date_select", fallback: "日程選択")
  /// Day1
  internal static let day1 = L10n.tr("Localizable", "day1", fallback: "Day1")
  /// Day2
  internal static let day2 = L10n.tr("Localizable", "day2", fallback: "Day2")
  /// Day3
  internal static let day3 = L10n.tr("Localizable", "day3", fallback: "Day3")
  /// Day4
  internal static let day4 = L10n.tr("Localizable", "day4", fallback: "Day4")
  /// Day5
  internal static let day5 = L10n.tr("Localizable", "day5", fallback: "Day5")
  /// Day6
  internal static let day6 = L10n.tr("Localizable", "day6", fallback: "Day6")
  /// Day7
  internal static let day7 = L10n.tr("Localizable", "day7", fallback: "Day7")
  /// 出発日
  internal static let departureDate = L10n.tr("Localizable", "departure_date", fallback: "出発日")
  /// タイトルを入力
  internal static let enterTitle = L10n.tr("Localizable", "enter_title", fallback: "タイトルを入力")
  /// home
  internal static let home = L10n.tr("Localizable", "home", fallback: "home")
  /// 最終日
  internal static let lastDate = L10n.tr("Localizable", "last_date", fallback: "最終日")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok", fallback: "OK")
  /// ストーリーを1日10個載せる
  internal static let post10StoriesPerDay = L10n.tr("Localizable", "post_10_stories_per_day", fallback: "ストーリーを1日10個載せる")
  /// Save
  internal static let save = L10n.tr("Localizable", "save", fallback: "Save")
  /// 保存が完了しました
  internal static let saveCompleted = L10n.tr("Localizable", "save_completed", fallback: "保存が完了しました")
  /// YouTuber風な動画を撮って編集
  internal static let shootAndEditYouTuberLikeVideos = L10n.tr("Localizable", "shoot_and_edit_YouTuber-like_videos", fallback: "YouTuber風な動画を撮って編集")
  /// Success
  internal static let success = L10n.tr("Localizable", "success", fallback: "Success")
  /// 映えな写真を撮る
  internal static let takeAGoodPicture = L10n.tr("Localizable", "take_a_good_picture", fallback: "映えな写真を撮る")
  /// おしゃれなVlogを撮る
  internal static let takeAStylishVlog = L10n.tr("Localizable", "take_a_stylish_vlog", fallback: "おしゃれなVlogを撮る")
  /// 面白写真を撮る
  internal static let takeFunnyPictures = L10n.tr("Localizable", "take_funny_pictures", fallback: "面白写真を撮る")
  /// Localizable.strings
  ///   Tech_Accel_Travel_Book
  /// 
  ///   Created by 新垣 清奈 on 2023/01/22.
  internal static let tests = L10n.tr("Localizable", "tests", fallback: "テスト")
  /// 終わる時間
  internal static let timeToFinish = L10n.tr("Localizable", "time_to_finish", fallback: "終わる時間")
  /// 始まる時間
  internal static let timeToStart = L10n.tr("Localizable", "time_to_start", fallback: "始まる時間")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
