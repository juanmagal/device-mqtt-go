package driver

import (

    "time"

    "fmt"

    metrics "github.com/cactus/go-statsd-client/statsd"

)


// Init statsd
func StartMetrics(host string, port string) (metrics.Statter,error) {


        client, err := metrics.NewBufferedClient(host+":"+port, "edgex",10*time.Millisecond, 0)

        // handle any errors
        if err != nil {
           return client,fmt.Errorf("Could not connect to metrics server: %v", err.Error())
        }

        return client, err

}






