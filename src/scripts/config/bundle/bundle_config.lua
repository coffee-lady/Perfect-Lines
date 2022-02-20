local BundleConfig = {
    bob_path = 'bob.jar',
    platforms_scripts = 'src/scripts/common/platform/',

    platforms = {'yandex', 'ok'},

    command_name = 'Bundle ',
    commands_titles = {yandex = 'Yandex', ok = 'OK'},
    commands_locations = {'Edit'},

    platforms_config = {
        yandex = {
            archive = true,
            debug = false,
            platform = 'js-web',
            -- bundle_output = 'D:\\Builds\\js-web\\Yandex',
            bundle_output = 'E:\\Projects\\Builds\\js-web',
            settings = 'src/app/settings/yandex/yandex_game.project',
            folders_to_exclude = {'src/scripts/common/platform/common/adapters/nakama'},
        },
        ok = {
            archive = true,
            debug = true,
            platform = 'js-web',
            -- bundle_output = 'D:\\Builds\\js-web\\OK',
            bundle_output = 'E:\\Projects\\Builds\\js-web',
            settings = 'src/app/settings/ok/ok_game.project',
            folders_to_exclude = {},
        },
    },
}

return BundleConfig
