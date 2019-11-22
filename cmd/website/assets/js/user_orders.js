
// var ordersApp = 
new Vue({
    el: '#user-orders',
    delimiters: ['{', '}'],
    data: {
        orders: [],
        error: false,
        loading: false,
        showLoadMore: false,
        selectedOrderId: 0,
    },
    methods: {
        formatDate(dateString) {
            var d = new Date(dateString)
            return d.toLocaleDateString('fr');
        },
        showFullInfo(e) {
            e.target.innerText = e.target.innerText == "Afficher" ? "Masquer" : "Afficher";
            $(e.target).closest('.card').find('.full-info').slideToggle();
        },
        parseOrders(orders) {
            if (!orders) {
                return []
            }
            return orders.map(o => {
                o.timeCreated = this.formatDate(o.timeCreated);
                o.timeClosed = this.formatDate(o.timeClosed);
                o.distance = o.distance.toFixed(2);
                o.cost = o.cost.toLocaleString();
                return o
            })
        },
        fetchOrders: async function () {
            this.loading = true;
            try {
                var response = await axios.get(`/profile/orders?offset=${this.orders.length || 0}`)
                var orders = this.parseOrders(response.data.orders || null);
                if (orders.length === 50) {
                    this.showLoadMore = true;
                } else {
                    this.showLoadMore = false;
                }
                this.orders.push(...orders);
                this.error = false;
                console.log(response);
            } catch (error) {
                this.error = true;
                if (error.response) {
                    // The request was made and the server responded with a status code
                    // that falls out of the range of 2xx
                    console.log(error.response);
                    alert(error.response.data.error || error.response)
                } else if (error.request) {
                    // The request was made but no response was received
                    // `error.request` is an instance of XMLHttpRequest in the browser and an instance of
                    // http.ClientRequest in node.js
                    console.log(error.request);
                } else {
                    this.error = true;
                    // Something happened in setting up the request that triggered an Error
                    console.error('Error', error.message);
                }
                console.error(error);
            }
            this.loading = false;
        },
        showCancelModal: function (id) {
            this.selectedOrderId = id;
            console.log(id);
            $('#cancelModal').modal('show');
        },
        cancelOrder: async function () {
            if (!this.selectedOrderId) {
                return
            }

            try {
                var response = await axios.patch(`/order/cancel/${this.selectedOrderId}`)
                console.log(response);
                window.location.reload();
            } catch (error) {
                alert(error);
            }
        },
    },
    created: function () {
        this.fetchOrders();
    },
})