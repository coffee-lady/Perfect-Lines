local PaymentsConfig = {}

PaymentsConfig.starter_pack_id = 'sdi_ya_starter_pack'
PaymentsConfig.starter_pack_replacer_id = 'sdi_ya_pack_replacer'
PaymentsConfig.offers_ids = {
    sdi_ya_starter_pack = 'sdi_ya_starter_pack_sale',
}

PaymentsConfig.products = {{
    id = 'sdi_ya_starter_pack',
    offer_id = 'sdi_ya_starter_pack_sale',
    interstitial_till_offer = 3,
    offer_duration = 3600,
    price = '119 RUB',
    offer_price = 99,
    ui_id = 1,
    items = {
        canceling_errors = 3,
        hints = 5,
        all_themes = true,
        no_ads = true,
    },
}, {
    id = 'sdi_ya_pack_replacer',
    price = '249 RUB',
    ui_id = 3,
    items = {
        canceling_errors = 10,
        hints = 10,
    },
}, {
    id = 'sdi_ya_pack_1',
    price = '129 RUB',
    ui_id = 4,
    items = {
        canceling_errors = 3,
        hints = 5,
    },
}, {
    id = 'sdi_ya_pack_2',
    price = '199 RUB',
    ui_id = 5,
    items = {
        canceling_errors = 5,
        hints = 10,
    },
}, {
    id = 'sdi_ya_pack_3',
    price = '599 RUB',
    ui_id = 6,
    items = {
        canceling_errors = 20,
        hints = 40,
    },
}, {
    id = 'sdi_ya_pack_4',
    price = '1199 RUB',
    ui_id = 7,
    items = {
        canceling_errors = 50,
        hints = 100,
    },
}}

return PaymentsConfig
