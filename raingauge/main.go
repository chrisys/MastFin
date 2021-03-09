package main

import (
	"fmt"
	"os"
	"time"
	"net/http"

	"github.com/warthog618/gpiod"
	"github.com/warthog618/gpiod/device/rpi"

	"github.com/bep/debounce"
)

var counter int
var debounced = debounce.New(500 * time.Millisecond)

func main() {

	c, err := gpiod.NewChip("gpiochip0")
	if err != nil {
		panic(err)
	}
	defer c.Close()

	offset := rpi.J8p7
	l, err := c.RequestLine(offset,
		gpiod.WithEventHandler(trigger),
		gpiod.WithFallingEdge)
	if err != nil {
		fmt.Printf("RequestLine returned error: %s\n", err)
		os.Exit(1)
	}
	defer l.Close()

	fmt.Printf("Watching Pin %d...\n", offset)
	http.HandleFunc("/", count_server)
    http.ListenAndServe(":8000", nil)
}

func trigger(evt gpiod.LineEvent) {
	debounced(countone)
}

func countone() {
	counter++
	fmt.Printf("Tip! Count is now: %d\n", counter)
}

func count_server(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "{ \"tip_count\" : %d }", counter)
}