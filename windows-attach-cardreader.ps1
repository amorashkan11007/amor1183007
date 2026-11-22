# ============================================================
#  اتصال کارت‌خوان داخلی لپ‌تاپ به کالی WSL — در PowerShell با Administrator اجرا شود
# ============================================================

# 1) نصب usbipd-win (یک‌بار)
winget install --interactive --exact dorssel.usbipd-win

# 2) بعد از نصب، پنجره PowerShell Admin را دوباره باز کن و لیست دستگاه‌ها را ببین:
usbipd list
#    -> دنبال ردیفی بگرد که NAME آن "Smart Card Reader" یا "Alcor Micro" است
#       و ستون BUSID آن را یادداشت کن (مثلاً 2-4)

# 3) bind و attach همان دستگاه به WSL (BUSID را با مقدار خودت عوض کن):
usbipd bind --busid 2-4
usbipd attach --wsl --busid 2-4

# 4) بررسی:
usbipd wsl list

# 5) اگر بعداً خواستی جداش کنی:
# usbipd detach --busid 2-4

# ----------------- مشکلات رایج وای‌فای در WSL -----------------
# پرش وای‌فای داخل WSL معمولاً از DNS خود WSL است. در PowerShell Admin:

# resolv.conf ثابت در کالی:
#   در کالی بنویس:  printf 'nameserver 1.1.1.1\n' | sudo tee /etc/resolv.conf
#   و در /etc/wsl.conf اضافه کن:
#   [network]
#   generateResolvConf = false
#   بعد: wsl --shutdown

# آپدیت درایور بی‌سیم در ویندوز:
#   Invoke-CimMethod -Namespace root/cimv2 -ClassName Win32_PnPSignedDriver ...
#   ساده‌تر: Device Manager -> Network adapters -> WLAN -> Update driver
#   یا HP Support Assistant برای EliteBook 845 G9
