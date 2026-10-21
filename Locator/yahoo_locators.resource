*** Variables ***
# Locators of https://login.yahoo.com/account/create (input ids and the "<id>-error" message ids are stable)
${YH_FIRST_NAME}           id=reg-firstName
${YH_LAST_NAME}            id=reg-lastName
${YH_USERNAME}             id=reg-userId
${YH_PASSWORD}             id=reg-password
${YH_DOB_MONTH}            id=undefined-mm
${YH_DOB_DAY}              id=undefined-dd
${YH_DOB_YEAR}             id=undefined-yyyy
${YH_NEXT_BUTTON}          css=button[name="signup"]
${YH_TERMS_LINK}           css=form#challenge-form p a[data-ylk*="slk:terms"]
${YH_PRIVACY_LINK}         css=form#challenge-form p a[data-ylk*="slk:privacy"]
${YH_PASSWORD_STRENGTH}    css=[data-testid="password-strength-status"]

# Error message of each field; the date of birth message sits in the fieldset
${YH_ERR_FIRST_NAME}       id=reg-firstName-error
${YH_ERR_LAST_NAME}        id=reg-lastName-error
${YH_ERR_USERNAME}         id=reg-userId-error
${YH_ERR_PASSWORD}         id=reg-password-error
${YH_ERR_DOB}              css=fieldset[aria-labelledby="reg-birthDate-legend"] [role="alert"]
${YH_ANY_ERROR}            css=form#challenge-form [id$="-error"], form#challenge-form [role="alert"]

# Marker that the React page is hydrated (typing earlier gets wiped by the hydration)
${YH_HYDRATED_JS}          () => Object.keys(document.getElementById('reg-firstName')).some(k => k.startsWith('__react'))

&{YH_ERROR_BY_FIELD}       FIRST_NAME=${YH_ERR_FIRST_NAME}    LAST_NAME=${YH_ERR_LAST_NAME}    USERNAME=${YH_ERR_USERNAME}    PASSWORD=${YH_ERR_PASSWORD}    DOB=${YH_ERR_DOB}    PAGE=css=body

${YH_COUNT_ERRORS_JS}      () => Array.from(document.querySelectorAll('[id$="-error"]')).filter(e => e.innerText.trim() && (e.closest('.overflow-hidden') || e).getBoundingClientRect().height > 0).length
${YH_CARD_REGION_JS}       () => { window.scrollTo(0, 0); const f = document.getElementById('challenge-form').getBoundingClientRect(); const n = document.querySelector('button[name="signup"]').getBoundingClientRect(); const y = Math.max(0, f.top - 100); return {x: Math.max(0, f.left - 30), y: y, width: f.width + 60, height: Math.min(window.innerHeight - y, n.bottom - y + 20)}; }
${YH_LIST_ERRORS_JS}       () => Array.from(document.querySelectorAll('[id$="-error"]')).filter(e => e.innerText.trim() && (e.closest('.overflow-hidden') || e).getBoundingClientRect().height > 0).map(e => e.id + ': ' + e.innerText.trim()).join(' | ')
