import System.Directory (getCurrentDirectory, getDirectoryContents)
import Data.List (isSuffixOf)
import Distribution.Verbosity (silent)
import System.Process (readProcess)
import System.Environment (getArgs)

import Distribution.PackageDescription.Parse (readPackageDescription)
import Distribution.PackageDescription (condLibrary, condExecutables, condTestSuites, condBenchmarks, condTreeConstraints)
import Distribution.Package (Dependency(..))
import Distribution.Text (display)

import Data.Maybe (maybeToList)
import Data.Char (toLower)
import Data.List (intercalate)

main :: IO ()
main = do
  args <- getArgs
  dir <- getCurrentDirectory
  files <- getDirectoryContents dir
  let cabalFiles = filter (".cabal" `isSuffixOf`) files
  catch (case cabalFiles of
    (c:_) -> putStrLn =<< cahoogle c args
    [] -> putStrLn =<< readProcess "hoogle" args "") $ \_ -> return ()

cahoogle :: FilePath -> [String] -> IO String
cahoogle cabalFile opts = do
  deps <- map depOpts `fmap` allDependencies cabalFile
  -- TODO: when a package is missing, hoogle breaks entirely
  readProcess "hoogle" (deps ++ opts) ""

allDependencies :: FilePath -> IO [Dependency]
allDependencies cabalFile = do
  v <- readPackageDescription silent cabalFile
  let f ct = condTreeConstraints =<< ct v
  return $ f (maybeToList . condLibrary) ++ f (map snd . condExecutables) ++ f (map snd . condTestSuites) ++ f (map snd . condBenchmarks)

depOpts :: Dependency -> String
depOpts = ("+"++) . map toLower . display . \v -> case v of (Dependency a _) -> a

-- -- Old dep-finding method, this might be the way to go for old-style
-- -- cabal files?
-- deps :: PackageDescription -> [Dependency]
-- deps pd = let base = buildDepends pd
--               exes = fmap buildInfo (executables pd) >>= targetBuildDepends
--               libs = maybe [] (targetBuildDepends . libBuildInfo) $ library pd
--            in base ++ exes ++ libs
