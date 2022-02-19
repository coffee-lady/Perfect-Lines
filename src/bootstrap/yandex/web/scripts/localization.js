const USER_LANG = 'lang';
const DEFAULT_LANG = 'ru';
const locales = {
    en: {
        title: 'Sudoku Master',
        loading: 'Loading',
    },
    ru: {
        title: 'Судоку Мастер',
        loading: 'Загрузка',
    },
    tr: {
        title: 'Sudoku Ustası',
        loading: 'Yükleniyor',
    },
};

function LocalizationHelper() {
    this.currentLang = localStorage.getItem(USER_LANG);

    this.changeLang = function(lang) {
        if (!lang) {
            this.currentLang = this.currentLang ? this.currentLang : DEFAULT_LANG;
        } else {
            this.currentLang = lang;
        }

        localStorage.setItem(USER_LANG, this.currentLang);

        const texts = locales[this.currentLang];

        document.querySelector('.loading__title').textContent = texts.title;
        document.querySelector('.loading__progressbar__text').textContent = texts.loading;
    }
}
