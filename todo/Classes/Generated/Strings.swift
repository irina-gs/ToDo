// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Auth {
    /// E-mail
    internal static let emailTextField = L10n.tr("Localizable", "auth.email-text-field", fallback: "E-mail")
    /// Пароль
    internal static let passwordTextField = L10n.tr("Localizable", "auth.password-text-field", fallback: "Пароль")
    /// Войти
    internal static let signInButton = L10n.tr("Localizable", "auth.sign-in-button", fallback: "Войти")
    /// Еще нет аккаунта?
    internal static let signUpButton = L10n.tr("Localizable", "auth.sign-up-button", fallback: "Еще нет аккаунта?")
    /// Авторизация
    internal static let title = L10n.tr("Localizable", "auth.title", fallback: "Авторизация")
  }
  internal enum EditItem {
    /// Удалить
    internal static let deleteButton = L10n.tr("Localizable", "edit-item.delete-button", fallback: "Удалить")
    /// Запись
    internal static let title = L10n.tr("Localizable", "edit-item.title", fallback: "Запись")
  }
  internal enum ErrorValidation {
    /// Введите корректный email
    internal static let email = L10n.tr("Localizable", "error-validation.email", fallback: "Введите корректный email")
    /// Поле должно быть заполнено
    internal static let emptyField = L10n.tr("Localizable", "error-validation.empty-field", fallback: "Поле должно быть заполнено")
    /// Пароль должен быть до 256 символов
    internal static let password = L10n.tr("Localizable", "error-validation.password", fallback: "Пароль должен быть до 256 символов")
    /// Имя должно быть до 70 символов длиной
    internal static let username = L10n.tr("Localizable", "error-validation.username", fallback: "Имя должно быть до 70 символов длиной")
  }
  internal enum Main {
    /// Дедлайн: dd MMMM yyyy в HH:mm
    internal static let dateFormat = L10n.tr("Localizable", "main.date-format", fallback: "Дедлайн: dd MMMM yyyy в HH:mm")
    /// Новая запись
    internal static let emptyButton = L10n.tr("Localizable", "main.empty-button", fallback: "Новая запись")
    /// Пока здесь нет ни одной записи.
    ///  Создайте новую!
    internal static let emptyLabel = L10n.tr("Localizable", "main.empty-label", fallback: "Пока здесь нет ни одной записи.\n Создайте новую!")
    /// Нет соединения
    internal static let errorNoConnectionLabel = L10n.tr("Localizable", "main.error-no-connection-label", fallback: "Нет соединения")
    /// Что-то пошло не так
    internal static let errorSomethingWentWrongLabel = L10n.tr("Localizable", "main.error-something-went-wrong-label", fallback: "Что-то пошло не так")
    /// Обновить
    internal static let errorUpdateButton = L10n.tr("Localizable", "main.error-update-button", fallback: "Обновить")
    /// Профиль
    internal static let profileButton = L10n.tr("Localizable", "main.profile-button", fallback: "Профиль")
    /// Список дел
    internal static let title = L10n.tr("Localizable", "main.title", fallback: "Список дел")
  }
  internal enum NetworkError {
    /// Упс! Неверный ответ сервера.
    internal static let wrongResponse = L10n.tr("Localizable", "network-error.wrong-response", fallback: "Упс! Неверный ответ сервера.")
    /// Упс! Неверный статус код.
    internal static let wrongStatusCode = L10n.tr("Localizable", "network-error.wrong-status-code", fallback: "Упс! Неверный статус код.")
    /// Упс! Неверный url.
    internal static let wrongUrl = L10n.tr("Localizable", "network-error.wrong-url", fallback: "Упс! Неверный url.")
  }
  internal enum NewItem {
    /// Создать
    internal static let createButton = L10n.tr("Localizable", "new-item.create-button", fallback: "Создать")
    /// Дедлайн
    internal static let deadlineLabel = L10n.tr("Localizable", "new-item.deadline-label", fallback: "Дедлайн")
    /// Описание
    internal static let descriptionTextViewLabel = L10n.tr("Localizable", "new-item.description-text-view-label", fallback: "Описание")
    /// Новая запись
    internal static let title = L10n.tr("Localizable", "new-item.title", fallback: "Новая запись")
    /// Что нужно сделать
    internal static let titleTextViewLabel = L10n.tr("Localizable", "new-item.title-text-view-label", fallback: "Что нужно сделать")
  }
  internal enum Profile {
    /// Отменить
    internal static let alertCancelButton = L10n.tr("Localizable", "profile.alert-cancel-button", fallback: "Отменить")
    /// Выйти
    internal static let alertExitButton = L10n.tr("Localizable", "profile.alert-exit-button", fallback: "Выйти")
    /// Выйти из профиля?
    internal static let alertTitle = L10n.tr("Localizable", "profile.alert-title", fallback: "Выйти из профиля?")
    /// Выход
    internal static let exitButton = L10n.tr("Localizable", "profile.exit-button", fallback: "Выход")
    /// Профиль
    internal static let title = L10n.tr("Localizable", "profile.title", fallback: "Профиль")
  }
  internal enum SignUp {
    /// E-mail
    internal static let emailTextField = L10n.tr("Localizable", "sign-up.email-text-field", fallback: "E-mail")
    /// Пароль
    internal static let passwordTextField = L10n.tr("Localizable", "sign-up.password-text-field", fallback: "Пароль")
    /// Зарегистрироваться
    internal static let signUpButton = L10n.tr("Localizable", "sign-up.sign-up-button", fallback: "Зарегистрироваться")
    /// Регистрация
    internal static let title = L10n.tr("Localizable", "sign-up.title", fallback: "Регистрация")
    /// Имя пользователя
    internal static let usernameTextField = L10n.tr("Localizable", "sign-up.username-text-field", fallback: "Имя пользователя")
  }
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
