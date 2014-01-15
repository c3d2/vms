{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Signup where

import Import

getSignupR :: Handler Html
getSignupR = do
    (signupFormWidget, signupFormEnctype) <- generateFormPost signupForm
    defaultLayout $ do
        setTitle "Signup"
        $(widgetFile "signup")

postSignupR :: Handler Html
postSignupR = do
    ((result, _signupFormWidget), _signupFormEnctype) <- runFormPost signupForm
    case result of
      FormSuccess u -> do
        mKey <- runDB $ insertUnique u
        case mKey of
          Just _ -> do
            login $ userIdent u
            redirect BuyR
          Nothing ->
            error "FIXME: duplicate username"
      _ ->
        getSignupR

signupForm :: Form User
signupForm = renderDivs $ User <$>
             areq textField "User id" Nothing <*>
             areq textField "E-Mail" Nothing <*>
             pure 0
             
