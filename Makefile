build:
	docker build -t panubo/gcsproxy .

push:
	docker push panubo/gcsproxy:latest

run:
	-docker rm -f gcsproxy
	docker run -d --name gcsproxy -p 80:80 panubo/gcsproxy
