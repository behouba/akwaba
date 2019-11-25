package web

import (
	"github.com/behouba/akwaba/web/api"
	"github.com/behouba/akwaba/web/site"

	"github.com/gin-gonic/gin"

	"github.com/behouba/akwaba"
)

// Setup setup the website with api and return *gin.Engine that can be used later as handler
func Setup(
	authenticator akwaba.TokenService, locationService akwaba.LocationService,
	pricingService akwaba.PricingService, accountStorage akwaba.AccountStore,
	orderStorage akwaba.OrderStore, tracker akwaba.Tracker,
	templatesPath, assetsPath string,
) (*gin.Engine, error) {

	engine := gin.Default()

	err := site.SetupWebsiteEngine(
		engine, locationService, pricingService,
		accountStorage, orderStorage, tracker,
		templatesPath, assetsPath,
	)
	if err != nil {
		return nil, err
	}

	err = api.SetupAPIEngine(
		engine, authenticator, locationService, pricingService,
		accountStorage, orderStorage, tracker,
	)
	if err != nil {
		return nil, err
	}
	return engine, nil
}
