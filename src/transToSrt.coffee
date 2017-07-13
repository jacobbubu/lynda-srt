{ EOL } = require 'os'
addSeconds = require 'date-fns/add_seconds'
format = require 'date-fns/format'

# 1
# 00:02:17,440 --> 00:02:20,375
# Senator, we're making
# our final approach into Coruscant.

pad2 = (s) -> ('0' + s).slice -2

durationToTimeBlock = (dur) ->
    d = new Date('2001-1-1')
    newDate = addSeconds d, Number(dur)
    hour = format newDate, 'HH'
    rest = format newDate, 'mm:ss,SSS'
    "#{hour}:#{rest}"

convert = ({cheerio}, trans, name) ->
    $ = cheerio.load trans
    totalDuration = Number($('.video-transcripts').attr('data-video-duration'))
    sentences = $('.transcript').toArray().map (ele) -> {
        text: $(ele).text()
        start: Number(ele.attribs['data-duration'])
    }
    srt = sentences.reduce (sum, sentence, idx, arr) ->
        next = arr[idx + 1]
        if next
            nextTimeBlock = durationToTimeBlock next.start
        else
            nextTimeBlock = durationToTimeBlock(totalDuration)

        sum += EOL
        sum += idx + 1
        sum += EOL
        sum += "#{durationToTimeBlock(sentence.start)} --> #{nextTimeBlock}"
        sum += EOL
        sum += sentence.text
        sum += EOL
        sum
    , ''
    { srt, duration: totalDuration }

module.exports = convert
