package main

import (
	"io"
	"log"
	"net/http"
)

func parrot(w http.ResponseWriter, r *http.Request) {
	q := r.URL.Query()
	text := q.Get("message")
	if text == "" {
		io.WriteString(w, "send a message to echo using the 'message' query string parameter")
		return
	}
	io.WriteString(w, text)
}

func main() {
	log.Println("Starting server on :8080")
	http.HandleFunc("/", parrot)
	http.ListenAndServe(":8080", nil)
}
