module Exercise8
    ( exercise
    ) where

import Data.List (find)
import Data.Maybe (fromMaybe, listToMaybe)
import Text.XML.Light

import Common

exercise :: String -> String
exercise = unlines . map (showContent . fixNamespace . addParents) . parseXML

-- | Add the required parent elements.
addParents :: Content -> Content
addParents (Elem e) = Elem e {elContent = merge . map addParent $ elContent e}
addParents c = c

-- | Add a new parent element to an Element that has a content/subject child
-- element. Set the new parent element's name attribute to the value of the
-- content/subject child element and remove the content/subject child element.
-- Return all other content (including Elements without the required child
-- element) unchanged.
addParent :: Content -> Content
addParent (Elem e) =
    maybe
        (Elem e)
        (\s ->
             Elem
                 blank_element
                 { elName = gtr "node"
                 , elAttribs = [Attr {attrKey = unqual "name", attrVal = s}]
                 , elContent = [Elem (remove [gtr "content", dc "subject"] e)]
                 })
        (subject e)
addParent c = c

-- | Combine all top level Elements with the same name attribute value into one,
-- concatenating their respective content. Return all other content unchanged.
merge :: [Content] -> [Content]
merge = foldr f []
  where
    f (Elem e) cs =
        maybe
            (Elem e : cs)
            (\(Elem e') ->
                 replace
                     (Elem e')
                     (Elem e' {elContent = elContent e ++ elContent e'})
                     cs)
            (find (sameName e) cs)
    f c cs = c : cs

-- | Check if two elements have the same name attribute values. The second
-- element is wrapped in a Content type.
sameName :: Element -> Content -> Bool
-- Using @name e1 == name e2@ would be simpler but this would return True if
-- none of the two elements has a name attribute!
sameName e1 (Elem e2) = fromMaybe False $ (==) <$> name e1 <*> name e2
sameName _ _ = False

-- | Replace the first occurrence of x by y in xs. If x is not found, append y
-- to xs.
replace :: Eq a => a -> a -> [a] -> [a]
replace x y xs = xs1 ++ (y : drop 1 xs2)
  where
    (xs1, xs2) = span (/= x) xs

-- | Find the text content of an Element's content/subject child element.
subject :: Element -> Maybe String
subject = listToMaybe . map strContent . findPath [gtr "content", dc "subject"]

-- | Find the value of an Element's name attribute.
name :: Element -> Maybe String
name = findAttr (unqual "name")

-- | Remove descendant Elements whose path is specified by a list of QNames.
-- Like a simple XPath expression. Note that @remove [] e = e@.
remove :: [QName] -> Element -> Element
remove [] e = e
remove [n] e =
    e
    { elContent =
          filter
              (\c ->
                   case c of
                       Elem e -> elName e /= n
                       otherwise -> True)
              (elContent e)
    }
remove (n:ns) e =
    e
    { elContent =
          map
              (\c ->
                   case c of
                       Elem e
                           | elName e == n -> Elem $ remove ns e
                           | otherwise -> Elem e
                       otherwise -> c)
              (elContent e)
    }

-- | The Text.XML.Light module defines no Eq instance for Content, but the
-- replace function has an Eq type constraint.
instance Eq Content where
    (Elem e1) == (Elem e2) = e1 == e2
    (Text t1) == (Text t2) = t1 == t2
    (CRef r1) == (CRef r2) = r1 == r2
    _ == _ = False

instance Eq Element where
    e1 == e2 =
        and
            [ elName e1 == elName e2
            , elAttribs e1 == elAttribs e2
            , elContent e1 == elContent e2
            , elLine e1 == elLine e2
            ]

instance Eq CData where
    d1 == d2 =
        and
            [ cdVerbatim d1 == cdVerbatim d2
            , cdData d1 == cdData d2
            , cdLine d1 == cdLine d2
            ]
