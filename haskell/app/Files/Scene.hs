{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}

module Files.Scene (readScenes, addScene, deleteScene, Scene(Scene), title, sceneToGrid) where
    import Data.Aeson
    import GHC.Generics

    import qualified Data.Map as M
    import qualified Data.ByteString.Lazy as B

    import System.Directory

    import Data.Matrix

    import Models.Cell
    import Models.Rule
    import Models.Grid
    

    data Scene =
        Scene {
            title :: String, -- identificador único
            rows :: Int,
            cols :: Int,
            flatMatrix :: [Maybe Cell] -- resultado Matrix toList
        } deriving (Generic, ToJSON, FromJSON)

    instance Show Scene where
        show (Scene title rows cols _) = title ++ " (" ++ show rows ++ "x" ++ show cols ++ ")"
    
    -- path = "./app/storage/scenes.json"
    -- Diferente de células, cenas são guardas em um dicionario
    -- onde o nome dele é a chave e o valor é cena

    -- pra pegar o dicionário de cenas você ainda tem que tornar isso puro,
    -- "addScene" da um exemplo de como fazer isso
    -- tem que tirar o IO com um do, decodar o JSON e tratar o Just e Nothing. 
    readScenes :: FilePath -> IO B.ByteString
    readScenes path = do
        exists <- doesFileExist path
        if exists
            then
                B.readFile path
            else do
                B.writeFile path B.empty 
                B.readFile path

    -- substitui o arquivo inteiro de cenas
    saveScenes :: FilePath -> M.Map String Scene -> IO ()
    saveScenes path sceneDict = B.writeFile path (encode sceneDict)

    -- adiciona uma cena ao dicionario de cenas. Não sobrepõe
    addScene :: FilePath -> Scene -> IO()
    addScene path scene = do
        sceneJSON <- readScenes path
        case decode sceneJSON :: Maybe (M.Map String Scene) of
            Nothing -> saveScenes path $ M.singleton (title scene) scene
            Just sceneDict -> saveScenes path $ M.insert (title scene) scene sceneDict

    -- recebe o caminho do arquivo onde as cenas são guardadas, e o título da cena a ser removida
    deleteScene :: FilePath -> String -> IO()
    deleteScene path title = do
        sceneJSON <- readScenes path
        case decode sceneJSON :: Maybe (M.Map String Scene) of
            Nothing -> error "No scenes exist to delete"
            Just sceneDict -> saveScenes path $ M.delete title sceneDict

    -- Pega a matriz que essa cena guarda, necessário porque não tem implementação default pra encodar uma matrix em JSON
    sceneToGrid :: Scene -> Matrix (Maybe Cell)
    sceneToGrid (Scene t r c matrix) = fromList r c matrix