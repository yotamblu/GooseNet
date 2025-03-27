<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="PlannedWorkout.aspx.cs" Inherits="GooseNet.PlannedWorkout1" %>
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

     .gradient-text {
         margin-left:2vw;
            font-size: 1rem;
            font-weight: bold;
            background: linear-gradient(to right, #ff7e5f, #feb47b, #6a11cb, #2575fc);
            -webkit-background-clip: text;
            color: transparent;
            text-align: center;
            animation: gradientAnimation 3s ease-in-out infinite;
           font-family: Arial, sans-serif;
        }

        @keyframes gradientAnimation {
            0% {
                background-position: 0% 50%;
            }
            50% {
                background-position: 100% 50%;
            }
            100% {
                background-position: 0% 50%;
            }
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        
<div class="container">
        <h3 style="display:inline;"><%=Request.QueryString["userName"] %></h3>
        <h2><%=workout.WorkoutName %></h2>
        <h3 style="color:dimgray"><%=workout.Date %></h3>
        <br/>
       

         <h4 style="color:black;">Workout Laps:</h4>   
        <center>
        <div class="bar-container">      <div id="chart"></div>
        
            
         

            </center>
        
             <div>
                <h3>Workout Description<span class="gradient-text">Constructed by AI</span>
            </h3>  
                 <span style="color:black;font-size:1.5vw;">
                                     <%=workoutText.Replace("\n","<br/>" ).Replace('*','x').Replace("run","Run").Replace("rest","Rest") %>

                 </span>
            </div>
        

    </div>
    <script>

        const lapsRequest = new XMLHttpRequest();
        laps = []

        lapsRequest.onload = () => {
            laps = JSON.parse(lapsRequest.responseText);
        }

        workoutId = new URLSearchParams(window.location.search).get("workoutId")
        lapsRequest.open("GET", "GetPlannedLapsById.aspx?workoutID=" + workoutId,false)
        lapsRequest.send();

          

        

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
