# Ergonode development docker

This is only a development solution! Do not use it on production environments!

## How the hell should I install it all ?!

At first you must install Docker and Docker Compose (https://docs.docker.com/compose).

Next, you must clone frontend and backend repositories to ergonode directory:

```bash
{path}/ergonode/backend
{path}/ergonode/docker
{path}/ergonode/frontend
```

Next, you will need to enter docker directory and copy ``.env.dist``

```bash
cp .env.dist .env
cp ../backend/.env.dist ../backend/.env
cp ../frontend/.env.dist ../frontend/.env
```

Edit copied env files. 

POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_PORT, POSTGRES_DB vars from the .env file  must match to var DATABASE_URL in the ../backend/.env
In DATABASE_URL please set host  for db as ergonode-postgres.
API_PORT env in the file ../frontend/.env.dist  must be set to 8001 


Remember to setup correct ports in backend and frontend application.

Now you can start start docker by simple command

```bash
bin/docker on
```

In terminal execute command which configure application (Available phing commands):
```
docker-compose exec ergonode-php bin/phing build
```

If you need basic data in terminal execute command:
```
docker-compose exec ergonode-php bin/phing database:fixture
```

To execute other backend commands you can execute command:
```
docker-compose exec ergonode-php your command and parameters
```


Enjoy :)

## Ok, but what now?

if you want to view frontend panel just type address from below into your browser

```
http://localhost
```

if you want to view backend API doc just type address from below into your browser

```
http://locahost:8001/api/doc
```

If you want to review email messages from application, type address from below into your browser

```
http://localhost:8025
```

If you want to review messages on RabbitMQ, type address from below into your browser

```
http://localhost:15672
```

## What can i do with this creature?

If you want to start ergonode docker

```bash
bin/docker on
```

If you want to stop ergonode docker

```bash
bin/docker off
```

If you want to enter some container

```bash
docker exec -it "ergonode-php-dev" bash
docker exec -it "ergonode-postgres-dev" bash
docker exec -it "ergonode-node-dev" bash
```

## FAQ

```
Q: What data are stored?
A: For now only database in data folder
```

```
Q: Where can i change PHP settings?
A: In config/php/override.ini file
```

```
Q: What if I have better idea?
A: No problem ! Just tell us about your idea and we will discuse it. Bring lot of beers!
```

```
Q: This is awesome, how can i thank you?
A: No problem. Just send me an email to sebastian.bielawski@strix.net and attach a beer
```

```
Q: This is bullshit, how can i thank you for this crap?
A: No problem. Just send me an email to sebastian.bielawski@strix.net but don't forget attach a beer
```

