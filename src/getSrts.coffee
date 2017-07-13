{ EOL } = require 'os'
toSrt = require './transToSrt'

module.exports = ({nightmare, cheerio}, {author, trans}) ->
    await nightmare
        .on 'console', (type, argv...) ->
            console.log "#{type.toUpperCase()}:", argv...
        .evaluate (trans) ->
            result = []
            for tran from trans
                { videoId, srtUrl, name } = tran
                console.log 'Got transcript from', srtUrl
                response = await fetch "#{srtUrl}", credentials: 'same-origin'
                htmlTranscript = (await response.json()).html
                result.push { videoId, srtUrl, name, htmlTranscript }
            result
        , trans
        .then (trans) ->
            playlist = '#EXTM3U' + EOL
            allSrts = trans.reduce (sum, curr) ->
                t = toSrt {cheerio}, curr.htmlTranscript, curr.name
                playlist += "#EXTINF:#{t.duration}, #{author} - #{curr.name}" + EOL
                playlist += "#{curr.name}.mp4"+ EOL + EOL
                sum.push { t..., name: curr.name }
                sum
            , []
            { allSrts, playlist }

