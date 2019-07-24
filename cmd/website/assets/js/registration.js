// axios.defaults.timeout = 60000;
const dictionary = {
    en: {
        custom: {
            name: {
                required: 'Veuillez saisir votre nom et prénom.',
                min: 'Votre nom et prénom ne peuvent pas être trop courts',
            },
            phone: {
                required: 'Veuillez saisir un numéro de mobile valide',
                length: 'Veuillez saisir un numéro de mobile valide',
            },
            email: {
                required: 'Veuillez saisir une adresse e-mail valide',
                email: 'Veuillez saisir une adresse e-mail valide',
            },
            password: {
                required: 'Votre mot de passe doit contenir au moins 4 caractères',
                min: 'Votre mot de passe doit contenir au moins 4 caractères'
            },
            password2: {
                is: 'Les mots de passe saisis ne sont pas identiques.',
            }
        }
    }
}

Vue.options.delimiters = ['{', '}'];
Vue.use(VueTheMask)
Vue.use(VeeValidate, {
    mode: 'lazy',
    events: 'blur',
    dictionary: dictionary,
});
// action="/auth/registration" method="POST"

function User() {
    return {
        fullName: null,
        email: null,
        phone: null,
        password: null,
    }
}
var registrationApp = new Vue({
    el: "#registration-app",
    data() {
        return {
            user: User(),
            confirmPassword: null,
            loading: false,
            error: null,
        }
    },
    methods: {
        sendRegistration: async function () {
            const isValid = await this.$validator.validate();

            if (!isValid) {
                return
            }

            this.loading = true;
            try {
                let response = await axios.post("/auth/registration", this.user);
                console.log(response);
                const splitedURL = window.location.href.split('redirect=')
                window.location.href = splitedURL.length > 1 ? splitedURL[1] : '/';
            } catch (error) {
                console.log(error.response)
                if (error.response) {
                    var status = error.response.status;
                    if (status === 401) {
                        this.error = error.response.data.message;
                        return
                    }
                    this.user = error.response.data.user;
                    console.log(error.response);
                } else if (error.request) {
                    console.log(error.request);
                } else {
                    // Something happened in setting up the request and triggered an Error
                    console.log('Error', error.message);
                }
            }
            this.loading = false;
        }
    },
})