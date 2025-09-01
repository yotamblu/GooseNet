// Global variables
let dateInput;
let workoutContainer;
let initialMessage;

document.addEventListener('DOMContentLoaded', function () {
    dateInput = document.getElementById('dateInput');
    workoutContainer = document.getElementById('workoutContainer');
    initialMessage = document.getElementById('initialMessage');

    // Set today's date as default on load
    if (dateInput) {
        const today = new Date();
        const year = today.getFullYear();
        const month = String(today.getMonth() + 1).padStart(2, '0');
        const day = String(today.getDate()).padStart(2, '0');
        dateInput.value = `${year}-${month}-${day}`;
        fetchPlannedWorkouts();
    } else {
        console.error("dateInput element not found. Check your HTML ID.");
    }

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
        return "";
    }
    const [year, month, day] = dateString.split("-");
    const formattedMonth = parseInt(month, 10);
    const formattedDay = parseInt(day, 10);
    return `${formattedMonth}/${formattedDay}/${year}`;
}

/**
 * Fetches planned workout data and updates the UI.
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

    initialMessage.style.display = 'none';
    workoutContainer.innerHTML = '<span class="text-center text-xl font-bold text-gray-300 p-8 rounded-lg glass-panel">Loading planned workouts...</span>';

    const athleteName = new URLSearchParams(window.location.search).get("athleteName");
    const coachName = new URLSearchParams(window.location.search).get("coachName");

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
 * Initializes charts for all workout boxes using native SVG.
 */
async function initializeAllWorkoutCharts() {
    const chartElements = workoutContainer.querySelectorAll('[id^="chart-"]');
    let chartElement = document.getElementById("chart-1");
    for (i = 1; chartElement != null; i++) {
        const workoutId = chartElement.getAttribute('data-workout-id');

        if (!workoutId) {
            console.warn(`Workout ID data attribute not found for chart ID ${chartElement.id}. Skipping chart initialization.`);
            chartElement.innerHTML = '<p class="text-red-400 text-center">Chart data ID missing.</p>';
            continue;
        }

        try {
            const response = await fetch(`GetPlannedLapsById.aspx?workoutId=${document.getElementById("workoutID-" + i.toString()).innerHTML}`);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const lapsData = await response.json();

            if (!Array.isArray(lapsData) || lapsData.length === 0) {
                chartElement.innerHTML = '<p class="text-gray-400 text-center">No lap data for this chart.</p>';
                continue;
            }

            await drawNativeChart(chartElement.id, lapsData);

        } catch (error) {
            console.error(`Error fetching or drawing chart for workout ID ${workoutId}:`, error);
            chartElement.innerHTML = '<p class="text-red-400 text-center">Error loading chart.</p>';
        }
        chartElement = document.getElementById("chart-" + (i + 1));
    }
}

/**
 * Draws a bar chart using native JavaScript and SVG elements.
 * Bars now fit within the container width, with thickness proportional to lap duration.
 * @param {string} chartId - The ID of the div element where the chart will be drawn.
 * @param {Array<Object>} laps - Array of lap objects with 'duration' and 'pace' properties.
 */
async function drawNativeChart(chartId, laps) {
    const chartElement = document.getElementById(chartId);
    if (!chartElement) {
        console.error(`Chart element with ID ${chartId} not found.`);
        return;
    }

    // Clear any existing SVG
    chartElement.innerHTML = '';
    chartElement.style.minHeight = '150px';

    const containerWidth = chartElement.clientWidth;
    const height = 150;
    const minBarHeight = 5;

    const allPaces = laps.map(l => l.pace).filter(p => typeof p === 'number' && !isNaN(p));
    const allDurations = laps.map(l => l.duration).filter(d => typeof d === 'number' && !isNaN(d));

    if (allPaces.length === 0 || allDurations.length === 0) {
        chartElement.innerHTML = '<p class="text-gray-400 text-center">No valid pace or duration data for this chart.</p>';
        return;
    }

    const minPace = Math.min(...allPaces);
    const maxPace = Math.max(...allPaces);
    const totalDurationsSum = allDurations.reduce((sum, duration) => sum + duration, 0);

    const totalChartWidth = containerWidth;

    const widthScalingFactor = totalChartWidth / totalDurationsSum;

    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("width", totalChartWidth);
    svg.setAttribute("height", height);
    svg.setAttribute("viewBox", `0 0 ${totalChartWidth} ${height}`);

    chartElement.appendChild(svg);

    let currentX = 0;

    laps.forEach((lap, index) => {
        let barHeight;
        let barWidth;
        let fillColor = getNativeScaledColor(lap.pace, minPace, maxPace);

        // Calculate bar height (pace)
        if (minPace === maxPace) {
            barHeight = height * 0.5;
        } else {
            const normalizedValue = (lap.pace - minPace) / (maxPace - minPace);
            barHeight = (1 - normalizedValue) * (height - minBarHeight) + minBarHeight;
        }

        // Calculate bar width using the new scaling factor.
        barWidth = lap.duration * widthScalingFactor;

        // Ensure a small minimum width for very short laps to be visible.
        barWidth = Math.max(barWidth, 1);

        const yPosition = height - barHeight;

        const bar = document.createElementNS("http://www.w3.org/2000/svg", "rect");
        bar.setAttribute("x", currentX);
        bar.setAttribute("y", yPosition);
        bar.setAttribute("width", barWidth);
        bar.setAttribute("height", barHeight);
        bar.setAttribute("fill", fillColor);

        svg.appendChild(bar);

        currentX += barWidth;

        bar.addEventListener('mouseover', (e) => {
            const tooltip = document.createElement('div');
            tooltip.classList.add('tooltip');
            tooltip.style.left = `${e.pageX + 10}px`;
            tooltip.style.top = `${e.pageY - 20}px`;
            tooltip.innerHTML = `Lap ${index + 1}<br>Duration: ${formatTime(lap.duration)}<br>Pace: ${formatPace(lap.pace)} min/km`;
            document.body.appendChild(tooltip);
        });

        bar.addEventListener('mouseout', () => {
            const tooltip = document.querySelector('.tooltip');
            if (tooltip) {
                tooltip.remove();
            }
        });
    });
}

/**
 * Function to get color based on pace without external libraries.
 * @param {number} pace - The pace value for the current bar.
 * @param {number} minPace - The minimum pace value across all laps.
 * @param {number} maxPace - The maximum pace value across all laps.
 * @returns {string} The interpolated color string.
 */
function getNativeScaledColor(pace, minPace, maxPace) {
    if (minPace === maxPace) return "#5564BE";

    const r1 = 0;
    const g1 = 230;
    const b1 = 118;

    const r2 = 255;
    const g2 = 23;
    const b2 = 68;

    const ratio = (pace - minPace) / (maxPace - minPace);

    const r = Math.round(r1 + (r2 - r1) * ratio);
    const g = Math.round(g1 + (g2 - g1) * ratio);
    const b = Math.round(b1 + (b2 - b1) * ratio);

    return `rgb(${r}, ${g}, ${b})`;
}

// Function to format time from seconds to MM:SS
function formatTime(seconds) {
    if (typeof seconds !== 'number' || isNaN(seconds)) {
        return "N/A";
    }
    const minutes = Math.floor(seconds / 60);
    const secs = Math.round(seconds % 60);
    return `${minutes}:${secs.toString().padStart(2, '0')}`;
}

// Function to format pace from minutes/km to MM:SS /km
function formatPace(pace) {
    if (typeof pace !== 'number' || isNaN(pace)) {
        return "N/A";
    }
    const totalSeconds = Math.floor(pace * 60);
    return formatTime(totalSeconds);
}