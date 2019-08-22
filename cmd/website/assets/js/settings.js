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
            phone: {
                required: 'Veuillez saisir un numéro de mobile valide',
                length: 'Veuillez saisir un numéro de mobile valide',
            },
            email: {
                required: 'Veuillez saisir une adresse e-mail valide',
                email: 'Veuillez saisir une adresse e-mail valide',
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

var app = new Vue({
    el: '#setting-app',
    data: {
        error: null,
        success: null,
        user: null,
        loading: false,
    },
    methods: {
        submitUpdate: async function () {
            this.loading = true;
            this.error = null;
            this.success = null;

            const isValid = await this.$validator.validate();

            if (!isValid) {
                this.loading = false;
                return
            }

            try {
                var response = await axios.post("/profile/update", this.user)
                $('html,body').animate({ scrollTop: 0 }, 200);
                this.loading = false;
                console.log(response);
                this.user = response.data.user || null;
                this.success = response.data.message;
            } catch (error) {
                this.loading = false;
                if (error.response) {
                    $('html,body').animate({ scrollTop: 0 }, 200);
                    var status = error.response.status;
                    if (status === 409 || status === 500) {
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
    created() {
        axios.get("/profile/data")
            .then(response => {
                if (response.status == 200) {
                    this.user = response.data.user;
                }
            })
            .catch(error => {
                alert(error.response)
            })
    }
})