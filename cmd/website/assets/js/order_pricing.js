$.fn.search.settings.templates.message = function (message, type) {
    // returns html for message with given message and type
    if (type === "empty") {
        html = `<div class="message empty"><div class="description">Aucun résultat ne correspond à votre recherche</div></div>`;
    }
    return html
}


Vue.options.delimiters = ['{', '}'];
var pricingApp = new Vue({
    el: '#order-pricing',
    data: {
        origin: null,
        destination: null,
        categoryId: null,
        pricing: null,
        formattedDistance: null,
        priceComputed: false,
        loading: false,
        origAutocomplete: null,
        destAutocomplete: null,
        hasError: false,
    },
    methods: {
        async calculateCost() {
            this.loading = true;
            // this.origin = this.$refs.origin.value;
            // this.destination = this.$refs.destination.value;
            if (!this.origin || !this.destination || !this.categoryId) {
                this.pricing = null;
                this.loading = false;
                return
            }
            try {
                let response = await axios.get(
                    `/pricing/compute?origin=${this.origin}&destination=${this.destination}&categoryId=${this.categoryId}`,
                )
                this.pricing = response.data;
                this.hasError = false
                console.log(response)
                $('html, body').animate({ scrollTop: $("#order-summary").offset().top }, 'slow');
            } catch (error) {
                this.hasError = true;
                console.log(error)
            }
            this.loading = false;
        }
    },
    mounted() {
        const apiSettings = {
            url: '/search/area?q={query}',
            onResponse: function (apiResponse) {
                var response = {
                    results: [],
                };
                if (apiResponse.areas === null) {
                    return
                }
                apiResponse.areas.forEach((area) => {
                    response.results.push({
                        title: area.name,
                        id: area.id,
                    })
                });
                return response;
            }
        }

        $("#origin").search({
            apiSettings: apiSettings,
            minCharacters: 1,
            maxResults: 10,
            onSelect: (res, resp) => {
                this.origin = res.title;
                console.log('origin')
                this.calculateCost();
            },
        })
        $("#destination").search({
            apiSettings: apiSettings,
            minCharacters: 1,
            maxResults: 10,
            onSelect: (res, resp) => {
                this.destination = res.title;
                this.calculateCost();
            },
        })
    }
});
