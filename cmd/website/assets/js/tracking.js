new Vue({
    el: '#tracking-app',
    delimiters: ['{', '}'],
    data: {
        tracking: null,
        loading: false,
        shipmentId: null,
        error: {
            hasError: false,
            message: '',
        },
    },
    methods: {
        checkFormAndSubmit: function (e) {
            e.preventDefault();
            this.fetchTracking();
        },
        formatDate(date) {
            var d = new Date(date)
            return d.toLocaleString('fr');
        },
        fetchTracking: async function () {
            if (!this.shipmentId) {
                this.error.hasError = false;
                return
            }
            this.loading = true;
            this.error.hasError = false;
            this.error.message = ''
            try {
                var response = await axios.get(`/shipment/tracking?id=${this.shipmentId}`)
                this.tracking = response.data.tracking || null;

                $(".details").slideToggle(300);
                $('html, body').animate({ scrollTop: $("#tracking-wrapper").offset().top }, 'slow');
            } catch (error) {
                console.log(error)
                this.error.hasError = true;
                if (error.response) {
                    this.error.message = error.response.data.message || error;
                }
            }
            this.loading = false;
        },
        showFullTracking: function (e) {
            $(".details").slideToggle(300);
        },
    },
    created: function () {
        $('.ui.radio.checkbox').checkbox();
        $('.ui.dropdown').dropdown();
        const urlParams = new URLSearchParams(window.location.search);
        this.shipmentId = urlParams.get('id');
        this.fetchTracking();
    },
});