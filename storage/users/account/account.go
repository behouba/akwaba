package account

import (
	"context"
	"database/sql"
	"errors"
	"log"
	"time"

	"github.com/behouba/akwaba"
	"golang.org/x/crypto/bcrypt"
)

const (
	duplicatePhoneErr  = "Un compte avec ce téléphone existe déjà"
	duplicateEmailErrr = "Un compte avec cette adresse e-mail existe déjà"
	invalidLoginErr    = "Nom d’utilisateur ou mot de passe incorrect"
)

func (u *accountStatements) insertUser(ctx context.Context, user *akwaba.User) (err error) {
	passwordHash, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.MinCost)
	if err != nil {
		return
	}
	err = u.insertUserStmt.QueryRowContext(
		ctx, user.FirstName, user.LastName, user.Phone, user.Email, string(passwordHash),
	).Scan(&user.ID)
	if err != nil {
		if err.Error() == keyDuplicationError("users_email_key") {
			err = errors.New(duplicateEmailErrr)
			return
		} else if err.Error() == keyDuplicationError("users_phone_key") {
			err = errors.New(duplicatePhoneErr)
			return
		}
		log.Println(err)
		err = errors.New("Erreur interne du serveur")
	}
	return
}

func (u *accountStatements) selectUserByEmail(ctx context.Context, email string) (user akwaba.User, err error) {
	err = u.selectUserByEmailStmt.QueryRowContext(ctx, email).Scan(
		&user.ID, &user.FirstName, &user.LastName, &user.Email, &user.Phone, &user.Password,
	)
	if err == sql.ErrNoRows {
		err = errors.New("L'email saisi est inconnu")
		return
	}
	return
}

func (u *accountStatements) updateUserPassword(
	ctx context.Context, userID uint, currentPassowrd, newPassword string,
) (err error) {
	var hashedPassword string

	err = u.selectUserPasswordStmt.QueryRowContext(ctx, userID).Scan(&hashedPassword)
	if err != nil {
		return
	}

	err = bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(currentPassowrd))
	if err != nil {
		err = errors.New("Mot de passe actuel incorrect")
		return
	}

	newHashedPassword, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.MinCost)
	if err != nil {
		return
	}
	_, err = u.updateUserPasswordStmt.ExecContext(ctx, newHashedPassword, userID)
	return
}

func (u *accountStatements) updateUserInfo(ctx context.Context, user *akwaba.User) (err error) {
	err = u.saveOldDataBeforeUpdate(ctx, user.ID)
	if err != nil {
		return
	}
	_, err = u.updateUserDataByUserIDStmt.ExecContext(
		ctx, user.FirstName, user.LastName, user.Phone, user.ID,
	)
	if err != nil {
		log.Println(err)
		err = errors.New("Erreur interne de mis à jour du profil")
		return
	}
	return
}

func (u *accountStatements) saveOldDataBeforeUpdate(ctx context.Context, userID uint) (err error) {
	var user akwaba.User
	err = u.selectUserByIDStmt.QueryRowContext(
		ctx, userID,
	).Scan(&user.FirstName, &user.LastName, &user.Phone)
	if err != nil {
		return
	}
	_, err = u.insertOldUserDataStmt.ExecContext(
		ctx, userID, user.FirstName, user.LastName, user.Phone,
	)
	if err != nil {
		return
	}
	return
}

func (u *accountStatements) authenticate(ctx context.Context, email, password, ip string) (user akwaba.User, err error) {
	var passwordHash string
	err = u.selectUserByEmailStmt.QueryRowContext(
		ctx, email,
	).Scan(
		&user.ID, &user.FirstName, &user.LastName,
		&user.Email,
		&user.Phone, &passwordHash,
	)
	if err != nil {
		user.Password = password
		if err == sql.ErrNoRows {
			err = errors.New(invalidLoginErr)
		}
		return
	}
	err = bcrypt.CompareHashAndPassword([]byte(passwordHash), []byte(password))
	if err != nil {
		user.Password = password
		err = errors.New(invalidLoginErr)
		return
	}

	// record login to database
	_, err = u.insertAccessHistoryStmt.ExecContext(ctx, user.ID, ip)
	if err != nil {
		log.Println(err)
	}
	return
}

func (u *accountStatements) setRecoveryToken(ctx context.Context, email string) (token string, err error) {
	unixTimeString := string(time.Now().Unix())

	bs, err := bcrypt.GenerateFromPassword([]byte(unixTimeString), bcrypt.DefaultCost)
	if err != nil {
		return
	}
	token = string(bs)
	_, err = u.updateRecoveryTokenStmt.ExecContext(ctx, token, email)
	return
}

func (u *accountStatements) checkRecoveryToken(ctx context.Context, token string) (userID uint, err error) {
	err = u.selectRecoveryTokenFromUserIDStmt.QueryRowContext(ctx, token).Scan(&userID)
	return
}

func (u *accountStatements) saveNewPassword(ctx context.Context, userID uint, token, newPassword string) (err error) {
	hp, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.MinCost)
	if err != nil {
		return
	}
	_, err = u.updateUserPasswordStmt.ExecContext(ctx, string(hp), userID)
	if err != nil {
		return
	}
	_, err = u.updateRecoveryTokenToNullStmt.ExecContext(ctx, userID)
	if err != nil {
		log.Println(err)
		// don't care about this error
		err = nil
	}
	return
}

func keyDuplicationError(key string) string {
	return `pq: duplicate key value violates unique constraint "` + key + `"`
}
