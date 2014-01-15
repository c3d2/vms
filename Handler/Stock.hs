{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Stock where

import Import

getStockR :: Handler Html
getStockR = do
  ps <- runDB $ selectList [] []
  defaultLayout $ do
    setTitle "TITLE HERE"
    [whamlet|
$if null ps
  <p>NOTHING INSERT
$else
  <ul>
    $forall Entity pId p <- ps
      <li>
        <a href=@{UpdateStockR pId}>#{stockIdent p}
  <form action=@{NewStockR}>
    <button>New
    |]

getNewStockR :: Handler Html
getNewStockR = do
  ((_, widget), enctype) <- runFormGet $ productForm Nothing
  defaultLayout $ do
    setTitle "TITLE HERE"  
    [whamlet|
    <form method=post action=@{NewStockR} enctype=#{enctype}>
      ^{widget}
      <button>Submit
    |]

postNewStockR :: Handler Html
postNewStockR = do
    ((res, widget), enctype) <- runFormPost $ productForm Nothing
    case res of
        FormSuccess p -> do
            pId <- runDB $ insert p
            redirect $ StockR
        FormFailure i -> defaultLayout $ do
            setTitle "ERROR"
            [whamlet|
$forall f <- i
  #{f}
<form method=post enctype=#{enctype}>
    ^{widget}
      <button>Submit
            |]

getUpdateStockR :: StockId -> Handler Html
getUpdateStockR pId = do
  p <- runDB $ get pId
  ((_, widget), enctype) <- runFormGet $ productForm p
  defaultLayout $ do
    setTitle "TITLE HERE"  
    [whamlet|
    <form method=post action=@{UpdateStockR pId} enctype=#{enctype}>
      ^{widget}
      <button>Submit
    |]

postUpdateStockR :: StockId -> Handler Html
postUpdateStockR = undefined

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
