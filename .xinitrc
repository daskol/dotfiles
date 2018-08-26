# Обновить конфигурацию приложений из ресурсного файлы
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

/etc/X11/xinit/xinitrc.d/50-systemd-user.sh

while true; do
    BATTERY=$(acpi -b | awk '{ print $4 }' | tr ',' ' ')
    DATE=$(date +'%F %R')
    xsetroot -name "Bat: $BATTERY $DATE"
    sleep 20s    # Время обновления
done &

# Стартуем оконный менеджер
#exec awesome
xbindkeys
exec dwm
