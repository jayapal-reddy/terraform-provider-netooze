package ssclient

import (
	"fmt"

	"github.com/go-resty/resty/v2"
)

var HOST_MAP = map[string]string{
	"02": "https://api.netooze.com",
	"04": "https://api.netooze.com",
	"06": "https://api.netooze.com",
	"07": "https://api.netooze.com",
	"08": "https://api.netooze.com",
	"09": "https://api.netooze.com",
	"0a": "https://api.netooze.com",
}

type SSClient struct {
	client *resty.Client
	Key    string
	Host   string
}

func NewClient(key string, host string) (*SSClient, error) {
	if host == "" {
		if len(key) < 2 {
			return nil, NewWrongKeyFormatError(nil)
		}

		var ok bool
		hostIndex := key[:2]
		if host, ok = HOST_MAP[hostIndex]; !ok {
			return nil, NewWrongKeyFormatError(nil)
		}
	}

	client := resty.New()
	client.SetHeader("X-API-KEY", key)

	baseURL := fmt.Sprintf("%s/%s", host, "api/v1/")
	client.SetHostURL(baseURL)

	return &SSClient{client, key, host}, nil
}
