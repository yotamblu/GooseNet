// Global variables
let dateInput;
let workoutContainer;
let initialMessage;
let tooltip; // Declare tooltip globally

// Global constants for D3 chart dimensions and margins
const margin = { top: 20, right: 30, bottom: 20, left: 40 };
// Removed fixed 'height' constant here; it will be calculated dynamically in drawD3Chart

document.addEventListener('DOMContentLoaded', function () {
    dateInput = document.getElementById('dateInput');
    workoutContainer = document.getElementById('workoutContainer');
    initialMessage = document.getElementById('initialMessage');
    tooltip = document.getElementById('tooltip'); // Initialize tooltip here

    // Set today's date as default on load
    if (dateInput) {
        const today = new Date();
        const year = today.getFullYear();
        const month = String(today.getMonth() + 1).padStart(2, '0');
        const day = String(today.getDate()).padStart(2, '0');
        dateInput.value = `${year}-${month}-${day}`;
        // Trigger workout loading for today's date
        fetchPlannedWorkouts();
    } else {
        console.error("dateInput element not found. Check your HTML ID.");
    }

    // Add event listener for date input change
    if (dateInput) {
        dateInput.addEventListener('change', fetchPlannedWorkouts);
    }
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
 * Fetches planned workout data for the selected date and updates the UI.
 */
async function fetchPlannedWorkouts() {
    if (!dateInput || !workoutContainer || !initialMessage) {
        console.error("DOM elements not initialized. Cannot fetch workouts.");
        return;
    }

    const selectedDate = dateInput.value;
    if (!selectedDate) {
        workoutContainer.innerHTML = '';
        initialMessage.style.display = 'block';
        return;
    }

    // Hide initial message and show loading indicator
    initialMessage.style.display = 'none';
    workoutContainer.innerHTML = '<span class="text-center text-xl font-bold text-gray-300 p-8 rounded-lg glass-panel">Loading planned workouts...</span>';

    const athleteName = new URLSearchParams(window.location.search).get("athleteName");
    // Assuming CoachName is hardcoded or fetched elsewhere if dynamic
    const coachName = "CoachTest"; // Replace with dynamic value if available

    const url = `GetPlannedWorkouts.aspx?athleteName=${athleteName}&CoachName=${coachName}&date=${selectedDate}`;

    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const htmlContent = await response.text();

        workoutContainer.innerHTML = htmlContent;

        if (htmlContent.trim() === "") {
            workoutContainer.innerHTML = `
                <span class="text-center text-xl font-bold text-gray-300 p-8 rounded-lg glass-panel">
                    No planned workouts found for this date.
                </span>`;
        }

        // After workouts are loaded into the DOM, initialize their D3 charts
        requestAnimationFrame(() => {
            initializeAllWorkoutCharts();
        });

    } catch (error) {
        console.error("Error fetching planned workouts:", error);
        workoutContainer.innerHTML = `
            <span class="text-center text-xl font-bold text-red-400 p-8 rounded-lg glass-panel">
                Error loading planned workouts. Please try again.
            </span>`;
    }
}

/**
 * Initializes D3 charts for all workout boxes found in the workoutContainer.
 */
async function initializeAllWorkoutCharts() {
    // Corrected selector: Find all elements whose ID starts with 'chart-' within workoutContainer
    const chartElements = workoutContainer.querySelectorAll('[id^="chart-"]');

    for (let i = 0; i < chartElements.length; i++) {
        const chartElement = chartElements[i];
        const workoutIndex = i + 1; // Assuming index starts from 1 in C# generation
        const workoutIdElement = document.getElementById(`workoutID-${workoutIndex}`);
        const workoutId = workoutIdElement ? workoutIdElement.textContent.trim() : null;

        if (!workoutId) {
            console.warn(`Workout ID not found for chart-${workoutIndex}. Skipping chart initialization.`);
            chartElement.innerHTML = '<p class="text-red-400 text-center">Chart data ID missing.</p>';
            continue;
        }

        try {
            const response = await fetch(`GetPlannedLapsById.aspx?workoutId=${workoutId}`);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const lapsData = await response.json();

            if (!lapsData || lapsData.length === 0) {
                chartElement.innerHTML = '<p class="text-gray-400 text-center">No lap data for this chart.</p>';
                continue;
            }

            drawD3Chart(chartElement.id, lapsData);

        } catch (error) {
            console.error(`Error fetching or drawing chart for workout ID ${workoutId}:`, error);
            chartElement.innerHTML = '<p class="text-red-400 text-center">Error loading chart.</p>';
        }
    }
}

/**
 * Draws a D3 bar chart for planned workout laps.
 * @param {string} chartId - The ID of the div element where the chart will be drawn.
 * @param {Array<Object>} laps - Array of lap objects with 'duration' and 'pace' properties.
 */
function drawD3Chart(chartId, laps) {
    const minPace = Math.min(...laps.map(l => l.pace));
    const maxPace = Math.max(...laps.map(l => l.pace));

    const chartElement = document.getElementById(chartId);
    if (!chartElement) {
        console.error(`Chart element with ID ${chartId} not found.`);
        return;
    }

    // Clear any existing SVG to prevent duplicates on re-render
    d3.select(`#${chartId} svg`).remove();

    // Dynamically calculate width and height based on the parent container's client dimensions
    const width = chartElement.clientWidth - margin.left - margin.right;
    const chartHeight = chartElement.clientHeight - margin.top - margin.bottom; // Use clientHeight for dynamic height

    // Ensure dimensions are not negative
    const effectiveWidth = Math.max(0, width);
    const effectiveHeight = Math.max(0, chartHeight);

    const svg = d3.select(`#${chartId}`)
        .append("svg")
        .attr("viewBox", `0 0 ${effectiveWidth + margin.left + margin.right} ${effectiveHeight + margin.top + margin.bottom}`)
        .attr("preserveAspectRatio", "xMidYMid meet")
        .append("g")
        .attr("transform", `translate(${margin.left}, ${margin.top})`);

    const xScale = d3.scaleLinear()
        .domain([0, d3.sum(laps, d => d.duration)])
        .range([0, effectiveWidth]);

    const heightScale = d3.scaleLinear()
        .domain([maxPace, minPace]) // Faster paces (lower values) are taller
        .range([5, effectiveHeight]); // Constrain bar heights within dynamic chart area (min height 5px)

    let cumulativeTime = 0;
    // Tooltip is now a global variable, no need to re-get it here

    svg.selectAll(".bar")
        .data(laps)
        .enter()
        .append("rect")
        .attr("class", "bar")
        .attr("x", d => {
            let prevTime = cumulativeTime;
            cumulativeTime += d.duration;
            return xScale(prevTime);
        })
        .attr("y", d => effectiveHeight - heightScale(d.pace)) // Use effectiveHeight for y-positioning
        .attr("width", d => xScale(d.duration))
        .attr("height", d => heightScale(d.pace))
        .attr("fill", d => getColor(d.pace, maxPace, minPace)) // Pass max/min pace to getColor
        .on("mouseover", function (event, d) {
            if (tooltip) {
                tooltip.classList.remove('hidden');
                tooltip.innerHTML = `Lap ${laps.indexOf(d) + 1}<br>Duration: ${formatTime(d.duration)}<br>Pace: ${formatPace(d.pace)} min/km`;
                tooltip.style.left = `${event.pageX + 10}px`;
                tooltip.style.top = `${event.pageY - 20}px`;
            }
        })
        .on("mousemove", function (event) {
            if (tooltip) {
                tooltip.style.left = `${event.pageX + 10}px`;
                tooltip.style.top = `${event.pageY - 20}px`;
            }
        })
        .on("mouseout", function () {
            if (tooltip) {
                tooltip.classList.add('hidden');
            }
        });
}

/**
 * Function to get color based on pace for the D3 bars.
 * @param {number} pace - The pace value for the current bar.
 * @param {number} minPace - The minimum pace value across all laps.
 * @param {number} maxPace - The maximum pace value across all laps.
 * @returns {string} The RGB color string.
 */
function getColor(pace, minPace, maxPace) {
    // Ensure minPace and maxPace are valid to prevent division by zero
    if (maxPace === minPace) return `rgb(255, 255, 0)`; // Default to yellow if all paces are the same

    // Interpolate from yellow (slower pace, higher value) to green (faster pace, lower value)
    // A higher pace value (slower) should be more yellow.
    // A lower pace value (faster) should be more green.
    const normalizedPace = (pace - minPace) / (maxPace - minPace); // 0 for fastest, 1 for slowest

    // Yellow: rgb(255, 255, 0)
    // Green: rgb(0, 255, 0)

    const red = Math.round(255 * normalizedPace); // Red component decreases as pace gets faster (closer to green)
    const green = 255; // Green component remains constant (full green)
    const blue = 0; // Blue component remains constant (no blue)

    return `rgb(${red}, ${green}, ${blue})`;
}

// Function to format time from seconds to MM:SS
function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${minutes}:${secs.toString().padStart(2, '0')}`;
}

// Function to format pace from minutes/km to MM:SS /km
function formatPace(pace) {
    const totalSeconds = Math.floor(pace * 60);
    return formatTime(totalSeconds);
}
