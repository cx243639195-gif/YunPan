.pragma library

var translations = {
    "en": {
        languageName: "English",
        buttons: {
            primary: {
                default: "Confirm",
                loading: "Loading..."
            },
            secondary: {
                default: "Cancel"
            }
        },
        labels: {
            headline: "Custom Controls Library"
        },
        actions: {
            toggleTheme: "Toggle theme",
            toggleLanguage: "Switch language"
        }
    },
    "zh_CN": {
        languageName: "简体中文",
        buttons: {
            primary: {
                default: "确认",
                loading: "加载中..."
            },
            secondary: {
                default: "取消"
            }
        },
        labels: {
            headline: "自定义控件库"
        },
        actions: {
            toggleTheme: "切换主题",
            toggleLanguage: "切换语言"
        }
    }
};

function defaultLanguage() {
    return "en";
}

function hasLanguage(code) {
    return Object.prototype.hasOwnProperty.call(translations, code);
}

function languageCodes() {
    return Object.keys(translations);
}

function translate(code, path, fallback) {
    if (!hasLanguage(code))
        return fallback !== undefined ? fallback : path;

    var section = translations[code];
    var parts = path.split(".");
    for (var i = 0; i < parts.length; ++i) {
        if (section === undefined || section === null)
            break;
        section = section[parts[i]];
    }

    if (section === undefined || section === null)
        return fallback !== undefined ? fallback : path;
    return section;
}
