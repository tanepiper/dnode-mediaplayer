fs = require 'fs'
path = require 'path'
util = require 'util'
express = require 'express'
app = module.exports = express.createServer()

dnode = require 'dnode'

app.configure ->
    app.set 'views', "#{__dirname}/views"
    app.set 'view engine', 'jade'
    
    app.use app.router
    app.use express.static "#{__dirname}/public"
    
    app.use require('browserify')(
        mount : '/browserify.js',
        require : [ 'underscore', 'backbone' ]
    )
    
require("#{__dirname}/server/dnode")(app, __dirname)

app.get '/', (req, res, next) ->
    music_path = path.join __dirname, 'music', 'tyrian'
    fs.readdir music_path, (error, files) ->
        res.render 'index',
            files: files
            pageTitle: 'Foo Player'
        ###
        output = []
        for file in files
            output.push "<strong>#{file}</strong><br />"
            output.push "<audio controls preload=\"auto\" autobuffer src=\"http://192.168.253.142:9001/play/#{file}\"></audio>"
            output.push '<br />'
        res.send output.join('\n'), {"content-type": "text/html"}, 200
        ###

app.get '/play/:file', (req, res, next) ->
    filePath = path.join __dirname, 'music', 'tyrian', req.param 'file'
    stat = fs.statSync filePath
    
    res.header 'content-type', 'audio/ogg'
    res.header 'content-length', stat.size
    res.sendfile filePath
    
    
app.get '/show-image/:file', (req, res, next) ->
    filePath = path.join __dirname, 'music', 'tyrian', req.param 'file'
    stat = fs.statSync filePath
    
    res.header 'content-type', 'audio/ogg'
    res.header 'content-length', stat.size
    res.sendfile filePath
    
app.listen 9001