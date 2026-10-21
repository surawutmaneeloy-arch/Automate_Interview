*** Settings ***
Documentation       Prints the HTML reports written by TestRecorder to PDF with headless Chromium.
Library             Browser    auto_closing_level=MANUAL
Library             OperatingSystem
Library             TestRecorder.py


*** Variables ***
&{PDF_MARGIN}       top=10mm    bottom=10mm    left=8mm    right=8mm


*** Keywords ***
Export Pdf Reports
    [Arguments]    ${suite}    ${title}
    ${jobs}=    Export Suite Reports    ${suite}    ${title}
    IF    not $jobs    RETURN
    Set Browser Timeout    120s
    New Browser    chromium    headless=True
    New Context
    FOR    ${job}    IN    @{jobs}
        New Page    ${job}[1]
        Save Page As Pdf    ${job}[2]    format=A4    landscape=${job}[3]    printBackground=True    margin=${PDF_MARGIN}
        Close Page    CURRENT
        Remove File    ${job}[0]
    END
    Close Browser    CURRENT