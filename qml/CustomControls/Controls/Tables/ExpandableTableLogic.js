.pragma library

function defaultColumnWidth() {
    return 160;
}

function defaultMinimumWidth() {
    return 96;
}

function columnFlex(column) {
    if (!column)
        return 1;
    var flex = column.flex;
    if (flex === undefined || flex === null)
        return 1;
    return Math.max(0, flex);
}

function columnBaseWidth(column) {
    if (!column)
        return defaultColumnWidth();
    if (column.width === undefined || column.width === null)
        return defaultColumnWidth();
    return Math.max(0, column.width);
}

function columnMinimumWidth(column) {
    if (!column)
        return defaultMinimumWidth();
    if (column.minimumWidth === undefined || column.minimumWidth === null)
        return Math.max(defaultMinimumWidth(), columnBaseWidth(column));
    return Math.max(0, column.minimumWidth);
}

function recalculateColumnWidths(availableWidth, columns, spacing, expandColumns) {
    var count = Array.isArray(columns) ? columns.length : 0;
    if (count === 0) {
        return { widths: [], totalWidth: 0 };
    }

    spacing = Math.max(0, spacing || 0);
    var widths = new Array(count);
    var baseWidths = new Array(count);
    var minimumWidths = new Array(count);
    var flexValues = new Array(count);
    var baseWidthSum = 0;
    var flexSum = 0;

    for (var i = 0; i < count; ++i) {
        var column = columns[i];
        var base = columnBaseWidth(column);
        var minimum = columnMinimumWidth(column);
        if (minimum > base)
            base = minimum;
        var flex = columnFlex(column);

        baseWidths[i] = base;
        minimumWidths[i] = minimum;
        flexValues[i] = flex;
        baseWidthSum += base;
        if (flex > 0)
            flexSum += flex;
    }

    var spacingTotal = spacing * Math.max(0, count - 1);
    var widthForColumns = availableWidth;
    if (widthForColumns === undefined || widthForColumns === null || widthForColumns < 0)
        widthForColumns = baseWidthSum;
    else
        widthForColumns = Math.max(0, widthForColumns - spacingTotal);

    var extra = 0;
    if (expandColumns && widthForColumns > baseWidthSum && flexSum > 0)
        extra = widthForColumns - baseWidthSum;

    for (var j = 0; j < count; ++j) {
        var current = baseWidths[j];
        if (extra > 0 && flexValues[j] > 0)
            current += extra * (flexValues[j] / flexSum);
        if (current < minimumWidths[j])
            current = minimumWidths[j];
        widths[j] = current;
    }

    var totalWidth = spacingTotal;
    for (var k = 0; k < count; ++k)
        totalWidth += widths[k];

    return {
        widths: widths,
        totalWidth: totalWidth
    };
}

function surfaceBackground(theme) {
    return theme && theme.surface ? (theme.surface.backgroundRaised || theme.surface.background || "#ffffff") : "#ffffff";
}

function rowBackground(theme) {
    return theme && theme.surface ? (theme.surface.backgroundRaised || "#ffffff") : "#ffffff";
}

function alternateRowBackground(theme) {
    return theme && theme.surface ? (theme.surface.background || "#f5f5f5") : "#f5f5f5";
}

function headerBackground(theme) {
    return theme && theme.surface ? (theme.surface.background || "#f0f0f0") : "#f0f0f0";
}

function headerForeground(theme) {
    return theme && theme.surface ? (theme.surface.foreground || "#333333") : "#333333";
}

function rowForeground(theme) {
    return theme && theme.surface ? (theme.surface.foreground || "#333333") : "#333333";
}

function gridColor(theme) {
    return theme && theme.surface ? (theme.surface.border || "#d0d0d0") : "#d0d0d0";
}

function resolveColumnTitle(column, fallback) {
    if (!column)
        return fallback;
    if (column.title !== undefined && column.title !== null)
        return column.title;
    if (column.label !== undefined && column.label !== null)
        return column.label;
    if (column.role !== undefined && column.role !== null)
        return column.role;
    return fallback;
}

function rowCount(model) {
    if (!model)
        return 0;
    if (typeof model.count === "number")
        return model.count;
    if (typeof model.length === "number")
        return model.length;
    return 0;
}

function rowData(model, index, modelData) {
    if (!model)
        return {};
    if (typeof model.get === "function")
        return model.get(index) || {};
    if (modelData !== undefined)
        return modelData;
    return {};
}

function cellValue(column, rowData, columnIndex) {
    if (!column) {
        if (rowData && typeof rowData === "object") {
            var values = Object.keys(rowData);
            if (columnIndex >= 0 && columnIndex < values.length)
                return rowData[values[columnIndex]];
        }
        return "";
    }

    if (column.formatter !== undefined && column.formatter !== null) {
        try {
            return column.formatter(rowData, columnIndex);
        } catch (err) {
            console.warn("ExpandableTable: formatter threw", err);
            return "";
        }
    }

    var role = column.role;
    if (role === undefined || role === null)
        role = column.key;

    if (role && rowData && typeof rowData === "object" && role in rowData)
        return rowData[role];

    return "";
}

function alignment(column) {
    if (!column || column.alignment === undefined || column.alignment === null)
        return "left";
    return column.alignment;
}

function isNumericAlignment(alignment) {
    return alignment === "right";
}

function rowBackgroundForIndex(theme, rowIndex, alternating) {
    if (!alternating)
        return rowBackground(theme);
    return (rowIndex % 2 === 0) ? rowBackground(theme) : alternateRowBackground(theme);
}

