package main

import (
	"flag"
	"fmt"
	"math/rand"
	"os"
	"time"

	"golang.org/x/term"
)

var (
	SHORT_CHARS = []string{
		"@", "^", "&", "*", "(",
		")", "-", "_", "=", "[",
		"]", "{", "}", "\\", "|",
		";", ":", "'", "\"",
	}
	ADDITIONAL_CHARS = []string{
		"!", "#", "$", "%", "<", ">", "/", "?",
	}
)

var (
	SHORT_MODE = flag.Bool("short", false, "")
)

func main() {
	flag.Parse()

	score := 0

	rand.Seed(time.Now().UnixNano())

	file, err := os.OpenFile("failure.csv", os.O_APPEND|os.O_WRONLY, 0644)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	oldState, err := term.MakeRaw(int(os.Stdin.Fd()))
	if err != nil {
		panic(err)
	}
	defer term.Restore(int(os.Stdin.Fd()), oldState)

	var chars []string
	if *SHORT_MODE {
		chars = SHORT_CHARS
	} else {
		chars = append(SHORT_CHARS, ADDITIONAL_CHARS...)
	}
	rand.Seed(time.Now().UnixNano())
	rand.Shuffle(len(chars), func(i, j int) { chars[i], chars[j] = chars[j], chars[i] })

	started := time.Now()
	for _, char := range chars {
		if test(char[0], file) {
			score++
		}
	}
	elapsed := time.Since(started)

	fmt.Print("=========\r\n")
	fmt.Printf("%d %%\r\n", (score*100)/len(chars))
	fmt.Printf("%.2f seconds\r\n", elapsed.Seconds())
}

func test(expected uint8, file *os.File) bool {
	fmt.Print(string(expected) + "\r\n")

	buf := make([]byte, 1)
	_, err := os.Stdin.Read(buf)
	if err != nil {
		fmt.Print("Input error\r\n")
		return false
	}

	input := rune(buf[0])

	if input != rune(expected) {
		fmt.Fprintf(
			file, "%c,%c,%v\n", expected, input, time.Now().Format("2006-01-02 15:04:05"),
		)

		fmt.Printf("%c Missed!!!\r\n", input)
		return false
	}

	return true
}
