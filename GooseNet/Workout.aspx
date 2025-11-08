<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Workout.aspx.cs" Inherits="GooseNet.Workout1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://d3js.org/d3.v7.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-zoom@2.0.1/dist/chartjs-plugin-zoom.umd.min.js"></script>
    <title><%=Request.QueryString["userName"] + " - Workout" %></title>
    <%-- The inline <style> block has been removed. All styles are now handled by the main Style.css file. --%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <!-- The .container class now has margin: 0 auto !important; in Style.css for centering -->
    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
            <div style="display: flex; align-items: center;">
                <img style="border-radius: 50%; width: 48px; height: 48px; margin-right: 12px;" src="<%=GooseNet.GooseNetUtils.GetUserPicStringByUserName(Request.QueryString["userName"]) %>"/>
                <h3 style="display:inline; font-size: 1.25rem; font-weight: 600;"><%=Request.QueryString["userName"] %></h3>
            </div>
            <button id="shareBtn"><img width="20" src="Images/shareBtn.png"/></button>
        </div>

        <h2 style="font-size: 2rem; font-weight: 700; margin-bottom: 1rem;"><%=workoutData.WokroutName %></h2>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin-bottom: 2rem;">
            <div>
                <p style="font-size: 0.9rem; color: #ccc;">Distance</p>
                <p style="font-size: 1.5rem; font-weight: 600;"><%=(workoutData.WorkoutDistanceInMeters / 1000.0).ToString("#.##") %> km</p>
            </div>
            <div>
                <p style="font-size: 0.9rem; color: #ccc;">Average Pace</p>
                <p style="font-size: 1.5rem; font-weight: 600;"><%=GooseNet.GooseNetUtils.ConvertMinutesToTimeString(workoutData.WorkoutAvgPaceInMinKm) %> /km</p>
            </div>
            <div>
                <p style="font-size: 0.9rem; color: #ccc;">Average Heart Rate</p>
                <p style="font-size: 1.5rem; font-weight: 600;"><%=workoutData.WorkoutAvgHR %> bpm</p>
            </div>
        </div>
        <%if (!isTreadmill)
            {  %>
        <h3>Workout Map:</h3>
        <!-- The map height and width are now controlled by Style.css for better responsiveness -->
        <div id="map" class="map"></div>
        <%} %>
        <h3 style="margin-top: 2rem;">Workout Laps:</h3>
        <!-- The bar-container width is now controlled by Style.css for better responsiveness -->
        <div class="bar-container">
            <div id="chart"></div>
            <div id="tooltip" class="tooltip"></div>
        </div>
        
        <table class="lap-table">
            <thead>
                <tr>
                    <th>Lap</th>
                    <th>Distance</th>
                    <th>Time</th>
                    <th>Pace</th>
                    <%if(workoutData.DataSamples != null)
                        {
                            Response.Write("<th>Heart Rate</th>");
                        } %>
                </tr>
            </thead>
            <tbody>
                <%=GetLapTableRowsHTML() %>
            </tbody>
        </table>

        <%if(workoutData.DataSamples != null)
            {
                Response.Write("<div class='chart-container'><canvas id='heartRateChart'></canvas></div>");
                Response.Write("<div class='chart-container'><canvas id='speedChart'></canvas></div>");
             if (!isTreadmill) { 
                   Response.Write("<div class='chart-container'><canvas id='elevationChart'></canvas></div>");
                }
            } %>
    </div>

    <script>
        // --- DEEP LINKING & SHARE BUTTON LOGIC (Unchanged) ---
        const url = new URL(window.location.href);
        const userName = url.searchParams.get("userName");
        const activityId = url.searchParams.get("activityId");
        const deepLink = `goosenetmobile://workout/details?athleteName=${encodeURIComponent(userName)}&id=${encodeURIComponent(activityId)}`;

        if (/Android/i.test(navigator.userAgent) && /Mobi/i.test(navigator.userAgent)) {
            if (userName && activityId) {
                const iframe = document.createElement("iframe");
                iframe.style.display = "none";
                iframe.src = deepLink;
                document.body.appendChild(iframe);
            }
        }

        document.getElementById('shareBtn').addEventListener('click', () => {
            var message = "check out this cool workout on GooseNet 🪿 " + window.location.href;
            var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|Windows Phone/i.test(navigator.userAgent);

            if (isMobile && navigator.share) {
                    navigator.share({
                        title: 'GooseNet Workout',
                        text: message,
                    }).catch(err => console.error("Share failed:", err));
            } else if (isMobile) {
                var whatsappUrl = "https://api.whatsapp.com/send?text=" + encodeURIComponent(message);
                window.open(whatsappUrl, "_blank", "noopener,noreferrer");
            }
            else {
                // Using document.execCommand('copy') for clipboard operations due to potential iframe restrictions
                const tempInput = document.createElement('textarea');
                tempInput.value = window.location.href;
                document.body.appendChild(tempInput);
                tempInput.select();
                try {
                    document.execCommand('copy');
                    // Replaced alert with a simple console log or a custom message box if needed
                    console.log("Workout link copied to clipboard!");
                    // You might want to implement a custom modal/message box here instead of alert
                } catch (err) {
                    console.error("Failed to copy text: ", err);
                } finally {
                    document.body.removeChild(tempInput);
                }
            }
        });

        // --- MAP & D3/CHART.JS HELPER FUNCTIONS (Adjusted for [lat, lng] coordinates) ---
        function getBestCenterCoordinate(coordinates) {
            if (!Array.isArray(coordinates) || coordinates.length === 0) return [0, 0];
            let minLat = Infinity, maxLat = -Infinity, minLng = Infinity, maxLng = -Infinity;
            coordinates.forEach(coord => {
                if (Array.isArray(coord) && coord.length === 2) {
                    const [lat, lng] = coord; // Correctly destructure as [lat, lng]
                    if (lat < minLat) minLat = lat; if (lat > maxLat) maxLat = lat;
                    if (lng < minLng) minLng = lng; if (lng > maxLng) maxLng = lng;
                }
            });
            return [(minLat + maxLat) / 2, (minLng + maxLng) / 2];
        }
        function removeZeroCoordinates(routeCoordinates) { return routeCoordinates.filter(coord => !(coord[0] === 0 && coord[1] === 0)); }
        function getBestZoomLevel(coordinates) {
             if (!Array.isArray(coordinates) || coordinates.length < 2) return 13;
            let maxLat = -Infinity, minLat = Infinity, maxLng = -Infinity, minLng = Infinity;
            coordinates.forEach(coord => {
                maxLat = Math.max(maxLat, coord[0]); minLat = Math.min(minLat, coord[0]);
                maxLng = Math.max(maxLng, coord[1]); minLng = Math.min(minLng, coord[1]);
            });
            const latDiff = maxLat - minLat; const lngDiff = maxLng - minLng;
            const zoomLat = Math.floor(Math.log2(360 / latDiff)); const zoomLng = Math.floor(Math.log2(360 / lngDiff));
            return Math.min(zoomLat, zoomLng, 18);
        }
        function formatTime(seconds) { const minutes = Math.floor(seconds / 60); const secs = seconds % 60; return `${minutes}:${secs.toString().padStart(2, '0')}`; }
        function formatPace(pace) { const totalSeconds = Math.floor(pace * 60); return formatTime(totalSeconds); }
        function getColor(pace, minPace, maxPace) { const ratio = (maxPace - pace) / (maxPace - minPace); const red = Math.round(255 * (1 - ratio)); const green = Math.round(255 * ratio); return `rgb(${red}, ${green}, 100)`; }
        function formatTime2(seconds) { const hrs = Math.floor(seconds / 3600); const mins = Math.floor((seconds % 3600) / 60); const secs = Math.round(seconds % 60); return (hrs > 0 ? String(hrs).padStart(2, '0') + ':' : '') + String(mins).padStart(2, '0') + ':' + String(secs).padStart(2, '0'); }
        function paceFromSpeed(speed) { if (speed <= 0) return '–'; const paceSecondsPerKm = 1000 / speed; const mins = Math.floor(paceSecondsPerKm / 60); const secs = Math.round(paceSecondsPerKm % 60); return `${mins}:${secs.toString().padStart(2, '0')} min/km`; }
        
        // --- MAP INITIALIZATION ---
        const coordinates = <%=workoutData.WorkoutCoordsJsonStr%>;
        // Removed the coordinate flip. Assuming workoutData.WorkoutCoordsJsonStr provides [lat, lng] directly.
        const routeCoordinates = removeZeroCoordinates(coordinates); 
        
        if (routeCoordinates.length > 0) {
            const map = L.map('map').setView(getBestCenterCoordinate(routeCoordinates), getBestZoomLevel(routeCoordinates));
            // Changed tile layer to OpenStreetMap for better reliability
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                maxZoom: 19
            }).addTo(map);
            L.polyline(routeCoordinates, { color: '#1E90FF', weight: 4, opacity: 1 }).addTo(map);
            // Fit map to bounds of the polyline for better visibility
            map.fitBounds(L.polyline(routeCoordinates).getBounds());
        }


        // --- D3 LAPS CHART ---
        const laps = <%=workoutLapsJsonString%>;
        if (laps && laps.length > 0) {
            const minPace = Math.min(...laps.map(l => l.pace));
            const maxPace = Math.max(...laps.map(l => l.pace));
            // Moved margin definition before its usage
            const margin = { top: 20, right: 30, bottom: 20, left: 40 };
            // Adjusted width to be responsive to the container, height for better visibility
            const width = document.getElementById('chart').clientWidth - margin.left - margin.right; // `margin` is now defined here
            const height = 300; // Keep height fixed for now, can be made responsive if needed
            
            const svg = d3.select("#chart").append("svg").attr("viewBox", `0 0 ${width + margin.left + margin.right} ${height + margin.top + margin.bottom}`).append("g").attr("transform", `translate(${margin.left}, ${margin.top})`);
            const xScale = d3.scaleLinear().domain([0, d3.sum(laps, d => d.duration)]).range([0, width]);
            const heightScale = d3.scaleLinear().domain([maxPace, minPace]).range([20, height]); // Adjusted minHeight to 20 for better visual range
            let cumulativeTime = 0;
            const tooltip = d3.select("#tooltip");

            svg.selectAll(".bar").data(laps).enter().append("rect")
                .attr("class", "bar").attr("x", d => { let p = cumulativeTime; cumulativeTime += d.duration; return xScale(p); })
                .attr("y", d => height - heightScale(d.pace)).attr("width", d => xScale(d.duration)).attr("height", d => heightScale(d.pace))
                .attr("fill", d => getColor(d.pace, minPace, maxPace))
                .on("mouseover", function(event, d) { tooltip.style("display", "block").html(`Lap ${laps.indexOf(d) + 1}<br>Duration: ${formatTime(d.duration)}<br>Pace: ${formatPace(d.pace)} min/km`).style("left", `${event.pageX + 10}px`).style("top", `${event.pageY - 20}px`); })
                .on("mousemove", function(event) { tooltip.style("left", `${event.pageX + 10}px`).style("top", `${event.pageY - 20}px`); })
                .on("mouseout", function() { tooltip.style("display", "none"); });
        }

        // --- CHART.JS GRAPHS ---
        if (<%=workoutData.DataSamples != null ? "true" : "false"%>) {
            const jsonData = <%=GetDataSamplesJson()%>;

            const commonOptions = {
                responsive: true,
                maintainAspectRatio: false,
                parsing: false,
                scales: {
                    x: {
                        type: 'linear',
                        title: { display: true, text: 'Time', color: 'white' },
                        ticks: { color: 'white', callback: value => formatTime2(Math.floor(value)) },
                        grid: { color: 'rgba(255, 255, 255, 0.1)' }
                    },
                    y: {
                        beginAtZero: false,
                        padding: { top: 20 },
                        ticks: { color: 'white' },
                        grid: { color: 'rgba(255, 255, 255, 0.1)' },
                        title: { display: true, color: 'white' }
                    }
                },
                plugins: {
                    legend: { labels: { color: 'white' } },
                    tooltip: { mode: 'nearest', intersect: false },
                    zoom: { pan: { enabled: true, mode: 'x' }, zoom: { wheel: { enabled: true }, pinch: { enabled: true }, mode: 'x' } }
                },
                hover: { mode: 'nearest', intersect: false }
            };

            // Heart Rate Chart
            new Chart(document.getElementById('heartRateChart').getContext('2d'), {
                type: 'line', data: { datasets: [{ label: 'Heart Rate (bpm)', data: jsonData.map(d => ({ x: d.TimerDurationInSeconds, y: d.HeartRate })), borderColor: '#ff6384', backgroundColor: 'rgba(255, 99, 132, 0.2)', fill: true, tension: 0.4, pointRadius: 0 }] },
                options: { ...commonOptions, plugins: { ...commonOptions.plugins, tooltip: { ...commonOptions.plugins.tooltip, callbacks: { label: c => `${formatTime2(c.parsed.x)} - ${c.dataset.label}: ${c.parsed.y.toFixed(0)}` } } }, scales: { ...commonOptions.scales, y: { ...commonOptions.scales.y, title: { ...commonOptions.scales.y.title, text: 'Heart Rate (bpm)' } } } }
            });

            // Speed Chart
            new Chart(document.getElementById('speedChart').getContext('2d'), {
                type: 'line', data: { datasets: [{ label: 'Speed (m/s)', data: jsonData.map(d => ({ x: d.TimerDurationInSeconds, y: d.SpeedMetersPerSecond })), borderColor: '#4bc0c0', backgroundColor: 'rgba(75, 192, 192, 0.2)', fill: true, tension: 0.4, pointRadius: 0 }] },
                options: { ...commonOptions, plugins: { ...commonOptions.plugins, tooltip: { ...commonOptions.plugins.tooltip, callbacks: { label: c => `${formatTime2(c.parsed.x)} - ${c.dataset.label}: ${c.parsed.y.toFixed(2)} m/s (${paceFromSpeed(c.parsed.y)})` } } }, scales: { ...commonOptions.scales, y: { ...commonOptions.scales.y, title: { ...commonOptions.scales.y.title, text: 'Speed (m/s)' } } } }
            });

            // Elevation Chart
            new Chart(document.getElementById('elevationChart').getContext('2d'), {
                type: 'line', data: { datasets: [{ label: 'Elevation (m)', data: jsonData.map(d => ({ x: d.TimerDurationInSeconds, y: d.ElevationInMeters })), borderColor: '#36a2eb', backgroundColor: 'rgba(54, 162, 235, 0.2)', fill: true, tension: 0.4, pointRadius: 0 }] },
                options: { ...commonOptions, plugins: { ...commonOptions.plugins, tooltip: { ...commonOptions.plugins.tooltip, callbacks: { label: c => `${formatTime2(c.parsed.x)} - ${c.dataset.label}: ${c.parsed.y.toFixed(1)}m` } } }, scales: { ...commonOptions.scales, y: { ...commonOptions.scales.y, title: { ...commonOptions.scales.y.title, text: 'Elevation (m)' } } } }
            });
        }
    </script>
</asp:Content>



