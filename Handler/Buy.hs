{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Buy where

import Import

getBuyR :: Handler Html
getBuyR = do
    stocks <- runDB $ selectList [] []
    defaultLayout $ do
        $(widgetFile "buy")
