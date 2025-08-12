<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AthleteSleep.aspx.cs" Inherits="GooseNet.AthleteSleep" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%-- Removed original inline style block. All styles are now handled by Tailwind classes. --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
    <title><%=Request.QueryString["athleteName"] %> - Sleep Data</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container mx-auto px-4 py-8 max-w-4xl">
        <h1 class="text-4xl font-extrabold text-white mb-8 text-center">Sleep Data for <%=Request.QueryString["athleteName"] %></h1>

        <div class="glass-panel rounded-xl p-6 md:p-8 mb-8 shadow-lg flex flex-col items-center">
            <label for="datePicker" class="block text-white text-lg font-semibold mb-2">Select Date:</label>
            <input type="date" id="datePicker"
                   class="w-full max-w-xs p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400" />
        </div>

        <div id="placeholder" class="glass-panel rounded-xl p-8 text-center text-gray-300 font-semibold text-xl border-2 border-dashed border-white/30 shadow-inner mt-8">
            📅 Data will appear here once you pick a date.
        </div>

        <div id="sleepDataContainer" class="hidden">
            <%-- Content for sleep data will be injected here by JS --%>
        </div>
    </div>

    <script>
        // Chart.js plugin registration (moved to top of script for clarity)
        Chart.register(ChartDataLabels);

        function formatSecondsToHHMM(seconds) {
            const hours = Math.floor(seconds / 3600);
            const minutes = Math.floor((seconds % 3600) / 60);
            return `${hours}h ${minutes.toString().padStart(2, '0')}m`;
        }

        const dataContainer = document.getElementById('sleepDataContainer');
        const datePicker = document.getElementById('datePicker');
        const placeholder = document.getElementById("placeholder");
        let sleepStepsData = {};
        let sleepPieChartInstance = null; // To store Chart.js instance

        datePicker.addEventListener('change', () => {
            placeholder.style.display = 'none';
            dataContainer.innerHTML = `
                <div class="glass-panel rounded-xl p-8 text-center text-gray-300 font-semibold text-xl shadow-lg mt-8">
                    Loading sleep data...
                </div>
            `;
            dataContainer.style.display = 'block';

            const athleteName = "<%=Request.QueryString["athleteName"]%>";
            const selectedDate = datePicker.value;

            // Fetch HTML content
            const htmlRequest = new XMLHttpRequest();
            htmlRequest.onload = () => {
                if (htmlRequest.status === 200) {
                    dataContainer.innerHTML = htmlRequest.responseText;
                    fetchChartData(athleteName, selectedDate); // Fetch chart data after HTML is loaded
                } else {
                    dataContainer.innerHTML = `
                        <div class="glass-panel rounded-xl p-8 text-center text-red-400 font-semibold text-xl shadow-lg mt-8">
                            Error loading sleep data. Please try again.
                        </div>
                    `;
                }
            };
            htmlRequest.onerror = () => {
                dataContainer.innerHTML = `
                    <div class="glass-panel rounded-xl p-8 text-center text-red-400 font-semibold text-xl shadow-lg mt-8">
                        Network error. Could not load sleep data.
                    </div>
                `;
            };
            htmlRequest.open("GET", `GetSleepDataByDate.aspx?athleteName=${athleteName}&date=${selectedDate}`, true);
            htmlRequest.send();
        });

        function fetchChartData(athleteName, selectedDate) {
            const jsonRequest = new XMLHttpRequest();
            jsonRequest.onload = () => {
                if (jsonRequest.status === 200) {
                    try {
                        sleepStepsData = JSON.parse(jsonRequest.responseText);
                        renderSleepPieChart();
                    } catch (e) {
                        console.error("Error parsing JSON response:", e);
                        // Display error or fallback message if JSON is invalid
                        const chartSection = document.getElementById('sleepChartSection');
                        if (chartSection) chartSection.innerHTML = `<p class="text-red-400 text-center mt-4">Could not load chart data.</p>`;
                    }
                } else {
                    console.error("Failed to fetch JSON data:", jsonRequest.status);
                    const chartSection = document.getElementById('sleepChartSection');
                    if (chartSection) chartSection.innerHTML = `<p class="text-red-400 text-center mt-4">Could not load chart data.</p>`;
                }
            };
            jsonRequest.onerror = () => {
                console.error("Network error fetching JSON data.");
                const chartSection = document.getElementById('sleepChartSection');
                if (chartSection) chartSection.innerHTML = `<p class="text-red-400 text-center mt-4">Network error loading chart data.</p>`;
            };
            jsonRequest.open("GET", `GetSleepDataByDate.aspx?athleteName=${athleteName}&date=${selectedDate}&json=true`, true);
            jsonRequest.send();
        }

        function renderSleepPieChart() {
            const labels = Object.keys(sleepStepsData);
            const data = Object.values(sleepStepsData);
            const total = data.reduce((a, b) => a + b, 0);

            const chartData = {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: [
                        'rgba(142, 68, 173, 0.7)', // Purple
                        'rgba(231, 76, 60, 0.7)',  // Red
                        'rgba(52, 152, 219, 0.7)', // Blue
                        'rgba(46, 204, 113, 0.7)'  // Green
                    ],
                    borderColor: 'rgba(255, 255, 255, 0.3)',
                    borderWidth: 1
                }]
            };

            const ctx = document.getElementById('sleepPieChart');
            if (!ctx) {
                console.error("Canvas element 'sleepPieChart' not found.");
                return;
            }

            if (sleepPieChartInstance) {
                sleepPieChartInstance.destroy(); // Destroy existing chart instance
            }

            sleepPieChartInstance = new Chart(ctx, {
                type: 'pie',
                data: chartData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    layout: {
                        padding: {
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0
                        }
                    },
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                color: 'white', // Legend text color
                                font: {
                                    size: 14
                                }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    const label = context.label || '';
                                    const value = context.raw;
                                    return `${label}: ${formatSecondsToHHMM(value)}`;
                                }
                            },
                            backgroundColor: 'rgba(0, 0, 0, 0.7)', // Tooltip background
                            titleColor: 'white', // Tooltip title color
                            bodyColor: 'white' // Tooltip body color
                        },
                        datalabels: {
                            color: '#fff', // Datalabel text color
                            formatter: (value, context) => {
                                const labels = context.chart?.data?.labels || [];
                                const label = labels[context.dataIndex] || '';
                                const percentage = (value / total * 100).toFixed(1);
                                // Only show label for non-Awake segments if percentage is significant
                                if (label === "Awake") {
                                    return `${percentage}%`;
                                } else if (percentage > 5) { // Only show label for segments larger than 5%
                                    return `${label}\n${percentage}%`;
                                }
                                return ''; // Hide label for very small segments
                            },
                            font: {
                                weight: 'bold',
                                size: 14
                            },
                            textShadowColor: 'rgba(0,0,0,0.5)', // Add text shadow for better readability
                            textShadowBlur: 4
                        }
                    }
                }
            });
        }

        // Set default date to today and trigger data load
        document.addEventListener('DOMContentLoaded', () => {
            const today = new Date();
            datePicker.value = today.toISOString().split('T')[0];
            datePicker.dispatchEvent(new Event('change')); // Trigger change event to load data
        });
    </script>
</asp:Content>
