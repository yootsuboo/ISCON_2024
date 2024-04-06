package main

import (
    crand "crypto/rand"
    "fmt"
    "html/template"
)

var (
    db *sqlx.DB
    store *gsm.MemcacheStore
)

const (
    postsPerPage = 20
    ISO8601Format = "2006-01-02T15:04:05-07:00"
    UploadLimit = 10 * 1024 * 1024 // 10mb
)

type User struct {
    ID int `db:"id"`
    AccountName string `db:"account_name"`
    Passhash string `db:"passhash"`
    Autority int `db:"authority"`
    DelFlg int `db:"del_flg"`
    CreatedAt time.Time `db:"created_at"`
}

