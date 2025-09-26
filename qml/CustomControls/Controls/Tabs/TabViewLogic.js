.pragma library

function tabCount(tabs) {
    if (!tabs)
        return 0;

    if (typeof tabs.count === "number")
        return tabs.count;

    if (Array.isArray(tabs))
        return tabs.length;

    if (typeof tabs.length === "number")
        return tabs.length;

    return 0;
}

function tabEntry(tabs, index) {
    if (!tabs || index < 0)
        return null;

    if (typeof tabs.get === "function")
        return tabs.get(index);

    if (Array.isArray(tabs))
        return tabs[index];

    if (tabs[index] !== undefined)
        return tabs[index];

    return null;
}

function tabTitle(tabs, index) {
    var entry = tabEntry(tabs, index);
    if (!entry)
        return qsTr("Tab %1").arg(index + 1);

    if (entry.title !== undefined)
        return entry.title;

    if (entry.text !== undefined)
        return entry.text;

    if (entry.name !== undefined)
        return entry.name;

    return qsTr("Tab %1").arg(index + 1);
}

function tabEnabled(tabs, index) {
    var entry = tabEntry(tabs, index);
    if (!entry)
        return false;

    if (entry.enabled === undefined)
        return true;

    return !!entry.enabled;
}

function contentDefinition(tabs, index) {
    var entry = tabEntry(tabs, index);
    if (!entry)
        return { component: null, source: "" };

    if (entry.component)
        return { component: entry.component, source: "" };

    if (entry.sourceComponent)
        return { component: entry.sourceComponent, source: "" };

    if (entry.source)
        return { component: null, source: entry.source };

    if (entry.loader !== undefined)
        return { component: null, source: entry.loader };

    return { component: null, source: "" };
}

function clampIndex(index, count) {
    if (count <= 0)
        return -1;

    if (index === undefined || index === null)
        return 0;

    if (index < 0)
        return 0;

    if (index >= count)
        return count - 1;

    return index;
}

exports.tabCount = tabCount;
exports.tabTitle = tabTitle;
exports.tabEnabled = tabEnabled;
exports.contentDefinition = contentDefinition;
exports.clampIndex = clampIndex;
