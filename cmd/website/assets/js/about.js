function initMap() {
    var offices = [];
    var myLatLng = { lat: 5.345317, lng: -4.024429 };

    var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 12,
        center: myLatLng
    });

    infoWindow = new google.maps.InfoWindow({
        content: null,
    });


    axios.get("/api/v0/offices")
        .then(response => {
            offices = response.data;
            console.log(offices);

            for (var i = 0; i < offices.length; i++) {
                var marker = new google.maps.Marker({
                    position: { lat: offices[i].lat, lng: offices[i].lng },
                    map: map,
                    title: offices[i].name,
                    info: offices[i].name + "<br>" + offices[i].phone1 + " / " + offices[i].phone2,
                });
                google.maps.event.addListener(marker, 'click', function () {
                    infoWindow.setContent(this.info);
                    infoWindow.open(map, this);
                });
            }
        }).catch(error => {
            console.log(error);
        })


}