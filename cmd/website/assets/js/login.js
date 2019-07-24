// axios.defaults.timeout = 10000;
const dictionary = {
    en: {
        custom: {
            email: {
                required: 'Veuillez saisir une adresse e-mail valide',
                email: 'Veuillez saisir une adresse e-mail valide',
            },
            password: {
                required: 'Votre mot de passe doit contenir au moins 4 caractères',
                min: 'Votre mot de passe doit contenir au moins 4 caractères'
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
        email: null,
        password: null,
    }
}
var loginApp = new Vue({
    el: "#login-app",
    data() {
        return {
            user: User(),
            loading: false,
            error: null,
        }
    },
    methods: {
        redirectPath: function () {
            const splitedURL = window.location.href.split('redirect=')
            return splitedURL.length > 1 ? '?redirect=' + splitedURL[1] : '';
        },
        sendRegistration: async function () {
            this.loading = true;
            const isValid = await this.$validator.validate();

            if (!isValid) {
                this.error = null;
                this.loading = false
                return
            }

            try {
                let response = await axios.post("/auth/login", this.user);
                console.log(response);
                this.loading = false;
                this.error = null;
                if (response.status === 200) {
                    const splitedURL = window.location.href.split('redirect=')
                    window.location.href = splitedURL.length > 1 ? splitedURL[1] : '/';
                }
            } catch (error) {
                this.loading = false;
                console.log(error.response)
                if (error.response) {
                    var status = error.response.status;
                    if (status === 401 || status === 400) {
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
        }
    },
})