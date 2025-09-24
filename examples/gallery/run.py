"""Run the gallery QML demo with PySide6."""

from __future__ import annotations

import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def _resolve_paths() -> tuple[Path, Path]:
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
    engine.load(str(qml_file))

    if not engine.rootObjects():
        return -1

    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
