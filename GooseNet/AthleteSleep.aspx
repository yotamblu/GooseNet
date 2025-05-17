<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AthleteSleep.aspx.cs" Inherits="GooseNet.AthleteSleep" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
#sleepDataContainer {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  margin: 10%;
  margin-top:5%;
  padding: 20px;
  background: linear-gradient(135deg, #e0f7fa, #f5f5f5);
  border-radius:20px;
  display:none;
}

#sleepDataContainer .container {
  max-width: 1100px;
  margin: auto;
  background: white;
  padding: 30px;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease-in-out;
}

#sleepDataContainer .container:hover {
  transform: scale(1.01);
}

#sleepDataContainer h2 {
  margin-bottom: 20px;
  text-align: center;
  font-size: 32px;
  color: #2c3e50;
}

#sleepDataContainer .info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 15px;
  margin-bottom: 30px;
}

#sleepDataContainer .card {
 color:black;
  background: #e3f2fd;
  padding: 18px;
  border-radius: 12px;
  text-align: center;
  font-size: 16px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
  transition: transform 0.3s, background-color 0.3s;
  cursor: pointer;
}
 .placeholder {
      margin-top: 30px;
      padding: 20px;
      background-color: #ffffff;
      border: 2px dashed #bbb;
      border-radius: 10px;
      color: #888;
      font-size: 18px;
      transition: all 0.3s ease;
      box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }
#sleepDataContainer .card:hover {
  transform: translateY(-5px);
  background-color: #bbdefb;
}

#sleepDataContainer .score-card {
   color:black;
  background: #fff3e0;
}

#sleepDataContainer .score-card:hover {
  background-color: #ffe0b2
     color:black;

}

#sleepDataContainer .overall-score {
  background: #c8e6c9;
     color:black;

  font-weight: bold;
}

#sleepDataContainer .overall-score:hover {
       color:black;

  background-color: #a5d6a7;
}

#sleepDataContainer .chart-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin: 50px 0;
}

#sleepDataContainer #sleepPieChart {
  width: 100%;
  max-width: 550px;
  height: 100%;
  transition: transform 0.3s;
}

#sleepDataContainer #sleepPieChart:hover {
  transform: scale(1.05);
}

#sleepDataContainer .sleep-duration-display {
  font-size: 24px;
  font-weight: 600;
  color: #1abc9c;
  background-color: #ffffff;
  padding: 14px 30px;
  border: 4px dashed #1abc9c;
  border-radius: 50px;
  margin-bottom: 25px;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
  transition: background-color 0.3s, transform 0.3s;
}

#sleepDataContainer .sleep-duration-display:hover {
  background-color: #e0f2f1;
  transform: scale(1.05);
}

</style>
     <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
 <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
  <title><%=Request.QueryString["athleteName"] %> - Sleep Data</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input type="date" id="datePicker"/>

        <div id="placeholder" class="placeholder">📅 Data will appear here once you pick a date.</div>

    <div id="sleepDataContainer">

    </div>



    <script>
        function formatSecondsToHHMM(seconds) {
            const hours = Math.floor(seconds / 3600);
            const minutes = Math.floor((seconds % 3600) / 60);
            return `${hours}h ${minutes.toString().padStart(2, '0')}m`;
        }

        const dataContainer = document.getElementById('sleepDataContainer');
        const datePicker = document.getElementById('datePicker');
        const placheholder = document.getElementById("placeholder");
        let sleepStepsData = {};
        datePicker.addEventListener('change', () => {
            dataContainer.style.display = 'block';
            placheholder.style.display = 'none';
            const requestUrl = "GetSleepDataByDate.aspx?athleteName=<%=Request.QueryString["athleteName"]%>&date=" + datePicker.value.toString();
            const sleepDataRequest = new XMLHttpRequest();
            sleepDataRequest.onload = () => {
                dataContainer.innerHTML = sleepDataRequest.responseText;

            };
            sleepDataRequest.open("GET", requestUrl, false);
            sleepDataRequest.send()
            sleepDataRequest.onload = () => {
                sleepStepsData = JSON.parse(sleepDataRequest.responseText);
            };

            sleepDataRequest.open("GET", requestUrl + "&json=true", false);
            sleepDataRequest.send();

            const labels = Object.keys(sleepStepsData);
            const data = Object.values(sleepStepsData);
            const total = data.reduce((a, b) => a + b, 0);

            const chartData = {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: [
                        '#8E44AD',
                        '#E74C3C',
                        '#3498DB',
                        '#2ECC71'
                    ]
                }]
            };
            
            const config = {
                type: 'pie',
                data: chartData,
                options: {
                    maintainAspectRatio: false,
                    layout: {
                        padding: 0
                    },
                    plugins: {
                        legend: {
                            position: 'right'
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    const label = context.label || '';
                                    const value = context.raw;
                                    return `${label}: ${formatSecondsToHHMM(value)}`;
                                }
                            }
                        },
                        datalabels: {
                            color: '#fff',
                            formatter: (value, context) => {
                                const labels = context.chart?.data?.labels || [];
                                const label = labels[context.dataIndex] || '';
                                const percentage = (value / total * 100).toFixed(1);
                                return label === "Awake" ? `${percentage}%` : `${label}\n${percentage}%`;
                            },
                            font: {
                                weight: 'bold'
                            }
                        }
                    }
                },
                plugins: [ChartDataLabels]
            };

            new Chart(
                document.getElementById('sleepPieChart'),
                config
            );

        });



    </script>
</asp:Content>
