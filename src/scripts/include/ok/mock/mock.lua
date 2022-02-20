local Mock = {}

local DUMMY = {}
Mock.DELAY_TIMEOUT = 0

Mock.result_init = {status = true}

Mock.result_current_player = {
    status = true,
    player_data = {
        first_name = 'MOCK',
        last_name = 'USER',
        locale = 'ru',
        location = {city = 'Минск', country = 'BELARUS', countryCode = 'BY', countryName = 'Беларусь'},
        pic128x128 = 'https://i.mycdn.me/image?id=915381793412&t=34&plc=API&ts=000000016e000003b1&aid=512000881570&tkn=*tfG-olWnjDtSqKNA4gnFNks8O6U',
        -- pic128x128 = 'https://api.ok.ru/img/stub/user/female/128.png',
        uid = '562041079428',
    },
}

Mock.result_payment = {status = true}

local function delay_call(func, ...)
    if not func then
        return
    end

    local params = {...}

    timer.delay(Mock.DELAY_TIMEOUT, false, function()
        func(unpack(params))
    end)
end

function Mock.init(callback)
    delay_call(callback, DUMMY, DUMMY, Mock.result_init)
end

function Mock.get_current_player(callback)
    delay_call(callback, DUMMY, DUMMY, Mock.result_current_player)
end

function Mock.show_payment(options, callback)
    delay_call(callback, DUMMY, DUMMY, Mock.result_payment)
end

function Mock.load_rewarded_ad(callback)

    delay_call(callback, DUMMY, DUMMY, Mock.result_payment)
end

function Mock.show_rewarded_ad(callback)

    delay_call(callback, DUMMY, DUMMY, Mock.result_payment)
end

function Mock.show_interstitial_ad(callback)

    delay_call(callback, DUMMY, DUMMY, Mock.result_payment)
end

function Mock.show_invite(options, callback)
    delay_call(callback, DUMMY, DUMMY, Mock.result_payment)
end

return Mock
