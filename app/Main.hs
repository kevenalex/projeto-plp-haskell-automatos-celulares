module Main where

import Controllers.CellController (menuCells)
import Data.Char
import System.Console.ANSI
import System.Exit (exitSuccess)
import Utils.Render

main :: IO ()
main = do
    clearScreen

    Just (_, screenHeight) <- getTerminalSize

    setCursorPosition (screenHeight - 1) 0

    selectOption True -- Laço principal

selectOption :: Bool -> IO ()
selectOption delay = do
    clearScreen
    printLogoLessDelay

    opcao <- getLine
    case toUpper $ head opcao of
        -- '1' -> do menuAutomatasSandBox "app/storage/cells.json"; selectOption False;
        -- '2' -> do menuAutomatasCarregarCena "app/storage/cells.json"; selectOption False;
        '3' -> do menuCells "app/storage/cells.json"; selectOption False
        -- '4' -> do menuTutorial; selectOption False;
        '5' -> do
            setCursorPosition 0 0
            printTextWithDelayNoClear "app/storage/mainMenuController/emptyMenu.txt"
            exitSuccess
        _ -> do
            clearScreen
            printMainMenuInvalidOption
            selectOption False
