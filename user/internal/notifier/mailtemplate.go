package notifier

const registrationTemplateFormat = `
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr"> 
<head>
<style type="text/css">
.link:link, .link:active, .link:visited {
	  color:#b02025 !important;
	  text-decoration:none !important;
}

.link:hover {
	  color:#b02025 !important;
	  text-decoration:none !important;
}
</style>
<title></title>
</head>
<body>
<table dir="ltr">
	 <tr><td id="i1" style="padding:0; font-family:'Segoe UI Semibold', 'Segoe UI Bold', 'Segoe UI', 'Helvetica Neue Medium', Arial, sans-serif; font-size:17px; color:#707070; padding-top: 25px;">Vous êtes inscrit sur le site Web de Akwaba Express.
Cliquez sur le bouton ci-dessous pour confirmer votre adresse email.</td></tr>
	 <tr><td style="padding:0; padding-top:25px; font-family:'Segoe UI', Tahoma, Verdana, Arial, sans-serif; font-size:14px; color:#b02025;">
		<table border="0" cellspacing="0"><tr><td bgcolor="#b02025" style="background-color:#b02025; padding-top: 5px; padding-right: 20px; padding-bottom: 5px; padding-left: 20px; min-width:50px;"><a id="i5" style="font-family: 'Segoe UI Semibold', 'Segoe UI Bold', 'Segoe UI', 'Helvetica Neue Medium', Arial, sans-serif; font-size:14px; text-align:center; text-decoration:none; font-weight:600; letter-spacing:0.02em; color:#fff;" href="%s">Confirmer <span dir="ltr">%s</span></a></td></tr></table>
	 </td></tr>
 <tr><td style="padding:0; padding-top:25px; font-family:'Segoe UI', Tahoma, Verdana, Arial, sans-serif; font-size:12px; color:#2a2a2a;">Si vous ne vous êtes pas inscrit sur le site Web de Akwaba Express, ignorez simplement cet email.</td></tr>
	 <tr><td style="padding:0; padding-top:25px; font-family:'Segoe UI', Tahoma, Verdana, Arial, sans-serif; font-size:14px; color:#2a2a2a;">Merci,</td></tr>
	 <tr><td id="i8" style="padding:0; font-family:'Segoe UI', Tahoma, Verdana, Arial, sans-serif; font-size:14px; color:#2a2a2a;">L'equipe technique Akwaba Express</td></tr>
</table>
</body>
</html>
`

const passwordChangeEmail = `
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr"> 
<head>
<style type="text/css">
.link:link, .link:active, .link:visited {
	  color:#b02025 !important;
	  text-decoration:none !important;
}

.link:hover {
	  color:#b02025 !important;
	  text-decoration:none !important;
}

</style>
<title></title>
</head>
<body>
<table dir="ltr">
	 <tr><td id="i1" style="padding:0; font-family:'Segoe UI Semibold', 'Segoe UI Bold', 'Segoe UI', 'Helvetica Neue Medium', Arial, sans-serif; font-size:17px; color:#70707; padding-top: 25px;">Bonjour %s,</td></tr>
 
	   <tr><td id="i1" style="padding:0; font-family:'Segoe UI Semibold', 'Segoe UI Bold', 'Segoe UI', 'Helvetica Neue Medium', Arial, sans-serif; font-size:14px; color:#70707; padding-top: 25px;">Nous avons reçu une demande de réinitialisation de votre mot de passe Akwaba Express.</td></tr>
   <tr><td style="padding:0; padding-top:25px; font-family:'Segoe UI', Tahoma, Verdana, Arial, sans-serif; font-size:12px; color:#2a2a2a;">Si vous n'avez pas démandé de réinitialisation de votre mot de passe, ignorez simplement cet email.</td></tr>
	 <tr><td style="padding:0; padding-top:25px; font-family:'Segoe UI', Tahoma, Verdana, Arial, sans-serif; font-size:14px; color:#b02025;">
		<table border="0" cellspacing="0"><tr><td bgcolor="#b02025" style="background-color:#b02025; padding: 10px; border-radius: 5px; min-width:50px;"><a id="i5" style="font-family: 'Segoe UI Semibold', 'Segoe UI Bold', 'Segoe UI', 'Helvetica Neue Medium', Arial, sans-serif; font-size:14px; text-align:center; text-decoration:none; font-weight:600; letter-spacing:0.02em; color:#fff;" href="%s">Créer un nouveau mot de passe</a></td></tr></table>
	 </td></tr>

	 <tr><td style="padding:0; padding-top:25px; font-family:'Segoe UI', Tahoma, Verdana, Arial, sans-serif; font-size:14px; color:#2a2a2a;">Merci,</td></tr>
	 <tr><td id="i8" style="padding:0; font-family:'Segoe UI', Tahoma, Verdana, Arial, sans-serif; font-size:14px; color:#2a2a2a;">L'equipe technique Akwaba Express</td></tr>
</table>
</body>
</html>
`
