#!/usr/bin/env bash
# Kapture 一键安装脚本(Kubuntu / Ubuntu, X11 会话)
# 用法:bash install.sh
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "==> 安装目录: $DIR"

# 1) 系统依赖:Tesseract OCR 引擎 + 中文语言包 + 录屏(需要 sudo)
echo "==> 安装系统依赖(需要输入密码)..."
sudo apt update
sudo apt install -y tesseract-ocr tesseract-ocr-chi-sim tesseract-ocr-chi-tra \
                    python3-venv fonts-noto-cjk ffmpeg

# 2) Python 虚拟环境 + 依赖(不污染系统 Python)
echo "==> 创建虚拟环境并安装 Python 依赖..."
python3 -m venv "$DIR/.venv"
"$DIR/.venv/bin/python" -m pip install --upgrade pip -q
"$DIR/.venv/bin/python" -m pip install -q \
    PyQt5 mss opencv-python-headless numpy pillow pynput pytesseract

# 3) 启动器可执行权限
chmod +x "$DIR/run.sh" "$DIR/kapture.py"

# 4) 注册到应用菜单(名称/图标由程序按界面语言自动维护)
APP_DIR="$HOME/.local/share/applications"
mkdir -p "$APP_DIR"
cat > "$APP_DIR/kapture.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Kapture
GenericName=Screenshot / OCR / Recording
Comment=Scrolling screenshot, OCR, annotation and recording
Exec=$DIR/run.sh
Icon=$DIR/kapture.png
Terminal=false
StartupWMClass=kapture
Categories=Graphics;Utility;
Keywords=screenshot;ocr;scroll;capture;录屏;截图;
EOF
update-desktop-database "$APP_DIR" 2>/dev/null || true

echo ""
echo "✅ 安装完成!在应用菜单搜 'Kapture' 打开,或运行: $DIR/run.sh"
