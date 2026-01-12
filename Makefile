test:
	goenv exec go test -v ./...

build:
	GOOS=linux GOARCH=amd64 goenv exec go build -trimpath -ldflags '-s -w' -o bin/main_linux
	GOOS=darwin GOARCH=arm64 goenv exec go build -trimpath -ldflags '-s -w' -o bin/main_mac
	GOOS=windows GOARCH=amd64 goenv exec go build -trimpath -ldflags '-s -w' -o bin/main.exe

fmt:
	goenv exec go fmt ./...

lint:
	goenv exec go vet ./...

init-linux:
	if [ -e main ]; then \
		unlink main; \
	fi
	ln -s bin/main_linux main
	touch data/failure.csv data/full.csv data/short.csv

init-mac:
	if [ -e main ]; then \
		unlink main; \
	fi
	ln -s bin/main_mac main
	touch data/failure.csv data/full.csv data/short.csv

full:
	./main

short:
	./main -short=true

full-s:
	goenv exec go run exec.go

short-s:
	goenv exec go run exec.go -short=true
