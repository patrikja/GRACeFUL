import WFF
import SATSolver
import Tests

data Count = LessThan Int | None | Some Int | All | Any deriving (Eq, Show)

instance Num Count where
    fromInteger = Some . fromInteger

ofThese :: Count -> [WFF] -> WFF
ofThese (LessThan i) xs = foldl1 (.||) $ map (\k -> (Some k) `ofThese` xs) [0..(i-1)]
ofThese Any  xs        = foldl1 (.||) xs
ofThese None xs        = foldl1 (.&&) $ map n xs
ofThese All  xs        = foldl1 (.&&) xs
ofThese (Some 0) xs    = None `ofThese` xs
ofThese (Some i) xs    = oneOfThese $ map (All `ofThese`) (sublists xs i)

sublists  _     0 = [[]]
sublists  []    _ = []
sublists (y:ys) n = sublists ys n ++ map (y:) (sublists ys $ n - 1)

oneOfThese [x] = x
oneOfThese (x:xs) = ((n x) .&& (oneOfThese xs)) .|| (x .&& (None `ofThese` xs))
