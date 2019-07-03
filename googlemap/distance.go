package googlemap

import (
	"context"

	"googlemaps.github.io/maps"
)

type DistanceAPI struct {
	apiKey string
}

func NewDistanceAPI(key string) *DistanceAPI {
	return &DistanceAPI{apiKey: key}
}

func (d *DistanceAPI) CalculateDistance(from, to string) (distance float64, err error) {
	c, err := maps.NewClient(maps.WithAPIKey(d.apiKey))
	if err != nil {
		return
	}
	r := &maps.DirectionsRequest{
		Origin:      from,
		Destination: to,
		Language:    "fr",
		Region:      "ci",
	}
	route, _, err := c.Directions(context.Background(), r)
	if err != nil {
		return
	}
	distance = float64(route[0].Legs[0].Distance.Meters) / 1000
	return
}
