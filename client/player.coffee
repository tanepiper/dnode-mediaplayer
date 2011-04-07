class window.Player extends process.EventEmitter
    constructor: (player_elem, canvas_elem, playlist) ->        
        @image = if playlist.image then playlist.image or null
        @audio_files = playlist.audio_files
        
        #jQuery(@playerWidget()).insertAfter player_elem
        
        @player = jQuery(player_elem).jPlayer
            swfPath: "/jplayer",
            supplied: "oga"
            ready: () ->
                $(this).jPlayer 'setMedia',
                    oga: playlist.audio_files[0].path
                    
        @canvas = jQuery(canvas_elem).get()[0]
        @c_context = @canvas.getContext '2d'
        
        
        
        
    playerWidget: () ->
        return """
        <div class="jp-audio">
            <div class="jp-type-single">
                <div class="jp-interface">
                    <ul class="jp-controls">
                        <li><a href="#" class="jp-play" tabindex="1">Play</a></li>
                        <li><a href="#" class="jp-pause" tabindex="2">Pause</a></li>
                        <li><a href="#" class="jp-stop" tabindex="3">Stop</a></li>
                        <li><a href="#" class="jp-previous" tabindex="4">Prev</a></li>
                        <li><a href="#" class="jp-next" tabindex="5">Next</a></li>
                        <li><a href="#" class="jp-mute" tabindex="6">Mute</a></li>
                        <li><a href="#" class="jp-unmute" tabindex="7">Unmute</a></li>
                    </ul>
                    <div class="jp-progress">
                        <div class="jp-seek-bar">
                            <div  class="jp-play-bar"></div>
                        </div>
                    </div>
            
                    <div class="jp-volume-bar">
                        <div class="jp-volume-bar-value"></div>
                    </div>
                    <div class="jp-current-time"></div>
                    <div class="jp-duration"></div>
                </div>
                <div id="playlist" class="jp-playlist">
                    <ul></ul>
                </div>
            </div>
        </div>"""
       
        
    init: () ->
        #@playerWidget()
        for file in @audio_files
            link = $("<a id=\"#{file.index}\" href=\"#{file.path}\">#{file.name}</a>")
            @attachHandler link
            
            item = $('<li></li>').append link
            jQuery('.jp-playlist ul').append item
        
        
        @player.jPlayer 'setMedia',
            oga: @audio_files[0].path
                
    attachHandler: (link) ->
        id = parseInt link.attr('id'), 10

        link.click () =>
            console.log id
            @player.jPlayer 'setMedia',
                oga: @audio_files[id].path
            @player.jPlayer 'play'
            return false;