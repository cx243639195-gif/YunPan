.pragma library

var themes = {
    light: {
        name: "Light",
        primary: {
            background: "#2D8CF0",
            backgroundHovered: "#5AA1F2",
            foreground: "#ffffff"
        },
        surface: {
            background: "#f7f7f7",
            backgroundRaised: "#ffffff",
            border: "#e0e0e0",
            foreground: "#1f1f1f",
            subtle: "#666666"
        }
    },
    dark: {
        name: "Dark",
        primary: {
            background: "#3B82F6",
            backgroundHovered: "#60A5FA",
            foreground: "#111827"
        },
        surface: {
            background: "#161B22",
            backgroundRaised: "#1F2933",
            border: "#374151",
            foreground: "#F9FAFB",
            subtle: "#9CA3AF"
        }
    }
};

function defaultTheme() {
    return "light";
}

function hasTheme(name) {
    return Object.prototype.hasOwnProperty.call(themes, name);
}

function theme(name) {
    if (!hasTheme(name))
        return themes[defaultTheme()];
    return themes[name];
}

function themeNames() {
    return Object.keys(themes);
}

function resolveToken(theme, path) {
    if (!path)
        return theme;

    var parts = path.split(".");
    var value = theme;
    for (var i = 0; i < parts.length; ++i) {
        if (value === undefined || value === null)
            return undefined;
        value = value[parts[i]];
    }
    return value;
}
