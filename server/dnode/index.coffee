fs = require 'fs'
path = require 'path'
ID3 = require 'id3'

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
            music_path = path.join base_path, 'music'
            fs.readdir music_path, (error, files) ->
                if error
                    callback error
                else
                    id3s = {}
                    for file in files
                        console.log file
                        handler = fs.readFileSync "#{music_path}/#{file}"
                        id3 = new ID3 handler
                        
                        
                        id3s[file] = {
                            path: "/play/#{file}"
                            id3: id3.getTags()
                        }
                    #console.log id3s
                    return callback null, id3s
                    
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