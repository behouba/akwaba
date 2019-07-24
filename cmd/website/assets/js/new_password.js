//  action="/auth/password_request?uuid={{.uuid}}"
//  method="POST"
const dictionary = {
    en: {
        custom: {
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
Vue.use(VeeValidate, {
    mode: 'lazy',
    events: 'blur',
    dictionary: dictionary,
});
var newPasswordApp = new Vue({
    el: "#new-passsword-app",
    data() {
        return {
            password: null,
            confirmPassword: null,
            loading: false,
            done: false,
            error: null,
            token: "{{.token}}",
        }
    },
    methods: {
        sendNewPassword: async function () {
            const isValid = await this.$validator.validate();

            if (!isValid) {
                return
            }
            this.loading = true;
            try {
                let response = await axios.post("/auth/password_request", { newPassword: this.password, token: this.token });
                console.log(response);
                this.loading = false;
                if (response.status === 200) {
                    this.done = true;
                }
            } catch (error) {
                this.loading = false;
                console.log(error.response)
                if (error.response) {
                    var status = error.response.status;
                    if (status === 409 || status === 500) {
                        this.error = error.response.data.message;
                        window.location.reload();
                        return
                    }
                    console.log(error.response);
                } else if (error.request) {
                    console.log(error.request);
                } else {
                    // Something happened in setting up the request and triggered an Error
                    alert('Error', error.message);
                }
            }
        }
    },
})