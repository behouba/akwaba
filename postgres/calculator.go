package postgres

import (
	"context"
	"errors"

	"github.com/jmoiron/sqlx"
	"googlemaps.github.io/maps"
)

type Calculator struct {
	db     *sqlx.DB
	apiKey string
}

func NewCalculator(db *sqlx.DB, key string) *Calculator {
	return &Calculator{db: db, apiKey: key}
}

func (c *Calculator) Cost(from, to string, categoryId uint8) (cost uint, distance float64, err error) {
	distance, err = c.distance(from, to)
	if err != nil {
		return
	}
	if distance <= 0 || distance > 100 {
		return 0, 0, errors.New("Cette distance n'est pas supporté par notre système")
	}
	var minCost, maxCost float64
	err = c.db.QueryRow(
		"SELECT min_cost, max_cost FROM shipment_categories WHERE shipment_category_id=$1",
		categoryId,
	).Scan(&minCost, &maxCost)
	if err != nil {
		return
	}
	if distance <= 7 {
		cost = uint(minCost)
		return
	}
	cost = uint((distance * maxCost / 100) + minCost)
	return
}

// calculate distance between to place with google place directions api
func (c *Calculator) distance(from, to string) (distance float64, err error) {
	client, err := maps.NewClient(maps.WithAPIKey(c.apiKey))
	if err != nil {
		return
	}
	r := &maps.DirectionsRequest{
		Origin:      from,
		Destination: to,
		Language:    "fr",
		Region:      "ci",
	}
	route, _, err := client.Directions(context.Background(), r)
	if err != nil {
		return
	}
	distance = float64(route[0].Legs[0].Distance.Meters) / 1000
	return
}

//     var price;
//     if (d <= 0 || d > 60 || isNaN(d)) {
//         throw 'Distance invalide';
//     }

//     if (d < 6) {
//         switch (Number(weightSelect.val())) {
//             case 1:
//                 price = ShipmentCategoryA.pMin;
//                 break;
//             case 2:
//                 price = ShipmentCategoryB.pMin;
//                 break;
//             case 3:
//                 price = ShipmentCategoryC.pMin;
//                 break;
//             default:
//                 throw 'Interval de poids invalide'
//         }
//     } else {
//         switch (Number(weightSelect.val())) {
//             case 1:
//                 price = (d * ShipmentCategoryA.pMax / 100) + ShipmentCategoryA.pMin;
//                 break;
//             case 2:
//                 price = (d * ShipmentCategoryB.pMax / 100) + ShipmentCategoryB.pMin;
//                 break;
//             case 3:
//                 price = (d * ShipmentCategoryC.pMax / 100) + ShipmentCategoryC.pMin;
//                 break;
//             default:
//                 throw 'Interval de poids invalide'
//         }
//     }
//     orderSummaryApp.price = Math.ceil(price);
//     return price;
