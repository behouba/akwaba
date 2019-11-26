package akwaba

import "context"

type LocationService interface {
	Areas(ctx context.Context) []Area
	Offices(ctx context.Context) []Office
	SetAreaID(ctx context.Context, name string, id *uint) error
}
