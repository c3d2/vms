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
        <a href=@{ProductR pId}>#{stockIdent p}
    |]

postStockR :: Handler Html
postStockR = undefined

getProductR :: StockId -> Handler Html
getProductR pId = do
  p <- runDB $ get404 pId
  defaultLayout $ do
    setTitle "TITLE HERE"  
    [whamlet|
    #{stockIdent p} #{stockPrice p} #{stockAmount p} #{stockUnit p} #{stockPicture p} #{stockDescription p}
    |]

postProductR :: StockId -> Handler Html
postProductR pId = undefined
