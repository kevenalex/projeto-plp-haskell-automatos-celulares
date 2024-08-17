module Models.Grid where
    import Data.Matrix
    import Models.Cell
    import Data.Maybe
    
    data Grid = Grid {
        height :: Int,
        width :: Int,
        grade :: Matrix Cell
    }


    gridGenerate :: Int -> Int -> Cell -> Grid
    gridGenerate height width a = Grid height width (matrix height width (\_ -> a))

    insertCell :: Grid -> Cell -> (Int, Int) -> Grid
    insertCell grid cell (x,y) = Grid (height grid) (width grid) (setElem cell (x,y) (grade grid))

    ---numOfLiveNeighbors :: Grid -> (Int, Int) -> Int
    ---numOfLiveNeighbors grid (x,y) = length [1 | uv <- validCoord (x,y) grid, (status (getCell uv (grade grid))) == Live]
    ---    where
    ---        cells = grade grid

    getCell :: (Int, Int) -> Matrix Cell -> Cell
    getCell (x,y) cells = getElem x y cells

    -- gridUpdate :: Grid -> Grid
    -- gridUpdate = 

    --- -----------------------------------------------------------------------------------------------------------------------

    --- UM MOI DE FUNCAO QUE CALCULA A POSICAO DOS VIZINHOS DE CADA CELULA

    validCoord :: (Int, Int) -> Grid -> [(Int, Int)]
    validCoord (x,y) grid = [fromJust x | x <- list, isJust x]
        where 
            list = listOfCoord (x,y) grid

    listOfCoord :: (Int,Int) -> Grid -> [Maybe  (Int, Int)]
    listOfCoord (u,v) grid = [coordOnTopLeft (u,v) grid, coordOnTop (u,v) grid, coordOnTop (u,v) grid, coordOnTopRight (u,v) grid,
                         coordInLeft (u,v) grid, coordInRight (u,v) grid,
                         coordInBelowLeft (u,v) grid, coordInBelow (u,v) grid, coordInBelowRight (u,v) grid]

    coordOnTop :: (Int, Int) -> Grid -> Maybe (Int, Int)
    coordOnTop (x,y) grid

        | u >= 1 && u <= height grid = Just (u,v)
        | otherwise = Nothing

        where 
            (u,v) = (x-1, y)

    coordInBelow :: (Int, Int) -> Grid -> Maybe (Int, Int)
    coordInBelow (x,y) grid

        | u >= 1 && u <= height grid = Just (u,v)
        | otherwise = Nothing

        where 
            (u,v) = (x+1, y)

    coordInRight :: (Int, Int) -> Grid -> Maybe (Int, Int)
    coordInRight (x,y) grid

        | v >= 1 && v <= width grid = Just (u,v)
        | otherwise = Nothing

        where 
            (u,v) = (x, y + 1)

    coordInLeft :: (Int, Int) -> Grid -> Maybe (Int, Int)
    coordInLeft (x,y) grid

        | v >= 1 && v <= width grid = Just (u,v)
        | otherwise = Nothing

        where 
            (u,v) = (x, y - 1)

    coordOnTopRight :: (Int, Int) -> Grid -> Maybe (Int, Int)
    coordOnTopRight (x,y) grid

        | u >= 1 && u <= height grid  && v >= 1 && v <= width grid = Just (u,v)
        | otherwise = Nothing

        where 
            (u,v) = (x - 1, y + 1)

    coordInBelowRight :: (Int, Int) -> Grid -> Maybe (Int, Int)
    coordInBelowRight (x,y) grid

        | u >= 1 && u <= height grid  && v >= 1 && v <= width grid = Just (u,v)
        | otherwise = Nothing

        where 
            (u,v) = (x + 1, y + 1)

    coordOnTopLeft :: (Int, Int) -> Grid -> Maybe (Int, Int)
    coordOnTopLeft (x,y) grid

        | u >= 1 && u <= height grid  && v >= 1 && v <= width grid = Just (u,v)
        | otherwise = Nothing

        where 
            (u,v) = (x - 1, y - 1)

    coordInBelowLeft :: (Int, Int) -> Grid -> Maybe (Int, Int)
    coordInBelowLeft (x,y) grid

        | u >= 1 && u <= height grid  && v >= 1 && v <= width grid = Just (u,v)
        | otherwise = Nothing

        where 
            (u,v) = (x + 1, y - 1)

    --- -----------------------------------------------------------------------------------------------------------------------