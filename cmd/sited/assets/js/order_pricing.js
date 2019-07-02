// Vuejs instances
Vue.options.delimiters = ['{', '}'];
var orderSummaryApp = new Vue({
    el: '#vue-app',
    data: {
        origin: null,
        destination: null,
        price: null,
        formattedDistance: null,
        priceComputed: false,
        loading: false,
        weightIntervalId: 1,
    },
    computed: {
        hasSummary() {
            return (this.origin != null && this.destination != null && this.price != null);
        }
    }
});



// $(".phone").inputmask({ "mask": "+225 99 99 99 99" });
var weightSelect = $('#weightIntervalId');

var originAddress;
var destinationAddrress;
var distance;

const prefix = " , Abidjan, Côte d'Ivoire";


class WeightInterval {
    constructor(id, pMin, pMax) {
        this.id = id;
        this.pMax = pMax;
        this.pMin = pMin;
    }
}


var weightIntervalA = new WeightInterval(1, 1000, 2300);
var weightIntervalB = new WeightInterval(2, 1400, 3220);
var weightIntervalC = new WeightInterval(3, 1700, 4000);


function showSideBar() {
    $('.ui.sidebar').sidebar('toggle');
}
$('#desktop-header .ui.dropdown').dropdown();
$('.ui.radio.checkbox').checkbox();


weightSelect.on('change', function () {
    console.log(weightSelect.val());
    orderSummaryApp.weightIntervalId = weightSelect.val();
    if (originAddress && destinationAddrress) {
        computeDeliveryPrice(distance);
    }
});


function computeDeliveryPrice(d) {
    var price;
    if (d <= 0 || d > 60 || isNaN(d)) {
        throw 'Distance invalide';
    }

    if (d < 6) {
        switch (Number(weightSelect.val())) {
            case 1:
                price = weightIntervalA.pMin;
                break;
            case 2:
                price = weightIntervalB.pMin;
                break;
            case 3:
                price = weightIntervalC.pMin;
                break;
            default:
                throw 'Interval de poids invalide'
        }
    } else {
        switch (Number(weightSelect.val())) {
            case 1:
                price = (d * weightIntervalA.pMax / 100) + weightIntervalA.pMin;
                break;
            case 2:
                price = (d * weightIntervalB.pMax / 100) + weightIntervalB.pMin;
                break;
            case 3:
                price = (d * weightIntervalC.pMax / 100) + weightIntervalC.pMin;
                break;
            default:
                throw 'Interval de poids invalide'
        }
    }
    orderSummaryApp.price = Math.ceil(price);
    return price;
}


// Google maps api related code
// This example requires the Places library. Include the libraries=places
// parameter when you first load the API. For example:
// <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">
// const prefix = 'Abidjan, ';
// const extension = ', Abidjan, Côte d\'Ivoire';




function initMap() {

    var originInput = document.getElementById('origin');
    var destinationInput = document.getElementById('destination');

    var cityBounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(5.232202, -4.136919),
        new google.maps.LatLng(5.501554, -3.816256),
    );
    var options = {
        bounds: cityBounds,
        strictBounds: true,
        componentRestrictions: { country: 'civ' },
    }
    var directionsService = new google.maps.DirectionsService;
    var origAutocomplete = new google.maps.places.Autocomplete(originInput, options);
    var destAutocomplete = new google.maps.places.Autocomplete(destinationInput, options);


    origAutocomplete.addListener('place_changed', function () {
        var place = origAutocomplete.getPlace();
        orderSummaryApp.origin = place.name;
        originAddress = place.name + ' ' + place.formatted_address;
        calculateAndDisplayRoute(directionsService, originAddress, destinationAddrress);
    });

    destAutocomplete.addListener('place_changed', function () {
        var place = destAutocomplete.getPlace();
        orderSummaryApp.destination = place.name;
        destinationAddrress = place.name + ' ' + place.formatted_address;
        calculateAndDisplayRoute(directionsService, originAddress, destinationAddrress);
    });
}




function calculateAndDisplayRoute(directionsService, orig, dest) {
    console.log(orig, dest);
    if (!orig || !dest) {
        return
    }

    orderSummaryApp.loading = true;

    directionsService.route({
        origin: orig,
        destination: dest,
        travelMode: 'DRIVING'
    }, function (response, status) {
        orderSummaryApp.loading = false;
        if (status === 'OK') {
            console.log(response.routes[0].legs[0].distance)
            distance = response.routes[0].legs[0].distance.value / 1000;
            orderSummaryApp.formattedDistance = response.routes[0].legs[0].distance.text;
            computeDeliveryPrice(distance);
        } else if (status == "NOT_FOUND") {
            showDistanceError();
        } else {
            console.log(response)
            console.log('Directions request failed due to ' + status);
        }
    });
}



function showDistanceError() {
    priceDiv.text('Problème adresse invalide: ' + defaultPriceDivText);
}
