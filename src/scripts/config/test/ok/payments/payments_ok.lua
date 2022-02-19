local PaymentsConfig = {}

PaymentsConfig.starter_pack_id = 'sdi_ok_starter_pack'
PaymentsConfig.starter_pack_replacer_id = 'sdi_ok_pack_replacer'
PaymentsConfig.offers_ids = {
    [PaymentsConfig.starter_pack_id] = 'sdi_ok_starter_pack_offer',
}

PaymentsConfig.products = {{
    id = PaymentsConfig.starter_pack_id,
    offer_id = 'sdi_ok_starter_pack_offer',
    interstitial_till_offer = 3,
    offer_duration = 3600,
    ui_id = 1,
}, {
    id = 'sdi_ok_starter_pack_offer',
    ui_id = 2,
}, {
    id = PaymentsConfig.starter_pack_replacer_id,
    ui_id = 3,
}, {
    id = 'sdi_ok_pack_1',
    ui_id = 4,
}, {
    id = 'sdi_ok_pack_2',
    ui_id = 5,
}, {
    id = 'sdi_ok_pack_3',
    ui_id = 6,
}, {
    id = 'sdi_ok_pack_4',
    ui_id = 7,
}}

return PaymentsConfig
