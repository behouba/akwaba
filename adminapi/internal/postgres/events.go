package postgres

import "log"

func (a *AdminDB) recordActivity(summary string) (err error) {
	_, err = a.db.Exec(
		`INSERT INTO activity (summary) VALUES ($1)`,
		summary,
	)
	if err != nil {
		log.Println(err)
	}
	return
}
