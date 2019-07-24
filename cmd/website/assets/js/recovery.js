const dictionary = {
    en: {
        custom: {
            email: {
                required: 'Veuillez saisir une adresse e-mail valide',
                email: 'Veuillez saisir une adresse e-mail valide',
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
//  action="/auth/recovery" 
// action="/auth/registration" method="POST"

var recoveryApp = new Vue({
    el: "#recovery-app",
    data() {
        return {
            email: null,
            displayEmail: null,
            done: false,
            loading: false,
            error: null,
        }
    },
    methods: {
        sendEmailForRecovery: async function () {
            this.loading = true;
            this.done = false;
            const isValid = await this.$validator.validate();

            if (!isValid) {
                this.error = null;
                this.loading = false
                return
            }
            try {
                let response = await axios.post("/auth/recovery?email=" + this.email);
                console.log(response);
                this.loading = false;
                this.error = null;
                if (response.status === 200) {
                    this.displayEmail = response.data.email;
                    this.email = null;
                    this.done = true;
                }
            } catch (error) {
                this.loading = false;
                console.log(error.response)
                if (error.response) {
                    this.error = error.response.data.message;
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