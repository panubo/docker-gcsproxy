DATE = $(shell date +%Y%m%d)

build:
	docker build -t panubo/gcsproxy:develop .

push:
	docker tag panubo/gcsproxy:develop panubo/gcsproxy:$(DATE)
	docker tag panubo/gcsproxy:develop panubo/gcsproxy:latest
	docker push panubo/gcsproxy:$(DATE)
	docker push panubo/gcsproxy:latest

run:
	-docker rm -f gcsproxy
	docker run -d --name gcsproxy -p 80:80 panubo/gcsproxy
