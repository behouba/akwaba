package adminapi

import (
	"github.com/behouba/akwaba"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func getSessionUser(c *gin.Context) (emp akwaba.Employee) {
	s := sessions.Default(c)
	if s.Get("id") != nil {
		emp.ID = s.Get("id").(int)
	}
	if s.Get("name") != nil {
		emp.FullName = s.Get("name").(string)
	}
	if s.Get("officeID") != nil {
		emp.OfficeID = s.Get("officeID").(int)
	}
	return
}

func saveSessionUser(emp *akwaba.Employee, c *gin.Context) {
	s := sessions.Default(c)
	s.Set("id", emp.ID)
	s.Set("officeID", emp.OfficeID)
	s.Set("name", emp.FullName)
	s.Save()
}

func destroySessionUser(c *gin.Context) {
	s := sessions.Default(c)
	s.Delete("id")
	s.Delete("name")
	s.Save()
}
