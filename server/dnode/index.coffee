fs = require 'fs'
path = require 'path'
ID3 = require 'id3'
_ = require 'underscore'

module.exports = (app, base_path) ->
    DNode = require 'dnode'
    
    app.dnode = {}
    app.dnode.client_connections = {}
    app.dnode.nexus_connections = {}
    
    app.dnode.client_server = DNode (client, connection) ->
    
        app.dnode.client_connections[connection.id] = 
            client: client
    
        connection.on 'connect', (request) ->
            console.log 'connect'
            console.log "Connection #{connection.id} created"
        
        connection.on 'request', (request) ->
            console.log 'request'
                
        connection.on 'end', (request) ->
            console.log "Connection #{connection.id} ended"
            #app.SessionManager.destroySession connection.id
            
        ###
        connection.on 'ready', ->
            client.serverMessage 'foo bar message'
        ###    
        
        # Main functions on all the main DNode request object
        #@userLogin = require('./controllers/user_login')(app, client, connection)
        #@signup = require('./signup')(app, client, connection)
        
        @getSongs = (callback) ->
            music_path = path.join base_path, 'music', 'tyrian'
            fs.readdir music_path, (error, files) ->
                if error
                    callback error
                else
                
                    output = 
                        audio_files: []
                    files.sort()
                    
                    index = 0
                    while files.length
                        file = files.shift()
                        is_image = file.indexOf('.jpg')
                        if is_image > 0
                            output['image'] = "/show-image/#{file}"
                        else
                            audio = _.extend {},
                                index: index
                                name: file
                                path: "/play/#{file}"
                            output.audio_files.push audio
                            index = index + 1
                    return callback null, output
                    
        @settings = 
            application_name: 'DMusic X'
            application_version: [0, 1, 0, 'alpha']
            
        return
    .listen app
    #app.dnode.client_server.use require('dnode-stack')()
    
    
    app.dnode.nexus_server = DNode (client, connection) ->
        app.dnode.nexus_connections[connection.id] = client
        
        connection.on 'end', ->
            app.dnode.nexus_connections[connection.id] = null
            
        return
    .listen 20000