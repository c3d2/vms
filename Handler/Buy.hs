{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Buy where

import Network.HTTP.Types (status303)
import Yesod.Auth (maybeAuthId)
import Import
import Token

getBuyR :: Handler Html
getBuyR = do
    stocks <- runDB $ selectList [] []
    tokenWidget <- getTokenWidget
    defaultLayout $ do
        setTitle "Buy Consume Then Die"
        $(widgetFile "buy")

postBuyItemR :: StockId -> Handler Html
postBuyItemR stockId = do
    validatePostToken
    Just uid <- maybeAuthId
    runDB $ do
        Just stock <- get stockId
        let price = stockPrice stock
        update uid [UserBalance -=. price]
        update stockId [StockAmount -=. 1]
    lift $ putStrLn $ "$€¥ user " ++ show uid ++ " bought " ++ show stockId
    redirectWith status303 BuyR
