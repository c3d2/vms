{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Buy where

import Network.HTTP.Types (status303)
import Yesod.Auth (maybeAuthId)
import Import
import Token
import Network.Mail.Mime
import Data.Text as T
import Control.Monad (when)

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
    extras <- getExtra
    runDB $ do
        Just stock <- get stockId
        Just user <- get uid
        let price = stockPrice stock
        update uid [UserBalance -=. price]
        update stockId [StockAmount -=. 1]
        when (extraProduction extras) $ do
            let from = extraMailFrom extras
                path = extraMailPath extras
                options = fmap unpack $ extraMailOptions extras
            liftIO $ renderSendMailCustom path options (emptyMail $ Address Nothing from)
                { mailTo = [Address Nothing (userEmail user)]
                , mailHeaders =
                    [ ("Subject", mkSubject (stockIdent stock) price)
                    ]
                , mailParts = [[textPart]]
                }
            liftIO $ putStrLn "Mail sent"
    lift $ putStrLn $ "$€¥ user " ++ show uid ++ " bought " ++ show stockId

    redirectWith status303 BuyR
      where
      mkSubject s p = T.concat ["You just bought a ", s, " for ", pack $ show p, "€"]
      textPart = Part
            { partType = "text/plain; charset=utf-8"
            , partEncoding = None
            , partFilename = Nothing
            , partContent = ""
            , partHeaders = []
            }
