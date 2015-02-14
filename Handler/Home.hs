{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home where

import Control.Monad (when)
import Yesod (redirect)
import Yesod.Auth (maybeAuthId)

import Import

-- This is a handler function for the GET request method on the HomeR
-- resource pattern. All of your resource patterns are defined in
-- config/routes
--
-- The majority of the code you will write in Yesod lives in these handler
-- functions. You can spread them across multiple files if you are so
-- inclined, or create a single monolithic file.
getHomeR :: Handler Html
getHomeR = do
    users <- runDB $ selectList [] []
    let usersLength = length (users :: [Entity User])
    defaultLayout $ do
        $(widgetFile "homepage")


-- TODO: error msg?
postHomeR :: Handler Html
postHomeR = 
    lookupPostParam "uid" >>=
    maybe (redirect HomeR)
    (\uid -> do
        login uid
        redirect BuyR
    )
    
