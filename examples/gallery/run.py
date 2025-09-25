"""Run the gallery QML demo with a Qt for Python binding."""

from __future__ import annotations

import sys
from pathlib import Path
from typing import Tuple

QT_BINDING = ""

try:  # Prefer PySide6 because it matches Qt's official Python binding.
    from PySide6.QtCore import QUrl
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlApplicationEngine

    QT_BINDING = "PySide6"
except ImportError as pyside_error:  # pragma: no cover - informative fallback path
    try:
        from PyQt6.QtCore import QUrl
        from PyQt6.QtGui import QGuiApplication
        from PyQt6.QtQml import QQmlApplicationEngine

        QT_BINDING = "PyQt6"
    except ImportError as pyqt_error:  # pragma: no cover - informative fallback path
        missing = ["PySide6", "PyQt6"]
        message = (
            "Unable to import any Qt for Python binding.\n"
            "Install one of the following packages and re-run the script:\n"
            f"  pip install {missing[0]}\n"
            f"  pip install {missing[1]}\n"
            "Alternatively run the example with qmlscene after exporting QML2_IMPORT_PATH.\n"
            f"PySide6 import error: {pyside_error}\n"
            f"PyQt6 import error: {pyqt_error}"
        )
        raise SystemExit(message) from pyqt_error


def _resolve_paths() -> Tuple[Path, Path]:
    """Return the gallery directory and qml import path."""
    gallery_dir = Path(__file__).resolve().parent
    repo_root = gallery_dir.parents[1]
    qml_dir = repo_root / "qml"
    return gallery_dir, qml_dir


def main() -> int:
    """Launch the QML gallery example."""
    gallery_dir, qml_dir = _resolve_paths()

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath(str(qml_dir))

    qml_file = gallery_dir / "main.qml"
    engine.load(QUrl.fromLocalFile(str(qml_file)))

    if not engine.rootObjects():
        return -1

    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
