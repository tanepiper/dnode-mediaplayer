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
    remote.getSongs (error, files) ->
        if error
            console.log error
        else
            console.log files
            $(document).ready () ->
                $("#jquery_jplayer_1").jPlayer
                    ready: () ->
                        $(this).jPlayer("setMedia",
                            oga: files['01.ogg'].path
                        ).jPlayer("play");
                    ended: (event) ->
                        $(this).jPlayer "play"
                    swfPath: "/jplayer",
                    supplied: "oga"
                for index, file of files
                    id = index.split('.')[0]
                    link = $("<li><a id=\"#{id}\" href=\"#{file.path}\">#{index}</a></li>")
                    $('#jp_playlist_1 ul').append link
                    $('#jp_playlist_1 ul li #' + id).click () ->
                        $("#jquery_jplayer_1").jPlayer("setMedia",
                            oga: file.path
                        ).jPlayer 'play'
                        return false