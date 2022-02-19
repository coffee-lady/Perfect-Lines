local CommonConstants = {}

CommonConstants = {
    images = {
        master_difficulty_icon = 'master_difficulty',
        closed_difficulty = 'inaccessible_difficulty',
        rank_locked_icon = 'rank_icon_full_locked',
    },

    components = {
        slider = {
            arrow_next = 'arrow_next',
            arrow_prev = 'arrow_prev',
            scroll_indicator_template = 'scroll_indicator_template',
        },

        checkbox = {
            container = 'checkbox/container',
            text = 'checkbox/text',
            checkmark = 'checkbox/checkmark',
            checkmark_stroke = 'checkbox/checkmark_stroke',
        },
    },

    templates = {
        simple_popup = {
            background = 'background',
            root = 'root',
            header = 'header',
            title = 'title/text',
            button_close = {
                container = 'button_close/container',
                inner = 'button_close/inner',
            },
            text = 'text',

            icon = 'icon',
            icon_bg = 'icon_bg',
            button_next = {
                container = 'button_next/container',
                inner = 'button_next/inner',
                text = 'button_next/text',
            },
        },
    },
}

return CommonConstants
