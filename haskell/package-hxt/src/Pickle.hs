module Pickle where

-- TODO Does not work. Some problem with namespaces.

import Text.XML.HXT.Core hiding (Tree, xpTree)

main :: IO ()
main = do
    runX
        (xunpickleDocument xpTree [] "../../xml/example.xml" >>>
         processTree >>> xpickleDocument xpTree [] "-")
    return ()

processTree :: IOSArrow Tree Tree
processTree =
    arrIO
        (\x -> do
             print x
             return x)

data Tree = Tree
    { tName :: Maybe String
    , tContent :: Maybe Content
    , tNodes :: [Node]
    } deriving (Show)

instance XmlPickler Tree where
    xpickle = xpTree

xpTree :: PU Tree
xpTree =
    xpAddNSDecl nsGtr prefixGtr $
    xpAddNSDecl nsDc prefixDc $
    xpElemGtr "tree" $
    xpWrap (\(n, c, ns) -> Tree n c ns, \n -> (tName n, tContent n, tNodes n)) $
    xpTriple
        (xpOption (xpAttr "name" xpText))
        (xpOption xpContent)
        (xpList xpNode)

data Node = Node
    { name :: Maybe String
    , content :: Maybe Content
    , nodes :: [Node]
    } deriving (Show)

instance XmlPickler Node where
    xpickle = xpNode

xpNode :: PU Node
xpNode =
    xpElemGtr "node" $
    xpWrap (\(n, c, ns) -> Node n c ns, \n -> (name n, content n, nodes n)) $
    xpTriple
        (xpOption (xpAttr "name" xpText))
        (xpOption xpContent)
        (xpList xpNode)

data Content = Content
    { title :: Maybe String
    , creator :: Maybe String
    , date :: Maybe String
    } deriving (Show)

instance XmlPickler Content where
    xpickle = xpContent

xpContent :: PU Content
xpContent =
    xpElemGtr "content" $
    xpWrap (\(t, c, d) -> Content t c d, \c -> (title c, creator c, date c)) $
    xpTriple
        (xpOption (xpElemDc "title" xpText))
        (xpOption (xpElemDc "creator" xpText))
        (xpOption (xpElemDc "date" xpText))

nsGtr :: String
nsGtr = "http://martin.hoppenheit.info/code/generic-tree-xml"

prefixGtr :: String
prefixGtr = "gtr"

xpElemGtr :: String -> PU a -> PU a
xpElemGtr = xpElemNS nsGtr prefixGtr

nsDc :: String
nsDc = "http://purl.org/dc/elements/1.1/"

prefixDc :: String
prefixDc = "dc"

xpElemDc :: String -> PU a -> PU a
xpElemDc = xpElemNS nsDc prefixDc
