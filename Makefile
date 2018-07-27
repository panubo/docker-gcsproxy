build:
	docker build -t panubo/gcsproxy .

run:
	docker run --rm -it -p 80:80 panubo/gcsproxy
