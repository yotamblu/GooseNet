let datePicker = document.getElementById('WorkoutDataDatePicker')
let workoutContainer = document.getElementById("workoutsContainer")


function getBestCenterCoordinate(coordinates) {
    if (!Array.isArray(coordinates) || coordinates.length === 0) {
        throw new Error("Invalid coordinates.");
    }

    let minLat = Infinity, maxLat = -Infinity;
    let minLng = Infinity, maxLng = -Infinity;

    coordinates.forEach(coord => {
        if (Array.isArray(coord) && coord.length === 2) {
            const [lng, lat] = coord;
            if (lat < minLat) minLat = lat;
            if (lat > maxLat) maxLat = lat;
            if (lng < minLng) minLng = lng;
            if (lng > maxLng) maxLng = lng;
        } else {
            throw new Error("Invalid coordinate format. Expected [lng, lat].");
        }
    });

    // Calculate center point
    const centerLat = (minLat + maxLat) / 2;
    const centerLng = (minLng + maxLng) / 2;

    return [centerLng, centerLat]; // Return as [lng, lat] format
}

function removeZeroCoordinates(routeCoordinates) {
    return routeCoordinates.filter(coord => !(coord[0] === 0 && coord[1] === 0));
}

function setMaps() {

    for (i = 1; true; i++) {

        if (document.getElementById("map-" + i.toString()) != null) {

            workoutCoordinatesRequest = new XMLHttpRequest();
            routeCoordinates = "";
            workoutCoordinatesRequest.onload = () => {
                routeCoordinates = removeZeroCoordinates(JSON.parse(workoutCoordinatesRequest.responseText))
                insertPolyLine();
            }
            url = "GetWorkoutCoordinates.aspx?date=" + convertDate(datePicker.value.toString()) + "&index=" + i;
            workoutCoordinatesRequest.open("GET", url, false);
            workoutCoordinatesRequest.send();
            routeCoordinates = (workoutCoordinatesRequest.responseText);



        } else break;
    }
}






function insertPolyLine() {
    requestAnimationFrame(() => { });

    routeCoordinates = JSON.parse(workoutCoordinatesRequest.responseText);
    routeCoordinates = removeZeroCoordinates(routeCoordinates)

    const map = L.map('map-' + (i).toString()).setView(getBestCenterCoordinate(routeCoordinates), getBestZoomLevel(routeCoordinates));


    // Add OpenStreetMap tiles
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    // Add the route to the map
    L.polyline(routeCoordinates, {
        color: 'red',
        weight: 4,
        opacity: 1,
    }).addTo(map);

}

function getWorkouts() {

    workoutsRequest = new XMLHttpRequest();
    workoutsRequest.onload = () => {
        workoutContainer.innerHTML = ""
        const newDiv = document.createElement('div')
        newDiv.innerHTML = workoutsRequest.responseText

        workoutContainer.appendChild(newDiv.firstChild)

        workoutContainer.innerHTML = (workoutsRequest.responseText)

        requestAnimationFrame(() => {


            setMaps();
        });
    }


    workoutsRequest.open("GET", 'GetWorkoutsByDate.aspx?date=' + convertDate(datePicker.value.toString()), false)
    workoutsRequest.send()
    if (workoutContainer.innerHTML == "") {
        workoutContainer.innerHTML = "<span style=\"color: white;font-weight:bold;font-size: 4vw;\">There is No Workout Data From Garmin on this Date,<br/> please try a different date or check that your activity was uploaded to Garmin Connect<span>"
    }

}




function convertDate(dateString) {
    // Split the input string into an array [yyyy, mm, dd]
    const [year, month, day] = dateString.split("-");

    // Convert month and day to numbers to remove leading zeros
    const formattedMonth = parseInt(month, 10);
    const formattedDay = parseInt(day, 10);

    // Return the date in m/d/yyyy format
    return `${formattedMonth}/${formattedDay}/${year}`;
}

function getBestZoomLevel(coordinates) {
    if (!Array.isArray(coordinates) || coordinates.length === 0) {
        throw new Error("Invalid coordinates.");
    }

    let minLat = Infinity, maxLat = -Infinity;
    let minLng = Infinity, maxLng = -Infinity;

    coordinates.forEach(coord => {
        if (Array.isArray(coord) && coord.length === 2) {
            const [lng, lat] = coord;
            if (lat < minLat) minLat = lat;
            if (lat > maxLat) maxLat = lat;
            if (lng < minLng) minLng = lng;
            if (lng > maxLng) maxLng = lng;
        } else {
            throw new Error("Invalid coordinate format. Expected [lng, lat].");
        }
    });

    const latDiff = maxLat - minLat;
    const lngDiff = maxLng - minLng;

    const degreesPerPixel = [
        360.0, 180.0, 90.0, 45.0, 22.5, 11.25, 5.625, 2.8125, 1.40625,
        0.703125, 0.3515625, 0.17578125, 0.087890625, 0.0439453125,
        0.02197265625, 0.010986328125, 0.0054931640625, 0.00274658203125,
        0.001373291015625, 0.0006866455078125
    ];

    let bestZoom = 0;
    for (let zoom = 0; zoom < degreesPerPixel.length; zoom++) {
        if (latDiff <= degreesPerPixel[zoom] && lngDiff <= degreesPerPixel[zoom]) {
            bestZoom = zoom;
        } else {
            break;
        }
    }

    return bestZoom;
}