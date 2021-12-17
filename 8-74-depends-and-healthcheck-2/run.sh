docker-compose pull
echo ------------------------------------------------------------
docker-compose build
echo ------------------------------------------------------------
docker-compose up -d

echo ------------------------------------------------------------

read -p "clean up ? [y/n]:" flag
case $flag in
    [yY])
        ./clean.sh ;;
    *)
        ;;
esac


