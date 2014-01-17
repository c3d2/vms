{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}

-- | Ripped out of Yesod.Form.Functions
module Token ( getToken
             , getTokenWidget
             , validatePostToken
             ) where

import Prelude
import Data.Monoid
import Control.Monad
import Yesod
import Data.Text (Text)
import Network.HTTP.Types (status403)


tokenKey :: Text
tokenKey = "_token"

getToken :: MonadHandler m => m (Maybe Text)
getToken = do
    reqToken `fmap` getRequest

getTokenWidget :: MonadHandler m => m Html
getTokenWidget =
    maybe mempty
              (\n ->
                   [shamlet|<input type=hidden name=#{tokenKey} value=#{n}>|]
              ) `fmap`
    getToken

validatePostToken :: MonadHandler m => m ()
validatePostToken = do
    sessionToken <- getToken
    paramToken <- lookupPostParam tokenKey
    when (sessionToken /= paramToken) $
         sendResponseStatus status403 $
         RepPlain "CSRF token mismatch"
    
