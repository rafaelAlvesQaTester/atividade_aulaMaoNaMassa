View().main()

class UserModel {
    var name: String = ""
    var favoriteGames: [GameModel] = []
}

class GameModel {
    var name: String
    
    init(_ name: String) {
        self.name = name
    }
}

enum Route {
    case home, options, gameList, addGames, gameSelect, deleteGameSelected, editGameSelected
}

class View {
    var viewModel: ViewModel = ViewModel()
    
    func main() {
        while true {
            switch viewModel.route {
                case .home:
                    homeView()
                case .options:
                    optionView()
                case .gameList:
                    gameListView()
                case .addGames:
                    addGameView()
                case .gameSelect:
                    gameSelectView()
                case .deleteGameSelected:
                    deleteGameView()
                case .editGameSelected:
                    editGameView()
            }
        }
    }
    
    func homeView() {
        print("Parta começar, informe seu nome: ")
        if !viewModel.setName() {
            print("Informe um nome válido: ")
        }
    }
    
    func optionView() {
        print("Seja bem vindo(a) \(viewModel.player.name)! O que você deseja fazer? ")
        print("A: Ver meus Clubes")
        print("B: Adicionar um novo Clube")
        
        if !viewModel.setOptions() {
            print("Informe um valor válido: ")
        }
    }
    
    func gameListView() {
        if viewModel.player.favoriteGames.isEmpty {
            print("Você ainda não adicionou um clube.")
        } else {
            print("Os clubes adicionados foram:")
            for (index, clube) in viewModel.player.favoriteGames.enumerated() {
                print("\(index + 1). \(clube.name)")
            }
        }
        
        if viewModel.isGameSelected() {
            viewModel.route = .gameSelect
        } else {
            viewModel.route = .options
        }
    }
    
    func addGameView() {
        print("Nome do clube:")
        
        if viewModel.setGame() {
            print("Clube adicionado com sucesso!!!")
        } else {
            print("Coloque um nome válido!")
        }
    }
    
    func gameSelectView() {
        print("Escolha um clube: ")
        
        if viewModel.selectGame() {
            if let clube = viewModel.gameSelect {
                print("O que você deseja fazer com \(clube.name)?")
                print("A - Editar ")
                print("B - Deletar ")
                print("C - Sair ")
                
                if !viewModel.selectOption() {
                    print("Faça uma seleção válida!")
                }
            }
        } else {
            print("Selecione uma opção válida")
        }
    }
    
    func editGameView() {
        guard let selectedGame = viewModel.gameSelect else { return }
        print("Digite o nome correto do time \(selectedGame.name):")
        
        if viewModel.editGameSelected() {
            print("Time editado com sucesso!")
        } else {
            print("Houve um erro ao atualizar o nome do time.")
        }
    }
    
    func deleteGameView() {
        print("Clube deletado com sucesso!")
        viewModel.deleteGameSelected()
    }
}

class ViewModel {
    var route: Route = .home
    var player: UserModel = UserModel()
    var gameSelect: GameModel? // Game model or nil
    var gameSelectedIndex: Int?
    
    func setName() -> Bool {
        guard let value = readLine(), !value.isEmpty else {
            return false
        }
        
        player.name = value
        route = .options
        return true
    }
    
    func setOptions() -> Bool {
        guard let value = readLine() else {
            return false
        }
        
        let option = value.uppercased()
        
        if option == "A" {
            route = .gameList
        } else if option == "B" {
            route = .addGames
        } else {
            return false
        }
        
        return true
    }
    
    func selectGame() -> Bool {
        let value = readLine()
        
        guard let select = value else { return false }
        guard let index = Int(select) else { return false }
        
        if index > 0 && index <= player.favoriteGames.count {
            gameSelectedIndex = index - 1
            gameSelect = player.favoriteGames[gameSelectedIndex!]
            return true
        }
        return false
    }
    
    func setGame() -> Bool {
        guard let value = readLine(), !value.isEmpty else {
            return false
        }
        
        player.favoriteGames.append(GameModel(value))
        route = .options
        return true
    }
    
    func isGameSelected() -> Bool {
        print("Você deseja selecionar um clube? (S/N)")
        guard let value = readLine() else {
            return false
        }
        
        return value.uppercased() == "S"
    }
    
    func selectOption() -> Bool {
        let value = readLine()
        
        guard let select = value else { return false }
        
        if select.uppercased() == "A" {
            route = .editGameSelected
            return true
        }
        if select.uppercased() == "B" {
            route = .deleteGameSelected
            return true
        }
        if select.uppercased() == "C" {
            route = .options
            return true
        }
        return false
    }
    
    func editGameSelected() -> Bool {
        guard let index = gameSelectedIndex else { return false }
        guard let newGame = readLine(), !newGame.isEmpty else { return false }
        
        player.favoriteGames[index].name = newGame
        route = .options
        return true
    }
    
    func deleteGameSelected() {
        guard let index = gameSelectedIndex else { return }
        player.favoriteGames.remove(at: index)
        route = .options
    }
}