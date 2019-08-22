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
Vue.use(VueTheMask)
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

            // this.loading = true;
            // try {
            //     let response = await axios.post("/auth/registration", this.user);
            //     console.log(response);
            //     const splitedURL = window.location.href.split('redirect=')
            //     window.location.href = splitedURL.length > 1 ? splitedURL[1] : '/';
            // } catch (error) {
            //     this.loading = false;
            //     console.log(error.response)
            //     if (error.response) {
            //         var status = error.response.status;
            //         if (status === 401) {
            //             this.error = error.response.data.message;
            //             return
            //         }
            //         this.user = error.response.data.user;
            //         console.log(error.response);
            //     } else if (error.request) {
            //         console.log(error.request);
            //     } else {
            //         // Something happened in setting up the request and triggered an Error
            //         console.log('Error', error.message);
            //     }
            // }
            this.loading = false;
        }
    },
})