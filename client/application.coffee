class window.Application extends process.EventEmitter
    constructor: () ->
        @dnode = DNode
            serverMessage: (message) =>
                console.log message
                
        # Connect to the remote DNode application, we get back the methods which
        # we will bind to the current application   
        @dnode.connect (remote, connection) =>
            @remote = remote
            
            @emit 'connected', remote, connection
            
        @_ = require 'underscore'
        @backbone = require 'backbone'
            
    addSource: (elem, path) ->
      $('<source>').attr('src', path).appendTo elem
      
    
            
            
window.app = new Application();   

app.on 'connected', (remote, connection) ->
    remote.getSongs (error, response) ->
        if error
            console.log error
        else
            $(document).ready () ->
                player = new Player '#jquery_jplayer_1', '#player-vis', response
                player.init()