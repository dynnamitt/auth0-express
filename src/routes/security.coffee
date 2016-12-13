router = (require 'express').Router()

module.exports= (passport,conf,callbackPath) ->

  router.get '/login',  (req, res) ->
    res.send "<html><title>login-page</title><head>
      <script src=\"https://cdn.auth0.com/js/lock/10.6/lock.min.js\">//
      </script>
    </head><body>
      <script>
      (new Auth0Lock('#{conf.clientID}', '#{conf.domain}', {
        auth: { redirectUrl: '#{conf.callbackURL}'
          , responseType: 'code'
          , params: {
            scope: 'openid name email picture'
        }}})).show();
      </script>
      </body><html>"

  router.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'
  
  router.get callbackPath,
    (passport.authenticate 'auth0',
      { failureRedirect: '/url-if-something-fails' }) ,
      (req, res) ->
        res.redirect req.session.returnTo || '/?no-returnTo-data&'
