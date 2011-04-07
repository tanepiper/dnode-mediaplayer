class window.Player extends process.EventEmitter
    
    constructor: (player_elem, canvas_elem, playlist) ->  
        
        me = @
              
        @current_playing = 0
        
        @image = if playlist.image then playlist.image or null
        @audio_files = playlist.audio_files
        
        @player = jQuery(player_elem).get()[0]
        
        #jQuery(@playerWidget()).insertAfter player_elem
        
        ###
        @player = jQuery(player_elem).jPlayer
            swfPath: "/jplayer",
            supplied: "oga"
            ready: () ->
                $(this).jPlayer 'setMedia',
                    oga: playlist.audio_files[me.current_playing].path
                    
                jQuery('#' + me.current_playing).css('background-color': 'yellow')
            ended: () ->
                me.current_playing++
                $(this).jPlayer 'setMedia',
                    oga: playlist.audio_files[me.current_playing].path
                jQuery('.song').css('background-color': 'transparent')
                jQuery('#' + me.current_playing).css('background-color': 'yellow')
                $(this).jPlayer 'play'
            
        ###         
        @canvas = jQuery(canvas_elem).get()[0]
        @c_context = @canvas.getContext '2d'
        
        ###
        @player.on 'MozAudioAvailable', () ->
            console.log arguments
        , false
        ###
        
        
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
            link = $("<a class=\"song\" id=\"#{file.index}\" href=\"#{file.path}\">#{file.name}</a>")
            @attachHandler link
            
            item = $('<li></li>').append link
            jQuery('#playlist ul').append item
            
        jQuery(@player).append "<source src=\"#{@audio_files[@current_playing].path}\" />";
        jQuery('#' + @current_playing).css('background-color': 'yellow')
                
    attachHandler: (link) ->
        id = parseInt link.attr('id'), 10

        link.click () =>
            @current_playing = id
            jQuery('.song').css('background-color': 'transparent')
            jQuery('#' + @current_playing).css('background-color': 'yellow')
            jQuery(@player).html ''
            jQuery(@player).append "<source src=\"#{@audio_files[@current_playing].path}\" />"
            return false;