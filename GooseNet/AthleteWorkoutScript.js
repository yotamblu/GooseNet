// Declare global variables within the script's scope, but outside functions
// to make them accessible to all functions in this file.
// These will be initialized once the DOM is ready.
let datePicker;
let workoutContainer;
let initialMessage;

// This function will be called when the DOM is fully loaded.
// It ensures that all HTML elements are available before script execution.
document.addEventListener('DOMContentLoaded', function () {
    // Initialize global variables after the DOM is ready
    datePicker = document.getElementById('WorkoutDataDatePicker');
    workoutContainer = document.getElementById("workoutsContainer");
    initialMessage = document.getElementById("initialMessage");
    datePicker.addEventListener("change", function () {
      
        getWorkouts(); // Only runs when user actually changes it
    });
   
});



/**
 * Converts a date string from YYYY-MM-DD to M/D/YYYY format.
 * @param {string} dateString - The date string in YYYY-MM-DD format.
 * @returns {string} The formatted date string in M/D/YYYY format.
 */
function convertDate(dateString) {
    if (!dateString) {
        console.error("Date string is null or empty.");
        return ""; // Return empty string or handle error appropriately
    }
    const [year, month, day] = dateString.split("-");
    const formattedMonth = parseInt(month, 10);
    const formattedDay = parseInt(day, 10);
    return `${formattedMonth}/${formattedDay}/${year}`;
}

/**
 * Fetches workout data for the selected date and updates the UI.
 */
async function getWorkouts() {
    if (!datePicker || !workoutContainer || !initialMessage) {
        console.error("DOM elements not initialized. Cannot fetch workouts.");
        return;
    }
    datePicker.disabled = true;  

    const selectedDate = datePicker.value;
    if (!selectedDate) {
        // If no date is selected, clear workouts and show initial message
        workoutContainer.innerHTML = '';
        initialMessage.style.display = 'block';
        return;
    }

    const formattedDate = convertDate(selectedDate);
    const url = `GetWorkoutsByDate.aspx?date=${formattedDate}`;

    // Hide the initial message when fetching starts
    initialMessage.style.display = 'none';
    workoutContainer.innerHTML = '<span class="text-center text-xl font-bold text-gray-300 p-8 rounded-lg glass-panel">Loading workouts...</span>'; // Show loading message

    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const htmlContent = await response.text();

        workoutContainer.innerHTML = htmlContent;

        // If no workouts are returned (e.g., empty string), show a specific message
        if (htmlContent.trim() === "") {
            workoutContainer.innerHTML = `
                <span class="text-center text-xl font-bold text-gray-300 p-8 rounded-lg glass-panel">
                    There is no workout data from Garmin on this date, <br/> please try a different date or check that your activity was uploaded to Garmin Connect.
                </span>`;

            datePicker.disabled = false;

        }

        // After workouts are loaded into the DOM, initialize their maps
        // Use requestAnimationFrame to ensure DOM is fully rendered before map initialization
        requestAnimationFrame(() => {
            setMaps();
        });

    } catch (error) {
        console.error("Error fetching workouts:", error);
        workoutContainer.innerHTML = `
            <span class="text-center text-xl font-bold text-red-400 p-8 rounded-lg glass-panel">
                Error loading workouts. Please try again.
            </span>`;
    }


}

/**
 * Initializes Leaflet maps for all workout boxes found in the workoutsContainer.
 */
async function setMaps() {
    // Get all map containers dynamically added to the workoutsContainer
    const mapElements = workoutContainer.querySelectorAll('.map');

    for (let i = 0; i < mapElements.length; i++) {
        const mapElement = mapElements[i];
        const mapId = mapElement.id; // e.g., "map-1", "map-2"
        const workoutIndex = parseInt(mapId.replace('map-', '')); // Extract the index

        // Fetch coordinates for the specific workout map
        const url = `GetWorkoutCoordinates.aspx?date=${convertDate(datePicker.value.toString())}&index=${workoutIndex}`;

        try {
            const response = await fetch(url);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const coordinatesJsonStr = await response.text();
            let routeCoordinates = JSON.parse(coordinatesJsonStr);
            routeCoordinates = removeZeroCoordinates(routeCoordinates);

            // Initialize and insert polyline for the current map
            insertPolyLine(mapId, routeCoordinates);

        } catch (error) {
            console.error(`Error fetching coordinates for map ${mapId}:`, error);
            // Optionally display an error message on the specific map div
            mapElement.innerHTML = '<div class="text-red-400 text-center p-4">Map data unavailable.</div>';
        }

        datePicker.disabled = false;

    }
}

/**
 * Inserts a polyline onto a Leaflet map.
 * @param {string} mapId - The ID of the map container element.
 * @param {Array<Array<number>>} routeCoordinates - An array of [lat, lng] coordinate pairs.
 */
function insertPolyLine(mapId, routeCoordinates) {
    if (!routeCoordinates || routeCoordinates.length === 0) {
        console.warn(`No valid coordinates for map ${mapId}. Skipping polyline.`);
        return;
    }

    // Ensure the map is not already initialized on this element
    const existingMap = L.DomUtil.get(mapId);
    if (existingMap && existingMap._leaflet_id) {
        // If map already exists, destroy it to re-initialize
        L.map(mapId).remove();
    }

    const map = L.map(mapId).setView(getBestCenterCoordinate(routeCoordinates), getBestZoomLevel(routeCoordinates));

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    L.polyline(routeCoordinates, {
        color: '#1E90FF', // Changed to blue for consistency with GooseNet theme
        weight: 4,
        opacity: 1,
    }).addTo(map);

    // Fit map to bounds of the polyline for better visibility
    map.fitBounds(L.polyline(routeCoordinates).getBounds());
}

/**
 * Calculates the best center coordinate for a given set of [lat, lng] coordinates.
 * @param {Array<Array<number>>} coordinates - An array of [lat, lng] coordinate pairs.
 * @returns {Array<number>} The center coordinate as [lat, lng].
 */
function getBestCenterCoordinate(coordinates) {
    if (!Array.isArray(coordinates) || coordinates.length === 0) return [0, 0];
    let minLat = Infinity, maxLat = -Infinity, minLng = Infinity, maxLng = -Infinity;
    coordinates.forEach(coord => {
        if (Array.isArray(coord) && coord.length === 2) {
            const [lat, lng] = coord; // Assuming input is [lat, lng]
            if (lat < minLat) minLat = lat; if (lat > maxLat) maxLat = lat;
            if (lng < minLng) minLng = lng; if (lng > maxLng) maxLng = lng;
        }
    });
    return [(minLat + maxLat) / 2, (minLng + maxLng) / 2]; // Return as [lat, lng]
}

/**
 * Calculates the best zoom level for a given set of [lat, lng] coordinates.
 * @param {Array<Array<number>>} coordinates - An array of [lat, lng] coordinate pairs.
 * @returns {number} The best zoom level.
 */
function getBestZoomLevel(coordinates) {
    if (!Array.isArray(coordinates) || coordinates.length < 2) return 13;
    let maxLat = -Infinity, minLat = Infinity, maxLng = -Infinity, minLng = Infinity;
    coordinates.forEach(coord => {
        maxLat = Math.max(maxLat, coord[0]); // Assuming coord[0] is lat
        minLat = Math.min(minLat, coord[0]);
        maxLng = Math.max(maxLng, coord[1]); // Assuming coord[1] is lng
        minLng = Math.min(minLng, coord[1]);
    });
    const latDiff = maxLat - minLat;
    const lngDiff = maxLng - minLng;

    // These values are approximations for degrees per pixel at different zoom levels
    // A more accurate calculation would involve map projection details, but this is a common heuristic.
    const degreesPerPixel = [
        360.0, 180.0, 90.0, 45.0, 22.5, 11.25, 5.625, 2.8125, 1.40625,
        0.703125, 0.3515625, 0.17578125, 0.087890625, 0.0439453125,
        0.02197265625, 0.010986328125, 0.0054931640625, 0.00274658203125,
        0.001373291015625, 0.0006866455078125
    ];

    let bestZoom = 0;
    for (let zoom = 0; zoom < degreesPerPixel.length; zoom++) {
        // Find the highest zoom level where both lat and lng differences fit within the pixel-per-degree
        // This logic might need fine-tuning based on actual map container size and desired padding.
        if (latDiff <= degreesPerPixel[zoom] && lngDiff <= degreesPerPixel[zoom]) {
            bestZoom = zoom;
        } else {
            break;
        }
    }
    // Adjust zoom slightly to ensure the entire route is visible with some padding
    return Math.max(0, bestZoom - 1); // Subtract 1 to give a bit more padding
}

/**
 * Removes coordinates that are [0,0] which often indicate invalid GPS data.
 * @param {Array<Array<number>>} routeCoordinates - An array of [lat, lng] coordinate pairs.
 * @returns {Array<Array<number>>} Filtered array of coordinates.
 */
function removeZeroCoordinates(routeCoordinates) {
    return routeCoordinates.filter(coord => !(coord[0] === 0 && coord[1] === 0));
}
