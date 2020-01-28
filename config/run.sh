#!sh
echo "Starting run.sh"

mv /var/www/html/config/crontab.default /var/www/html/config/crontab
if [[ ${CRONJOB_ITERATION} ]]; then
    sed -i -e "s/0/*\/${CRONJOB_ITERATION}/g" /var/www/html/config/crontab
fi
crontab /var/www/html/config/crontab
if ! [ -f "/var/www/html/data/result.csv"]; then
    touch /var/www/html/data/result.csv
    echo "timestamp,ping,download,upload" > /var/www/html/data/result.csv
fi


echo "Starting Cronjob"
crond -l 2 -f &

echo "Starting webserver"
/usr/local/openresty/bin/openresty -g daemon off