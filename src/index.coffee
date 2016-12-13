express = require 'express'
session = require 'express-session' # RAM ! Cluster ISSUE
passport = require 'passport'
assert = require 'assert'
# favicon = require 'serve-favicon'
ensureLoggedIn = (require 'connect-ensure-login').ensureLoggedIn()
Auth0Strategy = require 'passport-auth0'

PORT = process.env.PORT or 6660
PORT_T = PORT + 1

callbackPath = '/callback'
auth0Conf =
  domain: process.env.AUTH0_DOMAIN
  clientID: process.env.AUTH0_CLIENT_ID
  clientSecret: process.env.AUTH0_CLIENT_SECRET
  callbackURL: "http://localhost:#{PORT}#{callbackPath}"
  # howto switch above in clustering mode??
  
assert auth0Conf.domain, "AUTH0_DOMAIN is undef"
assert auth0Conf.clientID, "AUTH0_CLIENT_ID is undef"
assert auth0Conf.clientSecret, "AUTH0_CLIENT_SECRET is undef"

strategy = new Auth0Strategy auth0Conf,
    (accessToken, refreshToken, extraParams, profile, done) ->
      # accessToken is the token to call Auth0 API (not needed for the most)
      # extraParams.id_token has the JSON Web Token
      # profile has all the information from the user
      done null, profile

passport.use strategy
passport.serializeUser (user,done) ->
  # trim user if needed
  done null,user
passport.deserializeUser (user,done) ->
  done null,user
  
app = express()

sessionMW = session
  secret: 'aj0hgg8 52-/+.a"{'
  resave: true
  saveUninitialized: true

app.use sessionMW
app.use passport.initialize()
app.use passport.session() # black-magik
# app.use (favicon __dirname + './../favicon.ico')

# open pages
app.use "/$", (req,res) ->
  res.send "<p>welcome: 'request'</p>
    <p>try: <a href=/proxy-test>secure-data</a></p>"

# secure pages
app.use "/proxy-test", ensureLoggedIn, (require './routes/test') PORT_T

# security urls
app.use ( (require './routes/security') passport,auth0Conf,callbackPath)

# start main-webapp aka proxy
app.listen PORT
console.log "port.er on :#{PORT}"

# start test-webapp
# TODO remove
(require './test-app') PORT_T
