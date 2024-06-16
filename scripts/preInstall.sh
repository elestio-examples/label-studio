#set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./mydata
chown 1000:1000 ./mydata
chmod -R 777 ./mydata

cat <<EOT > ./servers.json
{
    "Servers": {
        "1": {
            "Name": "local",
            "Group": "Servers",
            "Host": "172.17.0.1",
            "Port": 58194,
            "MaintenanceDB": "postgres",
            "SSLMode": "prefer",
            "Username": "postgres",
            "PassFile": "/pgpass"
        }
    }
}
EOT

