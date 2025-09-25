"""Run the gallery QML demo with a Qt for Python binding."""

from __future__ import annotations

import sys
from pathlib import Path
from typing import Callable, Tuple

QT_BINDING = ""


def _load_binding():
    """Import a Qt for Python binding and expose a unified API surface."""

    errors = {}

    def _record(name: str, error: Exception) -> None:
        errors[name] = error

    # Try modern Qt 6 bindings first.
    try:  # Prefer PySide6 because it matches Qt's official Python binding.
        from PySide6.QtCore import QUrl  # type: ignore
        from PySide6.QtGui import QGuiApplication  # type: ignore
        from PySide6.QtQml import QQmlApplicationEngine  # type: ignore

        return "PySide6", QUrl, QGuiApplication, QQmlApplicationEngine
    except ImportError as error:  # pragma: no cover - informative fallback path
        _record("PySide6", error)

    try:
        from PyQt6.QtCore import QUrl  # type: ignore
        from PyQt6.QtGui import QGuiApplication  # type: ignore
        from PyQt6.QtQml import QQmlApplicationEngine  # type: ignore

        return "PyQt6", QUrl, QGuiApplication, QQmlApplicationEngine
    except ImportError as error:  # pragma: no cover - informative fallback path
        _record("PyQt6", error)

    # Fall back to widely installed Qt 5 bindings so the script can run on
    # systems that have not migrated to Qt 6 yet.
    try:
        from PySide2.QtCore import QUrl  # type: ignore
        from PySide2.QtGui import QGuiApplication  # type: ignore
        from PySide2.QtQml import QQmlApplicationEngine  # type: ignore

        return "PySide2", QUrl, QGuiApplication, QQmlApplicationEngine
    except ImportError as error:  # pragma: no cover - informative fallback path
        _record("PySide2", error)

    try:
        from PyQt5.QtCore import QUrl  # type: ignore
        from PyQt5.QtGui import QGuiApplication  # type: ignore
        from PyQt5.QtQml import QQmlApplicationEngine  # type: ignore

        return "PyQt5", QUrl, QGuiApplication, QQmlApplicationEngine
    except ImportError as error:  # pragma: no cover - informative fallback path
        _record("PyQt5", error)

    missing = ["PySide6", "PyQt6", "PySide2", "PyQt5"]
    message = (
        "Unable to import any Qt for Python binding.\n"
        "Install one of the following packages and re-run the script:\n"
        + "\n".join(f"  pip install {name}" for name in missing)
        + "\nAlternatively run the example with qmlscene after exporting QML2_IMPORT_PATH.\n"
        + "\n".join(f"{name} import error: {errors.get(name)}" for name in missing)
    )
    raise SystemExit(message)


def _resolve_paths() -> Tuple[Path, Path]:
    """Return the gallery directory and qml import path."""
    gallery_dir = Path(__file__).resolve().parent
    repo_root = gallery_dir.parents[1]
    qml_dir = repo_root / "qml"
    return gallery_dir, qml_dir


def main() -> int:
    """Launch the QML gallery example."""
    gallery_dir, qml_dir = _resolve_paths()

    global QT_BINDING
    QT_BINDING, QUrl, QGuiApplication, QQmlApplicationEngine = _load_binding()

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath(str(qml_dir))

    collected_warnings = []
    warnings_attr = getattr(engine, "warnings", None)
    if warnings_attr is not None and hasattr(warnings_attr, "connect"):
        # PyQt exposes QQmlApplicationEngine.warnings as a signal rather than a
        # callable, so capture anything emitted while the engine loads.
        def _collect_warnings(errors):
            collected_warnings.extend(errors)

        warnings_attr.connect(_collect_warnings)

    qml_file = gallery_dir / "main.qml"
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        warnings_list = collected_warnings
        if not warnings_list and callable(warnings_attr):
            try:
                warnings_list = list(warnings_attr())
            except TypeError:
                warnings_list = []

        for warning in warnings_list:
            print(warning.toString())
        return -1

    exec_fn: Callable[[], int]
    if hasattr(app, "exec"):
        exec_fn = app.exec  # type: ignore[attr-defined]
    else:
        exec_fn = app.exec_  # type: ignore[attr-defined]

    return exec_fn()


if __name__ == "__main__":
    sys.exit(main())
