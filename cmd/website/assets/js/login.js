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

var loginApp = new Vue({
    el: "#login-app",
    data() {
        return {
            email: null,
            password: null,
            loading: false,
            error: null,
            redirectPath: null,
        }
    },
    methods: {
        sendRegistration: async function () {
            this.loading = true;
            const isValid = await this.$validator.validate();

            if (!isValid) {
                this.error = null;
                this.loading = false
                return
            }
            $("#loginForm").submit();

        },
    },
    created() {
        const splitedURL = window.location.href.split('redirect=')
        this.redirectPath = splitedURL.length > 1 ? '?redirect=' + splitedURL[1] : '';
    }
})