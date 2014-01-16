{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Stock where

import Import

getStockR :: Handler Html
getStockR = do
  ps <- runDB $ selectList [] []
  defaultLayout $ do
    setTitle "TITLE HERE"
    $(widgetFile "stock")

getNewStockR :: Handler Html
getNewStockR = do
  ((_, widget), enctype) <- runFormGet $ productForm Nothing
  defaultLayout $ do
    setTitle "TITLE HERE"  
    $(widgetFile "new-product")

postNewStockR :: Handler Html
postNewStockR = do
  ((res, widget), enctype) <- runFormPost $ productForm Nothing
  case res of
    FormSuccess p -> do
      pId <- runDB $ insert p
      redirect $ StockR
    FormFailure errors -> defaultLayout $ do
      setTitle "ERROR"
      $(widgetFile "new-product")

getUpdateStockR :: StockId -> Handler Html
getUpdateStockR pId = do
  p <- runDB $ get pId
  ((_, widget), enctype) <- runFormGet $ productForm p
  defaultLayout $ do
    setTitle "TITLE HERE"
    $(widgetFile "update-product")

postUpdateStockR :: StockId -> Handler Html
postUpdateStockR pId = do
  ((res, widget), enctype) <- runFormPost $ productForm Nothing
  case res of
    FormSuccess p -> do
      pid <- runDB $ update pId
        [ StockIdent =. stockIdent p
        , StockPrice =. stockPrice p
        , StockAmount =. stockAmount p
        , StockUnit =. stockUnit p
        , StockPicture =. stockPicture p
        , StockDescription =. stockDescription p
        ]
      redirect $ StockR
    FormFailure errors -> defaultLayout $ do
      setTitle "ERROR"
      $(widgetFile "update-product")

productForm :: Maybe Stock -> Html -> MForm Handler (FormResult Stock, Widget)
productForm p = renderTable $ productAForm p

productAForm :: Maybe Stock -> AForm Handler Stock
productAForm p = Stock
    <$> areq textField "Ident" (stockIdent <$> p)
    <*> areq doubleField  "Price"  (stockPrice <$> p)
    <*> areq doubleField  "Amount"  (stockAmount <$> p)
    <*> areq textField  "Unit"  (stockUnit <$> p)
    <*> areq textField  "Picture"  (stockPicture <$> p)
    <*> areq textField  "Description"  (stockDescription <$> p)
