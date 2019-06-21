$(".phone").inputmask({ "mask": "+225 99 99 99 99" });

const defaultPriceDivText = 'Spécifiez la destination et le poids pour commencer le calcul';
const priceDiv = $('#price');

const priceLoaderDiv = $('#price-loader');

const weightSelect = $('#weightIntervalId');
var originInputDiv = document.getElementById('origin');
var destinationInputDiv = document.getElementById('destination');

var originAddress;
var destinationAddrress;
var distance;


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
    if (originAddress && destinationAddrress) {
        var price = computeDeliveryPrice(distance);
        console.log(price);
    }
});


function computeDeliveryPrice(d) {
    var price;
    if (d <= 0 || d > 60) {
        throw 'Distance invalide';
    }

    if (d < 10) {
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

    priceDiv.html(`Coût de la livraison <strong>${Math.ceil(price)} FCFA</strong>- 5h maximum`);
    return price;
}


// $('#order-form').form({
//     on: 'blur',
//     inline: true,
//     fields: {
//         senderName: {
//             identifier: 'senderName',
//             rules: [
//                 {
//                     type: 'empty',
//                     prompt: 'Veuillez saisir le nom de l\'expediteur'
//                 }
//             ]
//         },
//         senderPhone: {
//             identifier: 'senderPhone',
//             rules: [
//                 {
//                     type: 'regExp[^\\+225 (\\d{2}) (\\d{2}) (\\d{2}) (\\d{2})]',
//                     prompt: 'Veuillez saisir un numéro de mobile valide'
//                 }
//             ]
//         },
//         senderCityId: {
//             identifier: 'senderCityId',
//             rules: [
//                 {
//                     type: 'empty',
//                     prompt: 'Veuillez sélectionner une commune'
//                 }
//             ]
//         },
//         senderAddress: {
//             identifier: 'senderAddress',
//             rules: [
//                 {
//                     type: 'empty',
//                     prompt: 'Veuillez saisir l\'adresse'
//                 }
//             ]
//         },

//         receiverName: {
//             identifier: 'receiverName',
//             rules: [
//                 {
//                     type: 'empty',
//                     prompt: 'Veuillez saisir le nom du destinataire'
//                 }
//             ]
//         },
//         receiverPhone: {
//             identifier: 'receiverPhone',
//             rules: [
//                 {
//                     type: 'regExp[^\\+225 (\\d{2}) (\\d{2}) (\\d{2}) (\\d{2})]',
//                     prompt: 'Veuillez saisir un numéro de mobile valide'
//                 }
//             ]
//         },
//         receiverCityId: {
//             identifier: 'receiverCityId',
//             rules: [
//                 {
//                     type: 'empty',
//                     prompt: 'Veuillez sélectionner une commune'
//                 }
//             ]
//         },
//         receiverAddress: {
//             identifier: 'receiverAddress',
//             rules: [
//                 {
//                     type: 'empty',
//                     prompt: 'Veuillez saisir l\'adresse'
//                 }
//             ]
//         },
//         weightIntervalId: {
//             identifier: 'weightIntervalId',
//             rules: [
//                 {
//                     type: 'empty',
//                     prompt: 'Veuillez sélectionner un interval de poids'
//                 }
//             ]
//         },
//         nature: {
//             identifier: 'nature',
//             rules: [
//                 {
//                     type: 'empty',
//                     prompt: 'Veuillez saisir la nature du colis'
//                 }
//             ]
//         }
//     },
//     onFailure: function (formErrors, fields) {
//         for (field in fields) {
//             if (!$('.ui.form').form('is valid', field)) {
//                 let elem = $('.ui.form').form('get field', field)
//                 let dv = elem.closest('.field');
//                 $([document.documentElement, document.body]).animate({
//                     scrollTop: dv.offset().top
//                 }, 500);
//                 break;
//             }
//         }
//         return false;
//     },
// });




// Google maps api related code
// This example requires the Places library. Include the libraries=places
// parameter when you first load the API. For example:
// <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">
// const prefix = 'Abidjan, ';
// const extension = ', Abidjan, Côte d\'Ivoire';




function initMap() {

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
    var origAutocomplete = new google.maps.places.Autocomplete(originInputDiv, options);
    var destAutocomplete = new google.maps.places.Autocomplete(destinationInputDiv, options);


    origAutocomplete.addListener('place_changed', function () {
        var place = origAutocomplete.getPlace();
        console.log(place.name)
        originAddress = place.name;
        calculateAndDisplayRoute(directionsService, originAddress, destinationAddrress);
    });

    destAutocomplete.addListener('place_changed', function () {
        var place = destAutocomplete.getPlace();
        destinationAddrress = place.name;
        calculateAndDisplayRoute(directionsService, originAddress, destinationAddrress);
    });
}





function calculateAndDisplayRoute(directionsService, orig, dest) {
    console.log(orig, dest);
    if (!orig || !dest) {
        return
    }

    priceDiv.hide();
    priceLoaderDiv.show();

    directionsService.route({
        origin: orig,
        destination: dest,
        travelMode: 'DRIVING'
    }, function (response, status) {
        priceLoaderDiv.hide();
        priceDiv.show();
        if (status === 'OK') {
            console.log(response.routes[0].legs[0].distance)
            distance = response.routes[0].legs[0].distance.value / 1000;
            computeDeliveryPrice(distance);
            console.log(price)
        } else {
            console.log(response)
            console.log('Directions request failed due to ' + status);
        }
    });
}



