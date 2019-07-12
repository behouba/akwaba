package postgres

import (
	"context"
	"database/sql"
	"errors"
	"log"

	"strings"

	"github.com/behouba/akwaba"
	"github.com/jmoiron/sqlx"
	"googlemaps.github.io/maps"
)

type PricingStorage struct {
	db     *sqlx.DB
	apiKey string
}

func NewPricingStorage(db *sqlx.DB, key string) *PricingStorage {
	return &PricingStorage{db: db, apiKey: key}
}

func (c *PricingStorage) Cost(from, to string, categoryId uint8) (cost uint, distance float64, err error) {
	log.Println(to, from, categoryId)
	var minCost, maxCost float64
	err = c.db.QueryRow(
		"SELECT min_cost, max_cost FROM shipment_categories WHERE shipment_category_id=$1",
		categoryId,
	).Scan(&minCost, &maxCost)
	if err != nil {
		return
	}
	if from == to {
		cost = uint(minCost)
		return
	}
	distance, err = c.distance(from, to)
	if err != nil {
		return
	}
	if distance <= 0 || distance > 100 {
		return 0, 0, errors.New("Cette distance n'est pas supporté par notre système")
	}
	if distance <= 7 {
		cost = uint(minCost)
		return
	}
	cost = uint((distance * maxCost / 100) + minCost)
	return
}

// calculate distance between to place with google place directions api
func (c *PricingStorage) distance(from, to string) (distance float64, err error) {
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

func (c *PricingStorage) FindArea(query string) (areas []akwaba.Area) {
	var rows *sql.Rows
	var err error

	queryArr := strings.Split(query, " ")

	if len(queryArr) == 1 {
		rows, err = c.db.Query(
			`SELECT area_id, name, city_id FROM areas 
			WHERE name ILIKE '%' || $1 || '%' LIMIT 10`,
			query,
		)
		if err != nil {
			return
		}
	} else if len(queryArr) > 1 {
		rows, err = c.db.Query(
			`SELECT area_id, name, city_id FROM areas 
			WHERE name ILIKE '%' || $1 || '%' OR name ILIKE '%' || $2 || '%' LIMIT 10`,
			queryArr[0], queryArr[1],
		)
		if err != nil {
			return
		}
	}

	for rows.Next() {
		var a akwaba.Area
		err = rows.Scan(&a.ID, &a.Name, &a.CityID)
		if err != nil {
			continue
		}
		areas = append(areas, a)
	}
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
