router = (require 'express').Router()
httpProxy = require 'http-proxy'

proxy = httpProxy.createServer {}

module.exports = (port) ->

  # routes
  router.use '/', (req,res) ->
    proxy.web req,res,
      target: "http://localhost:#{port}"
  
  router
