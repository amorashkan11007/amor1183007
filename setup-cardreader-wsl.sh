#!/usr/bin/env bash
# ============================================================
#  راه‌اندازی کارت‌خوان داخلی HP EliteBook 845 G9 در کالی (WSL2)
#  این اسکریپت فقط سمت کالی/WSL را انجام می‌دهد.
#  مرحله اتصال USB باید در PowerShell ویندوز (Admin) انجام شود.
# ============================================================
set -u

echo "[1/4] نصب پکیج‌های PC/SC ..."
sudo apt update
sudo apt install -y pcscd pcsc-tools libccid usbipd smartcard-tools

echo
echo "[2/4] فعال‌سازی systemd در WSL (اگر قبلاً فعال نشده) ..."
WSLCONF="/etc/wsl.conf"
if grep -q '^\[systemd\]' "$WSLCONF" 2>/dev/null && grep -A2 '^\[systemd\]' "$WSLCONF" | grep -q 'systemd=true'; then
    echo "systemd از قبل فعال است."
else
    printf '\n[boot]\nsystemd=true\n' | sudo tee -a "$WSLCONF" >/dev/null
    echo ">>> systemd اضافه شد. برای اعمال:"
    echo ">>>    1) در PowerShell ویندوز:  wsl --shutdown"
    echo ">>>    2) دوباره وارد کالی شو و این اسکریپت را یک بار دیگر اجرا کن"
fi

echo
echo "[3/4] راه‌اندازی سرویس pcscd ..."
if pidof systemd >/dev/null 2>&1; then
    sudo systemctl daemon-reload
    sudo systemctl enable --now pcscd.socket pcscd
    systemctl status pcscd --no-pager | head -5
else
    echo "systemnd در حال اجرا نیست -> اجرای دستی pcscd در پس‌زمینه"
    pgrep pcscd >/dev/null || sudo pcscd -b
fi

echo
echo "[4/4] بررسی نهایی ..."
echo "--- lsusb (باید Alcor Micro / Smart Card Reader دیده شود):"
lsusb | grep -iE 'alcor|smart|card' || echo "  !! هیچ کارت‌خوانی در lsusb نیست -> مرحله usbipd در ویندوز هنوز انجام نشده"
echo
echo "برای تست، کارت بانکی را وارد کن و بزن:"
echo "    pcsc_scan"
