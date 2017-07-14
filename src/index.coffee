nconf = require 'nconf'
fs = require 'fs'
path = require 'path'
Nightmare = require 'nightmare'
cheerio = require 'cheerio'
sanitize = require 'sanitize-filename'
pify = require 'pify'
{ isWebUri } = require 'valid-url'

login = require './login'
getDocument = require './getDocument'
extractCourseInfo = require './extractCourseInfo'
getSrts = require './getSrts'

writeFile = pify(fs.writeFile)
exeName = require('../package.json').name

DefaultViewport = [1280, 800]

nconf.env({whitelist: [
    'lyndauser'
    'lyndapass'
]}).argv()

courseUrl = nconf.get('_')[0]
username = nconf.get 'lyndauser'
password = nconf.get 'lyndapass'
show = nconf.get('show') ? false

if !courseUrl or !username or !password
    console.warn """
        Arguments requried, using command-line arguments:

            #{exeName} --lyndauser your_account --lyndapass your_password https://www.lynda.com/ZBrush...

        or environment variables:

            lyndauser=your_account lyndapass=your_password #{exeName} https://www.lynda.com/ZBrush...
    """
    process.exit -1

if !isWebUri(courseUrl)
    console.warn 'Invalid course url.'
    process.exit -1

getNightmare = ->
    opts =
        typeInterval: 10
        waitTimeout: 10e3
        executionTimeout: 600e3 #10 mins
        gotoTimeout: 20e3
        show: show
        webPreferences:
            partition: 'persist:lynda-srt'
    Nightmare(opts).viewport DefaultViewport...

main = ->
    nightmare = getNightmare()
    context = { nightmare, cheerio, sanitize }
    try
        console.log 'Starting...'
        await login(context, username, password)
        console.log "#{username} has logged-in"

        html = await getDocument(context, courseUrl)
        { title, author, trans } = extractCourseInfo context, html
        console.log "The content of course('#{title}') has been extracted"

        { allSrts, playlist } = await getSrts(context, { author, trans })

        outputDir = process.cwd()
        for { srt, name } from allSrts
            await writeFile path.join(outputDir, "#{name}.srt"), srt, 'utf8'
        await writeFile path.join(outputDir, "#{title}.m3u"), playlist, 'utf8'

        "#{allSrts.length} subtitle files and a playlist('#{title}.m3u') file has been generated"
    finally
        await nightmare.end()

main().then console.log.bind console, 'LOG:'
    .catch (err) -> console.error 'Error:', err
