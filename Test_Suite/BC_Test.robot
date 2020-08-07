*** Settings ***
Library  SeleniumLibrary
Library  String
Resource  ../PO/BC_locaters.robot
*** Test Cases ***
Configure business cards
    open browser  http://localhost:8081/  chrome
    maximize browser window
    click button  css:button[id='submitInfo']
    set selenium speed  2 seconds
    select frame  id=iframe
    set selenium timeout  20 seconds
    wait until element is visible  ${BC_Link}
    click element  ${BC_Link}
    unselect frame
    select frame  xpath://*[@id='iframe']
    wait until element is visible  ${BC_Product_Type}
    select from list by index  ${BC_Product_Type}  1
    set selenium implicit wait  20 seconds
    wait until element is visible  ${BC_Product_Orientation}
    select from list by index  ${BC_Product_Orientation}  1
    wait until element is visible  ${BC_Stock}
    select from list by index  ${BC_Stock}  1
    wait until element is visible  ${BC_Coating}
    select from list by index  ${BC_Coating}  1
    wait until element is visible  ${BC_Colorspec}
    select from list by index  ${BC_Colorspec}  1
    wait until element is enabled  ${Next_Button}
    click button  ${Next_Button}
    unselect frame
    select frame  xpath://*[@id='iframe']
    choose file  css:input[type=file][id='7b3007a1-c296-447b-96cf-ca9d0fb6621a']  ${EXECDIR}/Test_Files/Preflight_success.jpg
    ${Product_Price}=  get text  xpath:(//div[@class='item-price'])[1]
    ${price}=  Remove String  ${Product_Price}  ,  "$"
    ${Shipping}=  get text  xpath:(//div[@class='item-price'])[2]
    ${Shipping1}=  Remove String  ${Shipping}  ,  "$"
    ${Tax}=  get text  xpath:(//div[@class='item-price'])[3]
    ${tax1}=  Remove String  ${Tax}  ,  "$"
    ${Total}=  get text  xpath:(//div[@class='item-price'])[4]
    ${Total1}=  Remove String  ${Total}  ,  "$"
    log to console  the prices are ${Product_Price} ${Shipping} ${Tax} ${Total}
    click button  xpath://button[@style='right: 0px;bottom: 0px;']
    unselect frame
    ${payload_output}=  get value  xpath://textarea[@id='parentMessageRecieved']
    log to console  ${payload_output}
    should contain  ${payload_output}  "extraCharges":[{"code":"tax","description":"total tax","unitCost":"1.74","quantity":1}],"freight":[{"itemNum":"03f","quantity":1,"quantityType":"EA","description":"Free Ground Shipping","unitCost":"0.00","currencyCode":"USD"}]
    should contain any  |  ${payload_output}  |  "unitCost":"${tax1}"  |  "unitCost":"0.00"  |  "total_price":"${price}"  |  "shipping_tax_amount":"0.00"  |  "tax_amount":1.74  |  "shipping_amount":"${Shipping1}"  |  "unitCost":"${Shipping1}"
