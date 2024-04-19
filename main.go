package main

import (
	"context"
	"log"
	"net"
	"net/http"

	"github.com/jackc/pgx/v5"
	"suah.dev/starpub/data"
)

var ()

func logger(f http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s\n", r.URL.Path)
		f(w, r)
	}
}

func makeHandler(q *data.Queries, ctx context.Context) func(w http.ResponseWriter, r *http.Request) {
	return nil
}

func main() {
	pd, err := pgx.Connect(
		context.Background(),
		"host=localhost dbname=postgres sslmode=disable password=''",
	)
	if err != nil {
		log.Fatal(err)
	}
	base := data.New(pd)

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	mux := http.NewServeMux()
	mux.HandleFunc("/user/auth", logger(makeHandler(base, ctx)))

	mux.HandleFunc("POST /stars", logger(nil))
	mux.HandleFunc("DELETE /stars", logger(nil))

	mux.HandleFunc("GET /{user}", logger(nil))
	mux.HandleFunc("GET /{user}.rss", logger(nil))

	s := http.Server{
		Handler: mux,
	}

	lis, err := net.Listen("tcp", ":8080")
	if err != nil {
		log.Fatal(err)
	}
	s.Serve(lis)
}
