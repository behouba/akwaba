package mail

import (
	"fmt"

	"github.com/matcornic/hermes/v2"
)

func akwabaButton(text, link string) hermes.Button {
	return hermes.Button{
		TextColor: "#ffffff",
		Color:     "#b02025",
		Text:      text,
		Link:      link,
	}
}

// email generation
func (c *CustomerMail) generateResetPasswordHTML(fullName, token string) (emailBody string, err error) {
	h := hermes.Hermes{
		// Optional Theme
		// Theme: new(Default)
		Product: hermes.Product{
			// Appears in header & footer of e-mails
			Name: companyName,
			Link: baseURL,
			// Optional product logo
			Logo:        logoURL,
			Copyright:   copyright,
			TroubleText: "Si le bouton ne fonctionne pas pour vous, copiez et collez l’URL ci-dessous dans votre navigateur Web.",
		},
	}
	email := hermes.Email{
		Body: hermes.Body{
			Greeting:  "Bonjour",
			Signature: "Merci",
			Name:      fullName,
			Intros: []string{
				"Nous avons reçu une demande de réinitialisation de votre mot de passe Akwaba Express.",
			},
			Actions: []hermes.Action{
				{
					Instructions: "Cliquez sur le bouton ci-dessous pour réinitialiser votre mot de passe:",
					Button:       akwabaButton("Réinitialiser", fmt.Sprintf("%s/auth/new-password-request?token=%s", baseURL, token)),
				},
			},
			Outros: []string{
				"Si vous n'avez pas démandé de réinitialisation de votre mot de passe, ignorez simplement cet email.",
			},
		},
	}

	emailBody, err = h.GenerateHTML(email)
	if err != nil {
		return
	}
	return
}

func (c *CustomerMail) generateWelcomeHTML(fullName string) (emailBody string, err error) {
	h := hermes.Hermes{
		// Optional Theme
		// Theme: new(Default)
		Product: hermes.Product{
			// Appears in header & footer of e-mails
			Name: companyName,
			Link: baseURL,
			// Optional product logo
			Logo:      logoURL,
			Copyright: copyright,
		},
	}
	email := hermes.Email{
		Body: hermes.Body{
			Greeting:  "Bonjour",
			Signature: "Merci",
			Name:      fullName,
			Intros: []string{
				"Nous sommes heureux de vous confirmer votre inscription sur Akwaba Express.",
				"Avec Akwaba Express, vous pouvez, sans bouger de chez vous, accéder à des services de livraison de documents et de colis en ligne.",
				"Nous vous remercions de votre confiance, et à très bientôt !",
			},
			Actions: []hermes.Action{
				{
					Instructions: "Commandez votre livraison en cliquant ici:",
					Button:       akwabaButton("Commander", "https://hermes-example.com/confirm?token=d9729feb74992cc3482b350163a1a010"),
				},
			},
		},
	}
	emailBody, err = h.GenerateHTML(email)
	if err != nil {
		return
	}
	return
}
