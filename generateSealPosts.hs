{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
-- enter in repl:
--   :set -XOverloadedStrings

import           System.IO.Unsafe  ( unsafePerformIO )
import           System.Random     ( randomRIO )
import           System.Directory  ( listDirectory )
import           Control.Monad     ( forM, forM_, replicateM )
import           Data.Text         (Text)
import qualified Data.Text         as T
import qualified Data.Text.IO      as TIO
import           Data.List
import           Data.Time.Calendar
import           Data.Time.Clock
import           NeatInterpolation
-- https://hackage.haskell.org/package/neat-interpolation-0.3.2.1/docs/NeatInterpolation.html


{-
Gives a random number between from and to
Uses unsafeIO to get the number out of IO
It's safe because we're only shuffling
-}
randomNum from to =
  unsafePerformIO $
  randomRIO (from, to)

{-
Given a list, returns a random element
-}
randomPull lst = lst !! r'
  where r' = randomNum 0 l
        l  = length lst - 1

blogPost
  :: Text
  -> Text
  -> Text
  -> Text
  -> Text
  -> Day
  -> Text  
blogPost title see adj1 adj2 seal date =
  [text|
    ---
    title: $title
    ---

    $see this $adj1, $adj2 seal!
    <img
      src="/images/$seal"
      alt="A picture of a $adj1, $adj2 seal! <3"
      width="400"
    />
  |]

-- Returns a filePath, and a corresponding random blog post
sealText :: Integer -> Day -> (FilePath, Text)
sealText n date = ( fileName', blogPost')
  where 
    fileName' = 
         show date ++ "-" 
      ++ "seal-post-" 
      ++ show n 
      ++ ".markdown"
    date'     = T.pack . show $ date
    title     = T.pack $ "Seal Post Number " ++ show n
    title'    = T.replace " " "-" title
    blogPost' =
      blogPost
        title
        (randomPull looks)
        (randomPull adjectives)
        (randomPull adjectives')
        (randomPull sealImages)
        date


-- Generating all the previous blog posts
-- Only need to do this once
-- Another function takes care of creating today's blog post
startDate = fromGregorian 1998 06 11
-- startDate = fromGregorian 2020 07 31
{-# NOINLINE today #-}
today = unsafePerformIO $ utctDay <$> getCurrentTime
daysSinceStart = diffDays today startDate
allDatesSinceStart = map (`addDays` startDate) [1..daysSinceStart]



allBlogPosts = map f zipped
  where
    f = uncurry sealText
    zipped = zip [1..] allDatesSinceStart 

writeToFile (fp, txt) = write fp' txt
  where 
    write = TIO.writeFile
    fp'   = "posts/" ++ fp


-- For all the blog posts
-- Write them to file
unsafeGenerateAllBlogs = forM_ allBlogPosts writeToFile



prettyPrint :: Show a => [a] -> IO ()
prettyPrint = putStr . unlines . map show

{-
Adjectives
-}
adjectives :: [Text]
adjectives =
  [ "absorbing"
  , "adorable"
  , "alluring"
  , "ambrosial"
  , "amiable"
  , "appealing"
  , "attractive"
  , "beautiful"
  , "bewitching"
  , "captivating"
  , "charismatic"
  , "charming"
  , "choice"
  , "cute"
  , "dainty"
  , "darling"
  , "dear"
  , "delectable"
  , "delicate"
  , "delicious"
  , "delightful"
  , "desirable"
  , "dishy"
  , "dreamy"
  , "electrifying"
  , "elegant"
  , "enamoring"
  , "engaging"
  , "engrossing"
  , "enthralling"
  , "entrancing"
  , "eye-catching"
  , "fascinating"
  , "fetching"
  , "glamorous"
  , "graceful"
  , "heavenly"
  , "infatuating"
  , "inviting"
  , "irresistible"
  , "likable"
  , "lovable"
  , "lovely"
  , "magnetizing"
  , "nice"
  , "pleasant"
  , "precious"
  , "pretty"
  , "provocative"
  , "rapturous"
  , "ravishing"
  , "seducing"
  , "seductive"
  , "suave"
  , "sweet"
  , "tantalizing"
  , "tempting"
  , "titillating"
  , "winning"
  , "winsome"
  ]

adjectives' :: [Text]
adjectives' =
  [ "ample"
  , "bearish"
  , "big"
  , "butterball"
  , "buxom"
  , "chunky"
  , "fatty"
  , "flabby"
  , "fleshy"
  , "full-figured"
  , "hefty"
  , "husky"
  , "pleasingly plump"
  , "plump"
  , "plumpish"
  , "podgy"
  , "portly"
  , "pudgy"
  , "roly-poly"
  , "rotund"
  , "round"
  , "stout"
  , "tubby"
  , "zaftig"
  ]

looks :: [Text]
looks = 
  [ "Look at"
  , "Gaze upon"
  , "Check out"
  , "Witness!"
  , "Look upon and tremble at"
  , "Lookie here at"
  , "Whoa! See"
  ]

sealImages :: [Text]
sealImages = map T.pack
            . sort
            . unsafePerformIO
            $ listDirectory "images/seals"