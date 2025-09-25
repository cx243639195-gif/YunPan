"""Run the gallery QML demo with PySide6."""

from __future__ import annotations

import sys
from pathlib import Path
from typing import Callable, Tuple


def _load_binding():
    """Import PySide6 and expose a unified API surface."""

    try:
        from PySide6.QtCore import QUrl  # type: ignore
        from PySide6.QtGui import QGuiApplication  # type: ignore
        from PySide6.QtQml import QQmlApplicationEngine  # type: ignore

        return QUrl, QGuiApplication, QQmlApplicationEngine
    except ImportError as error:  # pragma: no cover - informative fallback path
        message = (
            "Unable to import PySide6.\n"
            "Please install the package and re-run the script:\n"
            "  pip install PySide6\n"
            f"Import error: {error}"
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

    QUrl, QGuiApplication, QQmlApplicationEngine = _load_binding()

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath(str(qml_dir))

    qml_file = gallery_dir / "main.qml"
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        warnings_attr = getattr(engine, "warnings", None)
        warnings_list = warnings_attr() if callable(warnings_attr) else []

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
