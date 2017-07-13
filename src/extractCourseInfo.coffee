getTransUrl = (courseId, videoId) ->
    "https://www.lynda.com/ajax/course/videotranscripts?courseId=#{courseId}&videoId=#{videoId}"

module.exports = ({cheerio, sanitize}, html) ->
    $ = cheerio.load html
    title = $('a.headline-course-title').text()
    if !title
        title = $('h1.default-title').attr('data-course')
    courseId = $('#course-page').attr('data-course-id')
    toc = $('#toc-content')
    author = $('cite.ga[data-ga-label=author-name]').text()

    if !courseId or !toc or !title
        throw new Error 'Cannot get course id and toc'

    title = sanitize title.replace /\s{2,}New$/, '' # remove trailimng 'New' text

    trans = toc.find('ul.course-toc li.toc-video-item').toArray().map (ele) ->
        name = sanitize $(ele).find('a').text().trim()
        videoId = ele.attribs['data-video-id']

        { videoId, name, srtUrl: getTransUrl(courseId, videoId) }

    { courseId, author, trans, title}
