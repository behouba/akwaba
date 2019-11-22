const dictionary = {
    en: {
        custom: {
            senderName: {
                required: 'Veuillez saisir le nom de l\'expéditeur.',
                min: 'le nom de l\'expéditeur doit contenir au moins 3 caractères'
            },
            senderAddress: {
                required: 'Veuillez compléter d\'adresse de l\'expéditeur.',
                min: 'Veuillez compléter d\'adresse du destinataire.',
            },
            senderPhone: {
                required: 'Veuillez saisir un numéro de mobile valide',
                length: 'Veuillez saisir un numéro de mobile valide',
            },
            recipientName: {
                required: 'Veuillez saisir le nom du destinataire.',
                min: 'le nom du destinataire doit contenir au moins 3 caractères'
            },
            recipientAddress: {
                required: 'Veuillez compléter d\'adresse du destinataire.',
                min: 'Veuillez compléter d\'adresse du destinataire.',
            },
            recipientPhone: {
                required: 'Veuillez saisir un numéro de mobile valide',
                length: 'Veuillez saisir un numéro de mobile valide',
            },
            nature: {
                required: 'Veuillez préciser la nature du colis',
                min: 'Veuillez préciser la nature du colis (3 caractères minimum)',
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

function Address() {
    return {
        name: null,
        area: { id: null, name: null, cityId: null },
        phone: null,
        address: null,
    }
}
function Order() {
    return {
        sender: Address(),
        recipient: Address(),
        category: { id: null, name: null },
        nature: null,
        paymentOption: { id: 1, name: null },
    }
}

var orderApp = new Vue({
    el: "#order-app",
    data() {
        return {
            cost: null,
            order: Order(),
            loading: false,
            error: null,
        }
    },
    methods: {
        async submitOrder() {
            this.order.paymentOption.id = Number(this.order.paymentOption.id);
            console.log(JSON.parse(JSON.stringify(this.order)));

            await this.$validator.validate();
            const firstField = await Object.keys(this.errors.collect())[0];
            if (firstField != undefined) {
                this.$refs[`${firstField}Input`].scrollIntoView({ behavior: "smooth" });
                return
            }
            this.loading = true;

            // create array of shipments. After business user will be able to create many shipments in
            // one order
            try {
                let response = await axios.post("/order/create", this.order);
                console.log(response);
                this.loading = false;
                if (response.data) {
                    console.log(response.data);
                    window.location.href = "/order/success?orderId=" + response.data.orderId;
                } else {
                    this.error = 'La création de commande a échoué, veuillez réessayer s\'il vous plait';
                }
            } catch (error) {
                this.loading = false;
                console.log(error.response);
                if (error.response) {
                    var status = error.response.status;
                    if (status === 409 || status === 500) {
                        this.error = error.response.data.error;
                        return
                    }
                } else if (error.request) {
                    console.log(error.request);
                    this.error = "Echec de l'opération: vérifiez votre connexion internet."
                } else {
                    // Something happened in setting up the request and triggered an Error
                    this.error = error.message;
                }
                console.log(error)
            }
        }
    },
    mounted() {
        const urlParams = new URLSearchParams(window.location.search);
        this.order.sender.area.name = urlParams.get('origin') || this.$refs.originPlace.value;
        this.order.recipient.area.name = urlParams.get('destination') || this.$refs.destinationPlace.value;
        this.order.category.id = Number(urlParams.get('categoryId') || this.$refs.category.dataset.categoryId);
        axios.get(
            `/api/v0/pricing?origin=${this.order.sender.area.name}&destination=${this.order.recipient.area.name}&categoryId=${this.order.category.id}`,
        ).then(response => {
            this.cost = response.data.cost;
            console.log(response);
        }).catch(error => {
            alert(error);
        })
    }
})