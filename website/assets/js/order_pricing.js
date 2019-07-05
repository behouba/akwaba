var cityBounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(5.232202, -4.136919),
    new google.maps.LatLng(5.501554, -3.816256),
);
const options = {
    bounds: cityBounds,
    strictBounds: true,
    componentRestrictions: { country: 'civ' },
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
    },
    computed: {
        hasSummary() {
            return (this.pricing != null);
        }
    },
    methods: {
        async calculateCost() {
            this.loading = true;
            if (!this.origin || !this.destination || !this.categoryId) {
                this.pricing = null;
                this.loading = false;
                return
            }
            try {
                let response = await axios.get(
                    `/pricing/compute?origin=${this.origin.name}&destination=${this.destination.name}&categoryId=${this.categoryId}`,
                )
                this.pricing = response.data;
                console.log(response)
                $('html, body').animate({ scrollTop: $("#order-summary").offset().top }, 'slow');
            } catch (error) {
                console.log(error)
            }
            this.loading = false;
        }
    },
    mounted() {
        this.origAutocomplete = new google.maps.places.Autocomplete((this.$refs.origin), options);
        this.destAutocomplete = new google.maps.places.Autocomplete((this.$refs.destination), options);
        this.origAutocomplete.addListener('place_changed', () => {
            this.loading = true;
            this.origin = this.origAutocomplete.getPlace();
            console.log(this.origin)
            this.calculateCost();
        });

        this.destAutocomplete.addListener('place_changed', () => {
            this.loading = true;
            this.destination = this.destAutocomplete.getPlace();
            console.log(this.destination)
            this.calculateCost();
        });
    }
});



// // $(".phone").inputmask({ "mask": "+225 99 99 99 99" });
// var weightSelect = $('#shipmentCategoryId');

// var originAddress;
// var destinationAddrress;
// var distance;

// const prefix = " , Abidjan, Côte d'Ivoire";


// class ShipmentCategory {
//     constructor(id, pMin, pMax) {
//         this.id = id;
//         this.pMax = pMax;
//         this.pMin = pMin;
//     }
// }


// var ShipmentCategoryA = new ShipmentCategory(1, 1000, 2300);
// var ShipmentCategoryB = new ShipmentCategory(2, 1400, 3220);
// var ShipmentCategoryC = new ShipmentCategory(3, 1700, 4000);


// function showSideBar() {
//     $('.ui.sidebar').sidebar('toggle');
// }
// $('#desktop-header .ui.dropdown').dropdown();
// $('.ui.radio.checkbox').checkbox();


// weightSelect.on('change', function () {
//     console.log(weightSelect.val());
//     orderSummaryApp.shipmentCategoryId = weightSelect.val();
//     if (originAddress && destinationAddrress) {
//         computeDeliveryPrice(distance);
//     }
// });


// function computeDeliveryPrice(d) {
//     var price;
//     if (d <= 0 || d > 60 || isNaN(d)) {
//         throw 'Distance invalide';
//     }

//     if (d < 6) {
//         switch (Number(weightSelect.val())) {
//             case 1:
//                 price = ShipmentCategoryA.pMin;
//                 break;
//             case 2:
//                 price = ShipmentCategoryB.pMin;
//                 break;
//             case 3:
//                 price = ShipmentCategoryC.pMin;
//                 break;
//             default:
//                 throw 'Interval de poids invalide'
//         }
//     } else {
//         switch (Number(weightSelect.val())) {
//             case 1:
//                 price = (d * ShipmentCategoryA.pMax / 100) + ShipmentCategoryA.pMin;
//                 break;
//             case 2:
//                 price = (d * ShipmentCategoryB.pMax / 100) + ShipmentCategoryB.pMin;
//                 break;
//             case 3:
//                 price = (d * ShipmentCategoryC.pMax / 100) + ShipmentCategoryC.pMin;
//                 break;
//             default:
//                 throw 'Interval de poids invalide'
//         }
//     }
//     orderSummaryApp.price = Math.ceil(price);
//     return price;
// }


// Google maps api related code
// This example requires the Places library. Include the libraries=places
// parameter when you first load the API. For example:
// <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">
// const prefix = 'Abidjan, ';
// const extension = ', Abidjan, Côte d\'Ivoire';




// function initMap() {

//     var originInput = document.getElementById('origin');
//     var destinationInput = document.getElementById('destination');

//     var cityBounds = new google.maps.LatLngBounds(
//         new google.maps.LatLng(5.232202, -4.136919),
//         new google.maps.LatLng(5.501554, -3.816256),
//     );
//     var options = {
//         bounds: cityBounds,
//         strictBounds: true,
//         componentRestrictions: { country: 'civ' },
//     }
//     var directionsService = new google.maps.DirectionsService;
//     var origAutocomplete = new google.maps.places.Autocomplete(originInput, options);
//     var destAutocomplete = new google.maps.places.Autocomplete(destinationInput, options);


//     origAutocomplete.addListener('place_changed', function () {
//         var place = origAutocomplete.getPlace();
//         orderSummaryApp.origin = place.name;
//         originAddress = place.name + ' ' + place.formatted_address;
//         calculateAndDisplayRoute(directionsService, originAddress, destinationAddrress);
//     });

//     destAutocomplete.addListener('place_changed', function () {
//         var place = destAutocomplete.getPlace();
//         orderSummaryApp.destination = place.name;
//         destinationAddrress = place.name + ' ' + place.formatted_address;
//         calculateAndDisplayRoute(directionsService, originAddress, destinationAddrress);
//     });
// }




// function calculateAndDisplayRoute(directionsService, orig, dest) {
//     console.log(orig, dest);
//     if (!orig || !dest) {
//         return
//     }

//     orderSummaryApp.loading = true;

//     directionsService.route({
//         origin: orig,
//         destination: dest,
//         travelMode: 'DRIVING'
//     }, function (response, status) {
//         orderSummaryApp.loading = false;
//         if (status === 'OK') {
//             console.log(response.routes[0].legs[0].distance)
//             distance = response.routes[0].legs[0].distance.value / 1000;
//             orderSummaryApp.formattedDistance = response.routes[0].legs[0].distance.text;
//             computeDeliveryPrice(distance);
//         } else if (status == "NOT_FOUND") {
//             showDistanceError();
//         } else {
//             console.log(response)
//             console.log('Directions request failed due to ' + status);
//         }
//     });
// }
