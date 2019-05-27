import UIKit
//: 5 Principios Solid implementados com swift
//:
//: 1. Principio de responsabilidade unica
//: - Este principio relata que cada classe tem que ter uma responsabilidade unica, tem que ser reponsavel por fazer apenas uma tarefa
protocol Acelerar {
    func acelerar()
}

protocol Frear {
    func frear()
}

class Carro: Acelerar, Frear {
    
    var acelerando = false
    
    func acelerar() {
        acelerando = true
    }
    
    func frear() {
        acelerando = false
    }
    
    var descrição: String {
        return acelerando ? "Carro está acelerando" : "Carro está freando"
    }
}

protocol Executor {
    func executor()
}

class Acelerador: Executor {
    
    private var acelerador: Acelerar
    
    init(_ carro: Acelerar) {
        self.acelerador = carro
    }
    
    func executor() {
        acelerador.acelerar()
    }
}

class Freio: Executor {
    
    private var frear: Frear
    
    init(_ carro: Frear) {
        self.frear = carro
    }
    
    func executor() {
        frear.frear()
    }
}

let carro = Carro()
carro.descrição

let acelerar = Acelerador(carro)
acelerar.executor()

carro.descrição

let freio = Freio(carro)
freio.executor()

carro.descrição
//: 2. Principio Aberto / Fechado
//: - Uma classe pode ser facilmente estendida, mas proíbe qualquer modificação em si mesma.
//: - Este princípio desenha altamente suas características do padrão Decorator & Strategy
//: - O Decorator permite a extensão do comportamento dinamicamente ou estaticamente durante o tempo de execução
//: - Estratégia permite a implementação de diferentes algoritmos intercambiáveis ​​dentro da mesma família.
//: - É muito eficaz ao rastrear bugs, porque nos permite restringir o erro diretamente à função que o está causando
protocol Developer {
    var language: String {get}
    func traits() -> String
}

struct WebProgrammer { }
struct RubyArchitect { }
class IOSEngineer { }

extension IOSEngineer: Developer {
    var language: String { return "Objective-C" }
}
extension WebProgrammer: Developer {
    var language: String { return "HTML" }
}
extension RubyArchitect: Developer {
    var language: String { return "Ruby" }
}

extension Developer {
    ///Let's assume all the developers have an iOS knowlege
    var iosTraits: String {
        return "The iOS developer use both \(self.language) and now Swift"
    }
}
extension Developer where Self: IOSEngineer {
    func traits() -> String { return iosTraits }
}

extension Developer where Self == WebProgrammer {
    func traits() -> String {
        return "We are cool and we do both \(self.language) and CSS also."
    }
}
///This one is cool :) because it has access to Developer
extension Developer where Self == RubyArchitect {
    func traits() -> String {
        return "Ruby is powerful and we code in \(self.language) and \(self.iosTraits)"
    }
}

class Team {
    let developers: [Developer]
    
    init(developers: [Developer]) {
        self.developers = developers
    }
}

extension Team: Developer {
    var language: String {
        return self.developers.reduce("") { _language, developer -> String in
            return _language+" "+developer.language
        }
    }
    
    func traits() -> String {
        return self.developers.reduce("") { _trait, developer -> String in
            return _trait+"\n"+developer.traits()
        }
    }
}

let dev1 = IOSEngineer()
let dev2 = RubyArchitect()
let dev3 = WebProgrammer()

dev1.language
dev2.language
dev3.language

dev1.traits()
dev2.traits()
dev3.traits()

let team = Team(developers: [dev1, dev2, dev3])

team.language

team.traits()
//: 3. Princípio da substituição de Liskov
//: - Toda classe derivada deve ser substituível por sua classe base original
//: - Isto significa na prática é que uma subclasse deve ser sempre intercambiável para sua superclasse
//: - O principal objetivo deste princípio é garantir a interoperabilidade semântica dentro da hierarquia de tipos
class Vehicle {
    let name: String
    let speed: Double
    let wheels: Int
    
    init(name: String, speed: Double, wheels: Int) {
        self.name = name
        self.speed = speed
        self.wheels = wheels
    }
    
    func canfly() -> Bool {
        return false
    }
}

class Airplane: Vehicle {
    override func canfly() -> Bool {
        return true
    }
}

class Car: Vehicle { }

class Handler {
    static func speedDescription(for vehicle: Vehicle) -> String {
        ///Vehicle could be an Airplane or Car
        ///This is substitutability or interchaneable
        if vehicle.canfly() {
            return "It flys at \(vehicle.speed) knot "
        } else {
            return "Runs at \(vehicle.speed) kph"
        }
    }
}

let car = Car(name: "BMW", speed: 180.00, wheels: 4)
let plane = Airplane(name: "KLM", speed: 34.00, wheels: 3)
///Based on Liskov Handler should always be able to
///Process speedDescription when given any type of Vehicle
let carSpeedDescription = Handler.speedDescription(for: car)
let planeSpeedDescription = Handler.speedDescription(for: plane)

//: 4. Segregação de interface
//: - O Princípio de Segregação de Interface trata da separação de interesses
//: - Afirma que um cliente não deve ser forçado a implementar ou depender de métodos que não usa
//: - É melhor ter muitas interfaces específicas do que ter uma interface de propósito geral monolítica
//: - Todo o propósito da Segregação de Interface é reduzir o inchaço da interface ou o que é conhecido como poluição de interface e favorecer a legibilidade do código

enum Continent {
    case africa, europe, asia, america
}

enum Union {
    case EU, AU, CAU, NAU, UNASUR
}

enum Language {
    case mandarin, english, deutsche, italian, latin, spanish, french, portuguese, welsh, scots, irish, cornish
}

enum Ethnic {
    case caucasian(percentage: Float)
    case black(percentage: Float)
    case asian(percentage: Float)
    case mixed(percentage: Float)
    case others(percentage: Float)
    case none
}

enum State {
    case italy(continent: Continent)
    case germany(continent: Continent)
    case southAfrica(continent: Continent)
    case nigeria(continent: Continent)
    case china(continent: Continent)
    case brazil(continent: Continent)
    case USA(continent: Continent)
    case scotland(continent: Continent)
    case england(continent: Continent)
    case wales(continent: Continent)
    case northernIreland(continent: Continent)
}

/// Interface 1 = Country
protocol Country {
    var name: String {get}
    var states: [State] {get}
    var population: Double {get}
}
/// Interface 2 = Community
protocol Community {
    var member: Union {get}
}
/// Interface 3 = Lingua
protocol Lingua {
    var officialLanguage: Language {get}
    var otherLanguages: [Language] {get}
}
/// Inetrface 4 = Ethnicity
protocol Ethnicity {
    var ethnicGroups: [Ethnic] {get}
}

/// `State` conforms to `Lingua`
extension State: Lingua {
    var officialLanguage: Language {
        switch self {
        case .brazil:
            return .portuguese
        case .china:
            return .mandarin
        case .germany:
            return .deutsche
        case .italy:
            return .italian
        case .nigeria, .scotland, .wales, .england, .northernIreland, .USA, .southAfrica:
            return .english
        }
    }
    
    var otherLanguages: [Language] {
        switch self {
        case .northernIreland:
            return [.irish]
        case .wales:
            return [.welsh]
        case .scotland:
            return [.scots]
        case .italy:
            return [.latin]
        case .england:
            return [.cornish]
        default:
            return []
        }
    }
}

///`Country` conforming to `Ethnicity`
extension Ethnicity where Self: Country {
    //Please note that this is just an exmaple
    //do not hold me responsible for incorrect data
    //use it and see it as example please!!!!!!!!
    var ethnicGroups: [Ethnic] {
        return self.states.reduce([]) { groups, state -> [Ethnic] in
            var _ethnicGroups = groups
            switch state {
            case .scotland, .wales, .england, .northernIreland:
                let caucasian = Ethnic.caucasian(percentage: 81.9)
                let black = Ethnic.black(percentage: 13)
                let asian = Ethnic.asian(percentage: 8.0)
                let others = Ethnic.others(percentage: 3.0)
                let _groups = [caucasian, black, asian, others]
                _ethnicGroups.append(contentsOf: _groups)
            default:
                return [.none]
            }
            return _ethnicGroups
        }
    }
}

protocol SovereignType: Country, Lingua, Ethnicity, Community {
    init(name: String, states: [State], population: Double, officialLanguage: Language, member: Union)
}

struct Nation: SovereignType {
    let name: String
    let states: [State]
    let population: Double
    let officialLanguage: Language
    let member: Union
    
    var otherLanguages: [Language] {
        return states.reduce([]) { languages, state -> [Language] in
            return languages + state.otherLanguages
        }
    }
}


let england = State.england(continent: .europe)
let scotland = State.scotland(continent: .europe)
let wales = State.wales(continent: .europe)
let northIreland = State.northernIreland(continent: .europe)

let UK = Nation(name: "United Kingdom",
                states: [england, scotland, wales, northIreland],
                population: 65000000,
                officialLanguage: .english,
                member: .EU)

UK.name
UK.officialLanguage
UK.otherLanguages
UK.ethnicGroups
UK.member
UK.population
//: 5. Princípio de Inversão de Dependência
//: - O Princípio de Inversão de Dependência afirma que, módulos de nível superior não devem depender dos módulos de nível inferior, eles devem depender de abstrações
//: - Em outras palavras, todas as entidades devem ser baseadas em interfaces abstratas e não em tipos concretos
//: - O princípio também enfatizava que as abstrações não deveriam depender de detalhes. Detalhes devem depender de abstrações.
//: - Um módulo de alto nível é qualquer módulo que contenha as decisões de política e o modelo de negócios de um aplicativo. Isso pode ser considerado como a identidade do aplicativo. Os módulos de nível mais alto são consumidos principalmente pela camada de apresentação em um aplicativo.
//: - Módulos de baixo nível são módulos que contêm implementação detalhada necessária para executar as decisões e políticas de negócios.
//: - O Princípio de Inversão de Dependência é algumas vezes confundido com Injeção de Dependência
//: - Injeção de dependência é o processo de dar a um objeto suas propriedades ou variáveis ​​de instância
//: - No entanto, é difícil falar sobre o Princípio de Inversão de Dependência sem mencionar a Injeção de Dependência
//: - Isso porque você precisa do mecanismo de Injeção de Dependência para realizar uma Inversão de Dependência.

/// A list of Keys used to persist data
enum DefaultsKey: String {
    case game = "Game"
}
/// A type providing DAO services for `UserDefaults` persistence.
protocol DefaultsServiceType {
    /// Read & decode a value for a given key from standard `UserDefaults`.
    ///
    /// - Parameter forKey: Defaults key to be read.
    /// - Returns: Decoded value if possible. `nil` if not present in standard defaults or if decoding threw an error.
    func read<T: Decodable>(forKey: DefaultsKey) -> T?
    /// Encode & write a value to a give key in standard `UserDefaults`.
    ///
    /// If encoding the given value failed, existing value -if any- will be erased.
    ///
    /// - Parameters:
    ///   - value: Value to encode and write to defaults.
    ///   - forKey: Defaults key to write to
    func write<T: Encodable>(_ value: T, forKey: DefaultsKey)
    /// Erase a value for a given key -if present- from standard `UserDefaults`.
    ///
    /// - Parameter key: Defaults key to erase.
    func erase(_ key: DefaultsKey)
}

extension UserDefaults: DefaultsServiceType {
    private var defaults: UserDefaults {
        return UserDefaults.standard
    }
    // MARK: Codable
    private var encoder: PropertyListEncoder {
        return PropertyListEncoder()
    }
    // MARK: Decodable
    private var decoder: PropertyListDecoder {
        return PropertyListDecoder()
    }
    
    // MARK: Conforming to DefaultsServiceType
    func read<T: Decodable>(forKey key: DefaultsKey) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
    
    func write<T: Encodable>(_ value: T, forKey key: DefaultsKey) {
        let data = try? encoder.encode(value)
        defaults.set(data, forKey: key.rawValue)
    }
    
    func erase(_ key: DefaultsKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
}


struct Game {
    struct Player: Codable {
        let name: String
        let level: Int
        let points: Int
        let description: String?
    }
    
    var players: [Player]
    
    init(players: [Player] = []) {
        self.players = players
    }
}

extension Game: Codable {
    enum PlayerKeys:String, CodingKey {
        case name
        case level
        case points
        case description
    }
    
    enum CodingKeys: String, CodingKey {
        case players
    }
    
    /// Encodes this value into the given encoder.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for player in players {
            var playerContainer = container.nestedContainer(keyedBy: PlayerKeys.self, forKey: CodingKeys.players)
            try playerContainer.encode(player.name, forKey: .name)
            try playerContainer.encode(player.level, forKey: .level)
            try playerContainer.encode(player.points, forKey: .points)
            try playerContainer.encode(player.description, forKey: .description)
        }
    }
    
    /// Creates a new instance by decoding from the given decoder
    init(from decoder: Decoder) throws {
        var players = [Player]()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        for key in container.allKeys {
            let playerContainer = try container.nestedContainer(keyedBy: PlayerKeys.self, forKey: key)
            let name = try playerContainer.decode(String.self, forKey: .name)
            let level = try playerContainer.decode(Int.self, forKey: .level)
            let points = try playerContainer.decode(Int.self, forKey: .points)
            let desc = try playerContainer.decodeIfPresent(String.self, forKey: .description)
            let player = Player(name: name, level: level, points: points, description: desc)
            players.append(player)
        }
        self.init(players: players)
    }
}

class PersistenceStoreNotValid {
    private let store: UserDefaults //Anti-pattern
    init(store: UserDefaults /*Anti-pattern*/) {
        self.store = store
    }
    
    func save(currentGame game: Game) {
        self.store.write(game, forKey: .game)
    }
    
    func currentGame() -> Game? {
        guard let game: Game = self.store.read(forKey: .game) else { return nil }
        return game
    }
}


class PersistenceStore {
    private let store: DefaultsServiceType //Dependency Inversion Principle
    init(store: DefaultsServiceType/*Dependency Inversion Principle*/) {
        self.store = store
    }
    
    func save(currentGame game: Game) {
        self.store.write(game, forKey: .game)
    }
    
    func currentGame() -> Game? {
        guard let game: Game = self.store.read(forKey: .game) else { return nil }
        return game
    }
}

///Create an instance of PersistenceStore
///And inject DefaultServiceType
let persistenceStore = PersistenceStore(store: UserDefaults.standard)
///Create an instance of players
let player = Game.Player(name: "Smart Kid",
                         level: 100,
                         points: 99,
                         description: "Smarted boy in the class")

persistenceStore.save(currentGame: Game(players: [player]))

let game = persistenceStore.currentGame()!

for player in game.players {
    print(player.name)
}
