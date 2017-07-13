module.exports = ({nightmare}, username, password) ->
    await nightmare
        .cookies.clearAll()
        .goto 'https://www.lynda.com/signin'
        .wait 'input#email-address'
        .type('input#email-address', username)
        .click('button#username-submit')
        .wait 'input#password-input'
        .click('input#password-input')
        .type('input#password-input', password)
        .click('button#password-submit')
        .wait 2e3
