#!bin/bash

WEBCODE='../../../application/client/web/testingapp'

COMPOSEPATH='../../../../devops/local/docker/'

ENVPATH='../../.env'


while getopts :cdrs option
do
    case "$option" in
    c)  
         echo "Creating new docker images and containers"
         cd $WEBCODE
         docker build -t testingappui-7610 .
         docker run --name testingappui-7610 --restart=unless-stopped -d -p 5055:80 testingappui-7610
         sleep 15
         echo "UI build is done..."

         cd $COMPOSEPATH
         NETWORK_NAME="testingapp_7610_net"
         if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
               echo "-------------------The network '$NETWORK_NAME' already exists----------------------"
         else
               docker network create $NETWORK_NAME
         fi
         sleep 5
         docker-compose up -d --build
         echo "uploading the mongo script..."
         sleep 80
         docker cp mongo.js mongo-7610:/data/db/
         docker exec -ti mongo-7610 mongo -u admin -p 'password' --authenticationDatabase 'admin' testingapp_7610 /data/db/mongo.js
         sleep 10
         echo "Process completed"
         echo " Your application is deployed here the link, http://localhost:5055 "
         ;;
    d)
         echo "Now Deleting all containers and images"
         docker-compose down -v --rmi all 
         docker rm -f testingappui-7610
         docker rmi testingappui-7610
         echo "Process completed"
         ;;
    r)
         echo "Now Re-starting the stopped containers"
         docker-compose start
         docker restart testingappui-7610
         sleep 35
         echo "Process completed"
         ;;
    s)
         echo "Now stopping the running containers"
         docker-compose stop
         docker stop testingappui-7610
         echo "Process completed"
         ;;
    *)
        echo "Hmm, an invalid option was received. the valid option are."
        echo "Flag c - To Create new containers and images."
        echo "Flag d - To Delete all the containers and images."
        echo "Flag r - To Restart the stopped containers."
        echo "Flag s - To Stop the running containers."
        echo "Here's the usage statement:"
        echo ""
        echo "bash geppetto_compose.sh -c (or) bash geppetto_compose.sh -d (or) bash geppetto_compose.sh -r (or) bash geppetto_compose.sh -s"
       
       ;;
        esac
done

echo ""
echo "These are the usage options for help."
echo "Flag c - To Create new containers and images."
echo "Flag d - To Delete all the containers and images."
echo "Flag r - To Restart the stopped containers."
echo "Flag s - To Stop the running containers."
echo "Here's the usage statement:"
echo ""
echo "bash geppetto_compose.sh -c (or) bash geppetto_compose.sh -d (or) bash geppetto_compose.sh -r (or) bash geppetto_compose.sh -s"
