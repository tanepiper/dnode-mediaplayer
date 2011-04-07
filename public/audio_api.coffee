audio = document.getElementById '01.ogg'
channels = audio.mozChannels
rate = audio.mozSampleRate
frameBufferLength = audio.mozFrameBufferLength

console.log channels, rate, frameBufferLength