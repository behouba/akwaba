package postgres

import (
	"errors"

	"github.com/jmoiron/sqlx"
)

type Calculator struct {
	db *sqlx.DB
}

func NewCalculator(db *sqlx.DB) *Calculator {
	return &Calculator{db: db}
}

func (p *Calculator) Cost(d float64, categoryId uint) (cost uint, err error) {
	if d <= 0 || d > 100 {
		return 0, errors.New("Cette distance n'est pas supporté par notre système")
	}
	var minCost, maxCost float64
	err = p.db.QueryRow(
		"SELECT min_cost, max_cost FROM shipment_categories WHERE shipment_category_id=$1",
		categoryId,
	).Scan(&minCost, &maxCost)
	if err != nil {
		return
	}
	if d <= 7 {
		cost = uint(minCost)
		return
	}
	return uint((d * maxCost / 100) + minCost), nil
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
