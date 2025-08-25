<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="PlannedWorkout.aspx.cs" Inherits="GooseNet.PlannedWorkout1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://d3js.org/d3.v7.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css">
    <title><%=Request.QueryString["userName"] %> - Planned Workout</title>
    <style>
        /* Custom styles for the gradient text animation, adapted for Tailwind context */
        .gradient-text {
            background: linear-gradient(to right, #ff7e5f, #feb47b, #6a11cb, #2575fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            color: transparent; /* Fallback for browsers not supporting background-clip */
            animation: gradientAnimation 3s ease-in-out infinite;
        }

        @keyframes gradientAnimation {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        /* D3.js bar chart specific styles */
        .bar {
            stroke: rgba(255, 255, 255, 0.2); /* Lighter stroke for dark background */
            stroke-width: 1px;
        }
        /* Removed .tooltip style */
        /* Leaflet map attribution removal */
        .leaflet-control-attribution {
            display: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        
    <div class="container mx-auto px-4 py-8 max-w-2xl">
        <div class="glass-panel rounded-xl p-6 md:p-8 shadow-lg">
            <h3 class="text-xl font-bold text-white mb-2"><%=Request.QueryString["userName"] %></h3>
            <h2 class="text-3xl font-extrabold text-blue-300 mb-2"><%=workout.WorkoutName %></h2>
            <h3 class="text-lg text-gray-400 mb-6"><%=workout.Date %></h3>
            
            <h4 class="text-xl font-semibold text-white mb-4">Workout Laps:</h4>
            <div class="bar-container glass-panel p-4 rounded-xl shadow-inner mb-6">
                <div id="chart" class="w-full h-64"></div>
            </div>
            
            <div>
                <h3 class="text-xl font-semibold text-white mb-2 flex items-center space-x-2">
                    <span>Workout Description</span>
                </h3>
                <span class="text-lg text-gray-300 leading-relaxed">
                    <%=workoutText.Replace("\n","<br/>").Replace('*','x').Replace("run","Run").Replace("rest","Rest") %>
                </span>
            </div>
        </div>
    </div>
    <%-- Removed Tooltip div --%>

    <script>
        const lapsRequest = new XMLHttpRequest();
        let laps = []; // Changed from const to let for reassignment

        // Fetch laps data synchronously (as in original code)
        const workoutId = new URLSearchParams(window.location.search).get("workoutId");
        lapsRequest.open("GET", "GetPlannedLapsById.aspx?workoutID=" + workoutId, false);
        lapsRequest.send();

        if (lapsRequest.status === 200) {
            try {
                laps = JSON.parse(lapsRequest.responseText);
            } catch (e) {
                console.error("Error parsing laps JSON:", e);
                laps = []; // Ensure laps is an empty array on error
            }
        } else {
            console.error("Failed to fetch laps data:", lapsRequest.status);
            laps = []; // Ensure laps is an empty array on error
        }

        if (laps && laps.length > 0) {
            const minPace = Math.min(...laps.map(l => l.pace));
            const maxPace = Math.max(...laps.map(l => l.pace));
            const minHeight = 20; // Ensures slowest lap is still visible
            const maxHeight = 200; // Set max height for the fastest lap

            const margin = { top: 20, right: 30, bottom: 20, left: 40 };
            // Dynamically calculate width based on container
            const chartContainerElement = document.getElementById('chart');
            const width = chartContainerElement.clientWidth - margin.left - margin.right;
            const height = 300; // Fixed height for the chart area

            function formatTime(seconds) {
                const minutes = Math.floor(seconds / 60);
                const secs = seconds % 60;
                return `${minutes}:${secs.toString().padStart(2, '0')}`;
            }

            function formatPace(pace) {
                const totalSeconds = Math.floor(pace * 60);
                return formatTime(totalSeconds);
            }

            // Adjusted getColor to provide better contrast on a dark background
            function getColor(pace) {
                // Interpolate between two colors, e.g., blue for faster, red for slower
                const ratio = (pace - minPace) / (maxPace - minPace); // 0 for fastest, 1 for slowest
                const r = Math.round(255 * ratio); // More red for slower
                const g = Math.round(255 * (1 - ratio)); // More green for faster
                const b = 150; // Constant blue component
                return `rgb(${r}, ${g}, ${b})`;
            }

            const svg = d3.select("#chart")
                .append("svg")
                .attr("viewBox", `0 0 ${width + margin.left + margin.right} ${height + margin.top + margin.bottom}`)
                .attr("preserveAspectRatio", "xMidYMid meet") // Make SVG responsive
                .append("g")
                .attr("transform", `translate(${margin.left}, ${margin.top})`);

            const xScale = d3.scaleLinear()
                .domain([0, d3.sum(laps, d => d.duration)])
                .range([0, width]);

            const heightScale = d3.scaleLinear()
                .domain([maxPace, minPace]) // Ensuring faster paces are taller
                .range([minHeight, maxHeight]);

            let cumulativeTime = 0;
            // Removed tooltip variable declaration

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
                .attr("y", d => height - heightScale(d.pace)) // Invert height logic
                .attr("width", d => xScale(d.duration))
                .attr("height", d => heightScale(d.pace)) // Ensuring fastest is tallest
                .attr("fill", d => getColor(d.pace))
            // Removed mouseover, mousemove, and mouseout event listeners
        }
    </script>
</asp:Content>
