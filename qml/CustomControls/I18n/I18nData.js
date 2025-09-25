.pragma library

var translations = Object.create(null);
var defaultCode = "en";

function ensureLanguage(code) {
    if (!code)
        return;
    if (!Object.prototype.hasOwnProperty.call(translations, code))
        translations[code] = Object.create(null);
}

function mergeInto(target, source) {
    for (var key in source) {
        if (!Object.prototype.hasOwnProperty.call(source, key))
            continue;
        var value = source[key];
        if (value && typeof value === "object" && !Array.isArray(value)) {
            if (!target[key] || typeof target[key] !== "object")
                target[key] = Object.create(null);
            mergeInto(target[key], value);
        } else {
            target[key] = value;
        }
    }
}

function registerTranslations(code, entries) {
    if (!code || !entries)
        return;
    ensureLanguage(code);
    mergeInto(translations[code], entries);
}

function setDefaultLanguage(code) {
    if (!code)
        return;
    ensureLanguage(code);
    defaultCode = code;
}

function defaultLanguage() {
    return defaultCode;
}

function hasLanguage(code) {
    return Object.prototype.hasOwnProperty.call(translations, code);
}

function languageCodes() {
    return Object.keys(translations);
}

function resolve(root, path) {
    if (!root)
        return undefined;
    var parts = path.split(".");
    var current = root;
    for (var i = 0; i < parts.length; ++i) {
        if (current === undefined || current === null)
            return undefined;
        current = current[parts[i]];
    }
    return current;
}

function translate(code, path, fallback) {
    var language = hasLanguage(code) ? code : defaultCode;
    var value = resolve(translations[language], path);
    if (value !== undefined)
        return value;

    if (language !== defaultCode) {
        value = resolve(translations[defaultCode], path);
        if (value !== undefined)
            return value;
    }

    return fallback !== undefined ? fallback : path;
}

registerTranslations("en", {
    languageName: "English"
});

registerTranslations("zh_CN", {
    languageName: "简体中文"
});
