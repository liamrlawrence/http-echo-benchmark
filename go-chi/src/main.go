package main

import (
	"encoding/json"
	"log"
	"net/http"
	"github.com/go-chi/chi/v5"
)

func main() {
	r := chi.NewRouter()

	r.Post("/api/echo", EchoHandler)

	log.Println("Server starting on :2000")
	http.ListenAndServe(":2000", r)
}

func EchoHandler(w http.ResponseWriter, r *http.Request) {
	var data map[string]interface{}

	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&data); err != nil {
		http.Error(w, "Invalid JSON", http.StatusBadRequest)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(data)
}

