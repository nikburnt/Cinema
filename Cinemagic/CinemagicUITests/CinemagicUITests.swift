//
//  CinemagicUITests.swift
//  CinemagicUITests
//
//  Created by Nik Burnt on 5/28/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

import XCTest


class CinemagicUITests: XCTestCase {

    let dateToChoose = "17"
    let dateToChooseInfo = "17 июня"
    let newTitle = "Мстители: Финал - 2"
    let newTitleAddition = "!"
    var newTitleChanged: String { newTitle + newTitleAddition }
    let newDescription = "Текст описания для теста"

    let movieToClaimTicket = "Железный человек 3"
    let ironMan2Movie = "Железный человек 2"

    let newUserLogin = "testuser@testmail.com"
    let newUserPassword = "newPASS1"

    let exists = NSPredicate(format: "exists == true")
    let notExists = NSPredicate(format: "exists == false")
    let hasFocus = NSPredicate(format: "hasKeyboardFocus == true")

    override func setUp() {
        continueAfterFailure = false
    }


    func testLoginAsAdministartor() {
        let app = XCUIApplication()
        app.launch()

        // MARK: - Тест 1: Авторизация администратора
        // Ожидаем появления экрана приветствия
        expectation(for: exists, evaluatedWith: app.staticTexts["Добро пожаловать в Cinemagic!"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Заполняем поля логин и пароль
        loginFill(app: app, login: "nikburnt@gmail.com", password: "q2w3e4R%")

        // Нажимаем кнопку Вход
        app.staticTexts["Вход"].tap()

        // Ожидаем открытия экрана администрирования фильмов
        expectation(for: exists, evaluatedWith: app.buttons["Добавить"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)


        // MARK: - Тест 2: Добавление фильма
        // Открываем экран добавления фильма
        app.buttons["Добавить"].tap()

        // Ожидаем октрытия экрана добавления фильма
        expectation(for: exists, evaluatedWith: app.navigationBars["Cinemagic.StaffMovieInfoView"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Пробуем выбрать изображение из галереи
        app.staticTexts["Коснитесь чтобы загрузить постер"].tap()

        // Ожидаем открытия галереи
        expectation(for: exists, evaluatedWith: app.navigationBars["PUPhotoPickerHostView"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Выбираем Все фото
        app.cells["Все фото"].tap()

        // Выбираем фотографию
        app.cells["Фотография, Книжная ориентация, 15 июня, 20:32"].doubleTap()

        // Ожидаем пока галерея закроется
        expectation(for: exists, evaluatedWith: app.navigationBars["Cinemagic.StaffMovieInfoView"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Выбираем дату показа
        app.cells.staticTexts[dateToChoose].tap()

        // Заполняем поле Названия
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(newTitle)

        // Заполняем поле Описание
        app.textViews.firstMatch.tap()
        app.textViews.firstMatch.typeText(newDescription)

        // Нажимаем кнопку Добавить
        app.staticTexts["Добавить"].tap()

        // Ожидаем открытия экрана администрирования фильмов
        expectation(for: exists, evaluatedWith: app.buttons["Добавить"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Ожидаем что на экране должна быть отображена ячейка с внесённой по фильму ифнормацией
        let newFilmCell = app.cells.firstMatch
        expectation(for: exists, evaluatedWith: newFilmCell.staticTexts[newTitle], handler: nil)
        expectation(for: exists, evaluatedWith: newFilmCell.staticTexts[newDescription], handler: nil)
        expectation(for: exists, evaluatedWith: newFilmCell.staticTexts[dateToChooseInfo], handler: nil)
        waitForExpectations(timeout: 2, handler: nil)


        // MARK: - Тест 3: Редактирвоание фильма
        // Нажимаем на добавленный фильм
        newFilmCell.tap()

        // Ожидаем октрытия экрана редактирования фильма
        expectation(for: exists, evaluatedWith: app.navigationBars["Cinemagic.StaffMovieInfoView"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Меняем поле Названия
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(newTitleAddition)

        // Нажимаем кнопку Сохранить
        app.staticTexts["Сохранить"].tap()

        // Ожидаем открытия экрана администрирования фильмов
        expectation(for: exists, evaluatedWith: app.buttons["Добавить"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Ожидаем что на экране должна быть отображена ячейка с обновлённой информацией по фильму
        let updatedFilmCell = app.cells.firstMatch
        expectation(for: exists, evaluatedWith: updatedFilmCell.staticTexts[newTitleChanged], handler: nil)
        expectation(for: exists, evaluatedWith: updatedFilmCell.staticTexts[newDescription], handler: nil)
        expectation(for: exists, evaluatedWith: updatedFilmCell.staticTexts[dateToChooseInfo], handler: nil)
        waitForExpectations(timeout: 2, handler: nil)


        // MARK: - Тест 4: Удаление фильма
        // Нажимаем на изменённый фильм
        updatedFilmCell.tap()

        // Ожидаем октрытия экрана редактирования фильма
        expectation(for: exists, evaluatedWith: app.navigationBars["Cinemagic.StaffMovieInfoView"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Нажимаем на кнопку удалить
        app.buttons["Удалить"].tap()

        // Подтверждаем удаление
        app.alerts["Подтверждение"].buttons["Удалить"].tap()

        // Убеждаемся что фильм удалён
        expectation(for: notExists, evaluatedWith: app.cells.firstMatch.staticTexts[newTitleChanged], handler: nil)


        // MARK: - Тест 5: Выход из аккаунта
        // Нажимаем на кнопку выхода
        app.buttons["Остановить"].tap()

        // Ожидаем появления экрана приветствия
        expectation(for: exists, evaluatedWith: app.staticTexts["Добро пожаловать в Cinemagic!"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)


        // MARK: - Тест 6: Регистрация нового пользователя
        // Заполняем логин и пароль для нового пользователя
        loginFill(app: app, login: newUserLogin, password: newUserPassword)

        // Нажимаем на кнопку Регистрация
        app.staticTexts["Регистрация"].tap()

        // Ожидаем октрытия экрана просмотра фильмов
        expectation(for: exists, evaluatedWith: app.navigationBars["Премьеры"], handler: nil)
        expectation(for: notExists, evaluatedWith: app.buttons["Добавить"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Нажимаем на кнопку выхода
        app.buttons["Остановить"].tap()

        // Ожидаем появления экрана приветствия
        expectation(for: exists, evaluatedWith: app.staticTexts["Добро пожаловать в Cinemagic!"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)


        // MARK: - Тест 7: Авторизация пользователя
        // Заполняем логин и пароль для нового пользователя
        loginFill(app: app, login: newUserLogin, password: newUserPassword)

        // Нажимаем на кнопку Регистрация
        app.staticTexts["Вход"].tap()

        // Ожидаем октрытия экрана просмотра фильмов
        expectation(for: exists, evaluatedWith: app.navigationBars["Премьеры"], handler: nil)
        expectation(for: notExists, evaluatedWith: app.buttons["Добавить"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)


        // MARK: - Тест 8: Визуальный поиск фильма
        // Скролим вниз список фильмов
        app.tables.firstMatch.swipeUp()

        // Фильм Железный человек 3 должен быть в списке
        let visualSearchResult = app.cells.containing(.staticText, identifier: movieToClaimTicket).firstMatch
        expectation(for: exists, evaluatedWith: visualSearchResult, handler: nil)
        waitForExpectations(timeout: 2, handler: nil)


        // MARK: - Тест 9: Поиск фильма по названию
        // Скролим вверх для появления строки поиска
        app.tables.firstMatch.swipeDown()

        // Строка поиска должна быть видна
        expectation(for: exists, evaluatedWith: app.searchFields.firstMatch, handler: nil)
        waitForExpectations(timeout: 2, handler: nil)

        // Вводим текст для поиска
        app.searchFields.firstMatch.tap()
        app.searchFields.firstMatch.typeText(movieToClaimTicket)

        // Фильм Железный человек 3 должен быть в списке
        let filterSearchResult = app.cells.containing(.staticText, identifier: movieToClaimTicket).firstMatch
        expectation(for: exists, evaluatedWith: filterSearchResult, handler: nil)
        waitForExpectations(timeout: 2, handler: nil)

        // Фильм Железный человек 2 не должен быть в списке
        let ironMan2MovieCell = app.cells.containing(.staticText, identifier: ironMan2Movie).firstMatch
        expectation(for: notExists, evaluatedWith: ironMan2MovieCell, handler: nil)
        waitForExpectations(timeout: 2, handler: nil)


        // MARK: - Тест 11: Бронирование билета
        // Нажимаем на найденную ячейку
        filterSearchResult.tap()

        // Ожидаем переход на экран с информацией о фильме
        expectation(for: exists, evaluatedWith: app.navigationBars["Cinemagic.CustomerMovieInfoView"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // Бронируем билет
        app.staticTexts["Забронировать билет"].tap()

        // Ожидаем завершения бронирования
        expectation(for: exists, evaluatedWith: app.staticTexts["Отменить бронирование"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        print()
    }

    // MARK: - Private Methods

    private func loginFill(app: XCUIApplication, login: String, password: String) {
        // Заполняем поле логин адресом администратором
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText(login)

        // Заполняем пароль администратора
        let passwordField = app.secureTextFields.firstMatch
        passwordField.tap()
        expectation(for: hasFocus, evaluatedWith: passwordField, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        passwordField.typeText(password)
    }

}
