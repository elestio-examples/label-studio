#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
# echo "Waiting for software to be ready ..."
sleep 60s;



target=$(docker-compose port nginx 8085)

url="http://${target}/user/signup"

# Perform curl request and capture the csrftoken cookie value
csrftoken=$(curl -s -i "$url" | grep -i 'Set-Cookie: csrftoken=' | awk '{split($0,a,";"); print a[1]}' | awk '{split($0,b,"="); print b[2]}')

# Print out the captured csrftoken value
echo "csrftoken value: $csrftoken"

curl 'http://'${target}'/user/signup/?&next=/projects/' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H $'cookie: csrftoken='${csrftoken}';' \
  -H 'pragma: no-cache' \
  -H 'priority: u=0, i' \
  -H 'sec-ch-ua: "Google Chrome";v="125", "Chromium";v="125", "Not.A/Brand";v="24"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
  --data-raw 'csrfmiddlewaretoken='${csrftoken}'&email='${ADMIN_EMAIL}'&password='${ADMIN_PASSWORD}'&allow_newsletters=true&allow_newsletters_visual=on'

rm -rf ./base.py

sed -i "s~- ./base.py:/label-studio/label_studio/base.py~~g" ./docker-compose.yml

docker-compose down;
docker-compose up -d;