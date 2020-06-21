//
//  PublicMovie+Default.swift
//  CinemagicTests
//
//  Created by Nik Burnt on 6/20/20.
//  Copyright © 2020 Nik Burnt Inc. All rights reserved.
//

@testable
import Cinemagic

import Foundation


// MARK: - PublicMovie+Default

extension PublicMovie {

    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)!
        return formatter
    }

    static var defaultMovies: [PublicMovie] { [
        PublicMovie(id: 8,
                    title: "Мстители",
                    description: """
Локи, сводный брат Тора, возвращается, и в этот раз он не один. Земля на грани порабощения, и только лучшие из лучших могут спасти человечество.

Ник Фьюри, глава международной организации Щ. И. Т., собирает выдающихся поборников справедливости и добра, чтобы отразить атаку. Под предводительством Капитана Америки Железный Человек, Тор, Невероятный Халк, Соколиный глаз и Чёрная Вдова вступают в войну с захватчиком.
""",
                    showtime: dateFormatter.date(from: "2020-06-18")!,
                    tickets: 30,
                    poster: "/posters/22ACC6F7-39B3-46C4-9C77-F939055EC5AE.image"),
        PublicMovie(id: 9,
                    title: "Мстители: Эра Альтрона",
                    description: """
Человечество на грани уничтожения. На этот раз людям угрожает Альтрон — искусственный интеллект, ранее созданный для того, чтобы защищать Землю от любых угроз. Однако, главной угрозой он посчитал человечество. Международная организация Щ. И. Т. распалась, и теперь мир не способен справиться с таким мощным врагом, потому люди вновь обращаются за помощью к Величайшим Героям Земли — Мстителям. Однако Альтрон слишком силен, и есть большая вероятность, что даже им не удастся остановить начало надвигающейся Эры Альтрона, где нет места для людей…
""",
                    showtime: dateFormatter.date(from: "2020-06-19")!,
                    tickets: 30,
                    poster: "/posters/FA83813C-7A20-4D4B-BD16-EAFE8ED674EF.image"),
        PublicMovie(id: 20,
                    title: "Мстители: Финал",
                    description: """
Оставшиеся в живых члены команды Мстителей и их союзники должны разработать новый план, который поможет противостоять разрушительным действиям могущественного титана Таноса. После наиболее масштабной и трагической битвы в истории они не могут допустить ошибку.
""",
                    showtime: dateFormatter.date(from: "2020-06-21")!,
                    tickets: 30,
                    poster: "/posters/859E0ABD-2AE4-4B0E-962E-726F7A4AC9B1.image"),
        PublicMovie(id: 21,
                    title: "Мстители: Война бесконечности",
                    description: """
Пока Мстители и их союзники продолжают защищать мир от различных опасностей, с которыми не смог бы справиться один супергерой, новая угроза возникает из космоса: Танос. Межгалактический тиран преследует цель собрать все шесть Камней Бесконечности — артефакты невероятной силы, с помощью которых можно менять реальность по своему желанию. Всё, с чем Мстители сталкивались ранее, вело к этому моменту — судьба Земли никогда ещё не была столь неопределённой.
""",
                    showtime: dateFormatter.date(from: "2020-06-20")!,
                    tickets: 30,
                    poster: "/posters/FFF2599A-B53A-494F-B53E-43B3B4346A31.image"),
        PublicMovie(id: 22,
                    title: "Железный человек",
                    description: """
Миллиардер-изобретатель Тони Старк попадает в плен к Афганским террористам, которые пытаются заставить его создать оружие массового поражения. В тайне от своих захватчиков Старк конструирует высокотехнологичную киберброню, которая помогает ему сбежать. Однако по возвращении в США он узнаёт, что в совете директоров его фирмы плетётся заговор, чреватый страшными последствиями. Используя своё последнее изобретение, Старк пытается решить проблемы своей компании радикально…
""",
                    showtime: dateFormatter.date(from: "2020-06-22")!,
                    tickets: 0,
                    poster: "/posters/08FBFA36-F323-4245-8C7C-AB3A4C4D0821.image"),
        PublicMovie(id: 23,
                    title: "Железный человек 2",
                    description: """
Прошло полгода с тех пор, как мир узнал, что миллиардер-изобретатель Тони Старк является обладателем уникальной кибер-брони Железного человека. Общественность требует, чтобы Старк передал технологию брони правительству США, но Тони не хочет разглашать её секреты, потому что боится, что она попадёт не в те руки. 

Между тем Иван Ванко — сын русского учёного, когда-то работавшего на фирму Старка, но потом уволенного и лишенного всего, намерен отомстить Тони за беды своей семьи. Для чего сооружает своё высокотехнологичное оружие.
""",
                    showtime: dateFormatter.date(from: "2020-06-23")!,
                    tickets: 30,
                    poster: "/posters/73B57F21-4C38-4DA6-B837-65ADD8D4EAE9.image"),
        PublicMovie(id: 24,
                    title: "Железный человек 3",
                    description: """
Когда мир Старка рушится на его глазах по вине неизвестных противников, Тони жаждет найти виновных и свести с ними счеты. Оказавшись в безвыходной ситуации, Старк может рассчитывать только на себя и свою изобретательность, чтобы защитить тех, кто ему дорог. Это становится настоящим испытанием для героя, которому придется не только сражаться с коварным врагом, но и разобраться в себе, чтобы найти ответ на вопрос, который давно его тревожит: что важнее — человек или костюм?
""",
                    showtime: dateFormatter.date(from: "2020-06-24")!,
                    tickets: 29,
                    poster: "/posters/964103CD-5B2D-4CF9-B451-02530F541BAC.image")
        ]}

    static var newMovie: PublicMovie { PublicMovie(title: "Test movie", description: "Test movie description", showtime: dateFormatter.date(from: "2020-07-24")!) }
    static var newMovieInvalidOne: PublicMovie { PublicMovie(title: "", description: "Test movie description", showtime: dateFormatter.date(from: "2020-07-24")!) }
    static var newMovieInvalidTwo: PublicMovie { PublicMovie(title: "Test movie", description: "T", showtime: dateFormatter.date(from: "2020-07-24")!) }


    static func newMovieUpdated(id: Int) -> PublicMovie {
        PublicMovie(id: id, title: "Test movie - 1!", description: "Test movie description", showtime: dateFormatter.date(from: "2020-07-24")!)
    }
    static func newMovieUpdatedInvalidOne(id: Int) -> PublicMovie {
        PublicMovie(id: id, title: "", description: "Test movie description", showtime: dateFormatter.date(from: "2020-07-24")!)
    }
    static func newMovieUpdatedInvalidTwo(id: Int) -> PublicMovie {
        PublicMovie(id: id, title: "Test movie - 1!", description: "T", showtime: dateFormatter.date(from: "2020-07-24")!)
    }

}
