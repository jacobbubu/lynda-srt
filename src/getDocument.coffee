module.exports = ({nightmare}, url, waitFor = 2e3) ->
    await nightmare
        .goto url
        .wait waitFor
        .evaluate -> document.body.innerHTML
