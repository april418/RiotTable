fs = require 'fs'
path = require 'path'

MINE_TYPES =
  '.html': 'text/html'
  '.css': 'text/css'
  '.js': 'text/javascript'
  '.jpg': 'image/jpg'
  '.png': 'image/png'
  '.mp3': 'audio/mpeg'

class RequestHandler
  handle: (filePath, requestData, response) =>
    fs.exists filePath, (result) ->
      if result
        fs.readFile filePath, (error, file) ->
          if error
            console.log "failed to open file. file path: #{filePath}, error: #{error}"
            response.writeHeader 500
            response.end 'Internal Server Error.'
          else
            console.log "success to open file. file path: #{filePath}"
            response.writeHeader 200, 'Content-Type': MINE_TYPES[path.extname(filePath)]
            response.end file
      else
        console.log "file not found. file path: #{filePath}"
        response.writeHeader 404
        response.end 'File not found.'

module.exports = RequestHandler
