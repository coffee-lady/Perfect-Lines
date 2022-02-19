const USER_THEME = 'theme';
const DEFAULT_THEME = 'light';
const themes = {
    light: {
        wrapper: '#E9E9E9',
        container: '#FBFAFF',
        title: '#555555',
        logo: 'invert(35%) sepia(0%) saturate(0%) hue-rotate(59deg) brightness(93%) contrast(94%)',
        icon_bg: '#EDEDED',
        loading_progressbar_filled: '#8583FF',
        loading_progressbar_blank: '#CDCCFF',
        square: 'rgba(200, 199, 204, 0.2)',
    },
    dark: {
        wrapper: '#3A3D42',
        container: '#27292D',
        title: '#DFDFE0',
        logo: 'invert(97%) sepia(2%) saturate(75%) hue-rotate(202deg) brightness(94%) contrast(89%)',
        icon_bg: '#3A3D42',
        loading_progressbar_filled: '#8E8CFF',
        loading_progressbar_blank: 'rgba(205, 204, 255, 0.5)',
        square: 'rgba(90, 90, 105, 0.2)',
    },
    blue: {
        wrapper: '#E0ECF6',
        container: '#FBFAFF',
        title: '#454545',
        logo: 'invert(25%) sepia(24%) saturate(6%) hue-rotate(314deg) brightness(95%) contrast(93%)',
        icon_bg: '#EDEDED',
        loading_progressbar_filled: '#238EEB',
        loading_progressbar_blank: '#AFDAFF',
        square: 'rgba(210, 227, 241, 0.5)',
    },
    yellow: {
        wrapper: '#F9F3E0',
        container: '#FFFFFF',
        title: '#292929',
        logo: 'invert(11%) sepia(2%) saturate(0%) hue-rotate(137deg) brightness(83%) contrast(82%)',
        icon_bg: '#EDEDED',
        loading_progressbar_filled: '#F6C938',
        loading_progressbar_blank: '#FFE492',
        square: 'rgba(212, 209, 227, 0.2)',
    },
    green: {
        wrapper: '#E2E8D9',
        container: '#FBFAFF',
        title: '#555555',
        logo: 'invert(34%) sepia(29%) saturate(914%) hue-rotate(81deg) brightness(95%) contrast(92%)',
        icon_bg: '#EDEDED',
        loading_progressbar_filled: '#348D47',
        loading_progressbar_blank: '#C8DBCC',
        square: '#DBE1D0',
    }
};

function DesignHelper() {
    this.currentTheme = localStorage.getItem(USER_THEME);

    this.changeTheme = function(theme, isSaved) {
        if (!theme) {
            this.currentTheme = this.currentTheme ? this.currentTheme : DEFAULT_THEME;
        } else {
            this.currentTheme = theme;
        }

        if (isSaved) {
            localStorage.setItem(USER_THEME, this.currentTheme);
        }

        const colors = themes[this.currentTheme];

        document.querySelectorAll('.square').forEach(element => {
            element.style.background = colors.square;
        });
        document.querySelector('.container').style.background = colors.wrapper;
        document.querySelector('.loading_container').style.background = colors.container;
        document.querySelector('.loading__title').style.color = colors.title;
        document.querySelector('.loading__logo').style.filter = colors.logo;
        document.querySelector('.loading__icon_circle').style.background = colors.icon_bg;
        document.querySelector('.loading__progressbar').style.background = colors.loading_progressbar_filled;
        document.querySelector('.loading__progressbar_container').style.background = colors.loading_progressbar_blank;
    }
}
