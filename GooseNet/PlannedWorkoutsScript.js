const datePicker = document.getElementById('dateInput');
const workoutContainer = document.getElementById('workoutContainer');

datePicker.addEventListener('change', () => {
    workoutsRequest = new XMLHttpRequest();
    workoutsRequest.onload = () => {
        newDiv = document.createElement("div");
        newDiv.innerHTML = workoutsRequest.responseText
        workoutContainer.innerHTML = newDiv.innerHTML;
    };
    athleteName =new URLSearchParams(window.location.search).get("athleteName")

    workoutsRequest.open("GET", "GetPlannedWorkouts.aspx?athleteName=" + athleteName + "&CoachName=CoachTest&date=" + datePicker.value, false);
    workoutsRequest.send();


    for (i = 1; true; i++) {
        currentChart = document.getElementById("chart-" + i.toString())
        if (currentChart == null) {

            break;
        } else {

            let lapsRequest = new XMLHttpRequest();

            let workoutId = document.getElementById("workoutID-" + i.toString()).innerHTML;
            let laps = [{duration:100,pace:5}];

            lapsRequest.onload = () => {
                console.log(lapsRequest.responseText)
                laps = JSON.parse(lapsRequest.responseText);

            }
            lapsRequest.open("GET", "GetPlannedLapsById.aspx?workoutId=" + workoutId, false);
            lapsRequest.send();
            const minPace = Math.min(...laps.map(l => l.pace));
            const maxPace = Math.max(...laps.map(l => l.pace));
            const minHeight = 20; // Ensures slowest lap is still visible
            const maxHeight = 200; // Set max height for the fastest lap
            const width = 600;
            const height = 300;
            const margin = { top: 20, right: 30, bottom: 20, left: 40 };

            let svg = d3.select("#chart-" + i.toString())
                .append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", `translate(${margin.left}, ${margin.top})`);

            let xScale = d3.scaleLinear()
                .domain([0, d3.sum(laps, d => d.duration)])
                .range([0, width]);

            let heightScale = d3.scaleLinear()
                .domain([maxPace, minPace]) // Ensuring faster paces are taller
                .range([minHeight, maxHeight]);

            let cumulativeTime = 0;

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
                .attr("fill", d => getColor(d.pace, maxPace,minPace));


        }
    }

});

   
    



    function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${minutes}:${secs.toString().padStart(2, '0')}`;
}

    function formatPace(pace) {
    const totalSeconds = Math.floor(pace * 60);
    return formatTime(totalSeconds);
}

    function getColor(pace,maxPace,minPace) {
    const ratio = (maxPace - pace) / (maxPace - minPace);
    const red = Math.round(255 * ratio);
    const green = Math.round(255 * ratio + 200); // Shift towards white for slower paces
    return `rgb(${red}, ${green}, 100)`;
    }






