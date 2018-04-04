# Обновить конфигурацию приложений из ресурсного файлы
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

while true; do
    xsetroot -name "$( date +'%F %R' )"
    sleep 20s    # Время обновления
done &

# Стартуем оконный менеджер
#exec awesome
xbindkeys
exec dwm
