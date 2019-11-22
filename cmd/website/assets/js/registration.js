// axios.defaults.timeout = 60000;
const dictionary = {
    en: {
        custom: {
            lastName: {
                required: 'Veuillez saisir votre nom.',
                min: 'Votre nom ne peut pas être trop court',
            },
            firstName: {
                required: 'Veuillez saisir votre prénom.',
                min: 'Votre prénom ne peut pas être trop court',
            },
            email: {
                required: 'Veuillez saisir une adresse e-mail valide',
                email: 'Veuillez saisir une adresse e-mail valide',
            },
            phone: {
                length: 'Veuillez saisir un numéro de téléphone valide',
            },
            password: {
                required: 'Votre mot de passe doit contenir au moins 4 caractères',
                min: 'Votre mot de passe doit contenir au moins 4 caractères'
            }
        }
    }
}

Vue.options.delimiters = ['{', '}'];
Vue.use(VeeValidate, {
    mode: 'lazy',
    events: 'blur',
    dictionary: dictionary,
});
// action="/auth/registration" method="POST"

var registrationApp = new Vue({
    el: "#registration-app",
    data() {
        return {
            loading: false,
        }
    },
    methods: {
        showPassword() {
            var x = document.getElementById("password")
            x.type = x.type == 'password' ? "text" : "password";
        },
        async sendRegistration() {
            const isValid = await this.$validator.validate();

            if (!isValid) {
                return
            }

            $("#registrationForm").submit();
            this.loading = false;
        }
    },
})