express = require 'express'
testApp = express()

module.exports = (p) ->
  testApp.use '/', (req,res) ->
    console.log 'headers',req.headers
    console.log 'path was',req.path
    res.status(200)
      .append "X-DS-service", "test/app on port #{p}"
      .send "<html>
      <head>
      <title>test</title>
       </head><body>
      <b>Req-headers:</b>
      <pre>#{JSON.stringify req.headers,null, " "}</pre></body></html>"

  testApp.listen p
  console.log "test data on :#{p}"

