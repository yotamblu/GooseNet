<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Workout.aspx.cs" Inherits="GooseNet.Workout1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://d3js.org/d3.v7.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css">
    <style>
       
         .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            border: 1px solid #ddd;

          
            }
         p ,strong , h3,h2,span  {color:black;}
    
        .map {
            width: 100%;
            height: 300px;
            margin-bottom: 20px;
        }
        .bar-container {
            display: flex;
            margin-top:-100px;
           justify-content: center;
            width: 100%;
            padding-top: -100px;
            /* position: relative;
            right: 1%; */
            height: fit-content;
     
        }
        .bar {
            stroke: #000;
            stroke-width: 1px;
        }
        .tooltip {
            position: absolute;
            background: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 5px;
            border-radius: 5px;
            font-size: 12px;
            display: none;
        }
        table {
      width: 80%;
      margin: 20px auto;
      border-collapse: collapse;
      background-color: #f4f7fa;
      border-radius: 8px;
      overflow: hidden;
    }
    
    /* Table Header Styling */
    th {
      background-color: #3498db;
      color: white;
      padding: 12px 15px;
      text-align: left;
      font-size: 16px;
    }
    
    /* Table Data Styling */
    td {
      padding: 10px 15px;
      text-align: left;
      font-size: 14px;
      color: #555;
    }
    
    /* Row Hover Effect */
    tr:hover {
        background-color: #e3f2fd !important;
        transform: scale(1.05); /* Slightly enlarge the row */
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2); /* Add shadow for the "pop out" effect */
        transition: transform 0.3s ease, background-color 0.3s ease, box-shadow 0.3s ease; /* Smooth transition */
    }

    
    /* Zebra Stripes Effect */
    tr:nth-child(even) {
      background-color: #fafafa;
    }
    
    tr:nth-child(odd) {
      background-color: #ffffff;
    }

    /* Table Border */
    td, th {
      border: 1px solid #ddd;
    }

    /* Add a shadow effect */
    table {
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    #shareBtn{
     
          
           float:right;
           background-color:black;
    }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        
<div class="container">
        <h2><%=workoutData.WokroutName %></h2><button id="shareBtn"><img width="20" src="Images/shareBtn.png"/></button>
        <p><strong>Distance:</strong> <%=(workoutData.WorkoutDistanceInMeters / 1000.0).ToString("#.##") %></p>
        <p><strong>Average Pace:</strong> <%=GooseNet.GooseNetUtils.ConvertMinutesToTimeString(workoutData.WorkoutAvgPaceInMinKm) %></p>
        <p><strong>Average Heart Rate:</strong> <%=workoutData.WorkoutAvgHR %> bpm</p>
        <br/>
        <h3>Workout Map:</h3>
        <div id="map" class="map"></div>
        <br/>
        <h3>

            Workout Laps:


        </h3>
        <center>
        <div class="bar-container">      <div id="chart"></div>
        <div id="tooltip" class="tooltip"></div></div>
        </center>



        
        <table class="lap-table">
            <thead>
                <tr>
                    <th>Lap</th>
                    <th>Distance</th>
                    <th>Time</th>
                    <th>Pace</th>
                </tr>
            </thead>
            <tbody>
               <%=GetLapTableRowsHTML() %>
            </tbody>
        </table>
    </div>
    <script>

        document.getElementById('shareBtn').addEventListener('click', () => {

            navigator.clipboard.writeText("check out this cool workout on GooseNet 🪿" + window.location.href);


        })

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


        const coordinates = <%=workoutData.WorkoutCoordsJsonStr%>
        routeCoordinates = removeZeroCoordinates(coordinates)
        const map = L.map('map').setView(getBestCenterCoordinate(routeCoordinates), getBestZoomLevel(routeCoordinates));

        // Add OpenStreetMap tiles
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);

        L.polyline(routeCoordinates, {
            color: 'red',
            weight: 4,
            opacity: 1,
        }).addTo(map);

       
        

        const laps =
           <%=workoutLapsJsonString%>;

        

        const minPace = Math.min(...laps.map(l => l.pace));
        const maxPace = Math.max(...laps.map(l => l.pace));
        const minHeight = 20; // Ensures slowest lap is still visible
        const maxHeight = 200; // Set max height for the fastest lap
        const width = 600;
        const height = 300;
        const margin = { top: 20, right: 30, bottom: 20, left: 40 };

        function formatTime(seconds) {
            const minutes = Math.floor(seconds / 60);
            const secs = seconds % 60;
            return `${minutes}:${secs.toString().padStart(2, '0')}`;
        }

        function formatPace(pace) {
            const totalSeconds = Math.floor(pace * 60);
            return formatTime(totalSeconds);
        }

        function getColor(pace) {
            const ratio = (maxPace - pace) / (maxPace - minPace);
            const red = Math.round(255 * ratio);
            const green = Math.round(255 * ratio + 200); // Shift towards white for slower paces
            return `rgb(${red}, ${green}, 100)`;
        }

        const svg = d3.select("#chart")
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", `translate(${margin.left}, ${margin.top})`);

        const xScale = d3.scaleLinear()
            .domain([0, d3.sum(laps, d => d.duration)])
            .range([0, width]);

        const heightScale = d3.scaleLinear()
            .domain([maxPace, minPace]) // Ensuring faster paces are taller
            .range([minHeight, maxHeight]);

        let cumulativeTime = 0;
        const tooltip = d3.select("#tooltip");

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
            .on("mouseover", function(event, d) {
                tooltip.style("display", "block")
                    .html(`Lap ${laps.indexOf(d) + 1}<br>Duration: ${formatTime(d.duration)}<br>Pace: ${formatPace(d.pace)} min/km`)
                    .style("left", `${event.pageX + 10}px`)
                    .style("top", `${event.pageY - 20}px`);
            })
            .on("mousemove", function(event) {
                tooltip.style("left", `${event.pageX + 10}px`)
                    .style("top", `${event.pageY - 20}px`);
            })
            .on("mouseout", function() {
                tooltip.style("display", "none");
            });

    </script>
</asp:Content>
